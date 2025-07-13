defmodule ChimeraCmsWeb.Admin.UploadController do
  use ChimeraCmsWeb, :controller

  def create(conn, %{"file" => file_params}) do
    case upload_file(file_params) do
      {:ok, file_path} ->
        conn
        |> put_status(:created)
        |> json(%{
          message: "File uploaded successfully",
          file_path: file_path,
          url: "/uploads/" <> Path.basename(file_path)
        })

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end

  defp upload_file(%Plug.Upload{} = upload) do
    # Create uploads directory if it doesn't exist
    uploads_dir = Path.join([Application.app_dir(:chimera_cms, "priv"), "static", "uploads"])
    File.mkdir_p(uploads_dir)

    # Generate unique filename
    extension = Path.extname(upload.filename)
    filename = "#{System.unique_integer()}_#{System.os_time()}" <> extension
    file_path = Path.join(uploads_dir, filename)

    case File.copy(upload.path, file_path) do
      {:ok, _} -> {:ok, file_path}
      {:error, reason} -> {:error, "Failed to save file: #{reason}"}
    end
  end

  defp upload_file(_), do: {:error, "Invalid file"}
end
