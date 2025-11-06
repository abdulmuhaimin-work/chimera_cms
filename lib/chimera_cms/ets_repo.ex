defmodule ChimeraCms.EtsRepo do
  @moduledoc """
  ETS-based repository that replaces Ecto.Repo.
  Provides the same API as Ecto.Repo but uses in-memory ETS tables with disk persistence.
  """

  use GenServer
  require Logger

  # ETS tables for each entity
  @tables [:users, :posts, :projects, :work_experiences]
  @counters_table :id_counters

  ## Public API (mimicking Ecto.Repo)

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Gets a single record by ID. Returns nil if not found.
  """
  def get(schema_module, id) do
    table = get_table_name(schema_module)
    # Convert string IDs to integers for ETS lookup
    numeric_id = case id do
      id when is_binary(id) -> String.to_integer(id)
      id when is_integer(id) -> id
      _ -> id
    end

    case :ets.lookup(table, numeric_id) do
      [{^numeric_id, record}] -> record
      [] -> nil
    end
  end

  @doc """
  Gets a single record by ID. Raises if not found.
  """
  def get!(schema_module, id) do
    case get(schema_module, id) do
      nil -> raise "Record with id #{id} not found"
      record -> record
    end
  end

  @doc """
  Gets all records for a schema.
  """
  def all(schema_module) do
    table = get_table_name(schema_module)
    :ets.tab2list(table)
    |> Enum.map(fn {_id, record} -> record end)
    |> Enum.sort_by(& &1.inserted_at, {:desc, DateTime})
  end

  @doc """
  Inserts a new record using a changeset.
  """
  def insert(changeset) do
    if changeset.valid? do
      table = get_table_name(changeset.data.__struct__)
      id = next_id(table)

      now = DateTime.utc_now()

      # Convert changeset.data to map and merge with changes
      base_data = changeset.data |> Map.from_struct()
      changes_map = changeset.changes |> Map.new()

      record_data = Map.merge(base_data, changes_map)
      |> Map.put(:id, id)
      |> Map.put(:inserted_at, now)
      |> Map.put(:updated_at, now)

      record = struct(changeset.data.__struct__, record_data)

      :ets.insert(table, {id, record})
      {:ok, record}
    else
      {:error, changeset}
    end
  end

  @doc """
  Updates a record using a changeset.
  """
  def update(changeset) do
    if changeset.valid? do
      table = get_table_name(changeset.data.__struct__)
      id = changeset.data.id

      base_data = changeset.data |> Map.from_struct()
      changes_map = changeset.changes |> Map.new()

      updated_data = Map.merge(base_data, changes_map)
      |> Map.put(:updated_at, DateTime.utc_now())

      updated_record = struct(changeset.data.__struct__, updated_data)

      :ets.insert(table, {id, updated_record})
      {:ok, updated_record}
    else
      {:error, changeset}
    end
  end

  @doc """
  Deletes a record.
  """
  def delete(record) do
    table = get_table_name(record.__struct__)
    :ets.delete(table, record.id)
    {:ok, record}
  end

  @doc """
  Finds records by a field value.
  """
  def get_by(schema_module, field, value) do
    all(schema_module)
    |> Enum.find(&(Map.get(&1, field) == value))
  end

  @doc """
  Manually trigger save to disk.
  """
  def save_to_disk do
    GenServer.call(__MODULE__, :save_to_disk)
  end

  ## GenServer callbacks

    def init(_opts) do
    Logger.info("🚀 ETS Repository starting...")

    # Load persisted data if it exists, otherwise create empty tables
    data_exists = load_from_disk()
    Logger.info("📁 Data loaded from disk: #{data_exists}")

    # Create any tables that weren't loaded from disk
    unless data_exists do
      Logger.info("📋 Creating empty tables...")
      create_empty_tables()
    end

    # Check if tables are empty and seed if needed
    # This runs even if data was loaded from disk, in case the saved data was empty
    Logger.info("🌱 Checking if seeding is needed...")
    seed_if_empty()

    # Log table sizes for debugging
    Enum.each(@tables, fn table ->
      size = :ets.info(table, :size)
      Logger.info("📊 Table #{table}: #{size} records")
    end)

    # Auto-save every 30 seconds
    schedule_save()

    Logger.info("✅ ETS Repository initialized with tables: #{inspect(@tables)}")
    {:ok, %{}}
  end

  def handle_info(:save_to_disk, state) do
    save_to_disk_impl()
    schedule_save()
    {:noreply, state}
  end

  def handle_call(:save_to_disk, _from, state) do
    result = save_to_disk_impl()
    {:reply, result, state}
  end

  ## Private functions

  defp get_table_name(ChimeraCms.Accounts.User), do: :users
  defp get_table_name(ChimeraCms.Blog.Post), do: :posts
  defp get_table_name(ChimeraCms.Portfolio.Project), do: :projects
  defp get_table_name(ChimeraCms.Resume.WorkExperience), do: :work_experiences

  defp next_id(table) do
    :ets.update_counter(@counters_table, table, 1)
  end

  defp schedule_save do
    Process.send_after(self(), :save_to_disk, 30_000)
  end

  defp save_to_disk_impl do
    try do
      File.mkdir_p!("priv/data")

      Enum.each(@tables, fn table ->
        file_path = "priv/data/#{table}.ets"
        :ets.tab2file(table, String.to_charlist(file_path))
      end)

      # Save counters too
      :ets.tab2file(@counters_table, 'priv/data/counters.ets')

      Logger.debug("ETS data saved to disk")
      :ok
    rescue
      error ->
        Logger.error("Failed to save ETS data: #{inspect(error)}")
        {:error, error}
    end
  end

      defp create_empty_tables do
    # Create ETS tables
    Enum.each(@tables, fn table ->
      :ets.new(table, [:set, :public, :named_table])
    end)

    # Table for auto-incrementing IDs
    :ets.new(@counters_table, [:set, :public, :named_table])

    # Initialize counters (start at 0 so first record gets ID 1)
    Enum.each(@tables, fn table ->
      :ets.insert(@counters_table, {table, 0})
    end)

    Logger.info("Created empty ETS tables")
  end

  defp seed_if_empty do
    # Check if all tables are empty (except counters)
    all_empty = Enum.all?(@tables, fn table ->
      :ets.info(table, :size) == 0
    end)

    if all_empty do
      Logger.info("ETS tables are empty, auto-seeding initial data...")

      # Run seeding synchronously to ensure data is available before accepting requests
      # This prevents the issue where API returns empty arrays on first request after wake-up
      try do
        ChimeraCms.EtsSeeds.run()
        Logger.info("✅ Initial data seeding completed successfully")
      rescue
        error ->
          Logger.error("❌ Failed to seed initial data: #{inspect(error)}")
      end
    end
  end

    defp load_from_disk do
    # Load data tables
    data_loaded = Enum.reduce(@tables, false, fn table, acc ->
      file_path = "priv/data/#{table}.ets"
      if File.exists?(file_path) do
        case :ets.file2tab(String.to_charlist(file_path)) do
          {:ok, ^table} ->
            count = :ets.info(table, :size)
            Logger.info("Loaded #{count} records for #{table} from disk")
            true
          {:error, reason} ->
            Logger.warning("Failed to load #{table}: #{inspect(reason)}")
            acc
        end
      else
        acc
      end
    end)

    # Load counters
    data_loaded = if File.exists?("priv/data/counters.ets") do
      case :ets.file2tab('priv/data/counters.ets') do
        {:ok, @counters_table} ->
          count = :ets.info(@counters_table, :size)
          Logger.info("Loaded #{count} counters from disk")
          true
        {:error, reason} ->
          Logger.warning("Failed to load counters: #{inspect(reason)}")
          data_loaded
      end
    else
      data_loaded
    end

    data_loaded
  end
end
