defmodule ChimeraCms.EtsSeeds do
  @moduledoc """
  Seeds module for populating ETS storage with initial data.
  Run with: ChimeraCms.EtsSeeds.run()
  """

  alias ChimeraCms.Accounts
  alias ChimeraCms.Portfolio
  alias ChimeraCms.Blog
  alias ChimeraCms.Resume

  def run do
    IO.puts("🌱 Starting ETS data seeding...")

    create_admin_user()
    create_portfolio_projects()
    create_blog_posts()
    create_work_experiences()

    IO.puts("✅ ETS seeding completed!")
  end

  defp create_admin_user do
    admin_user = %{
      email: System.get_env("ADMIN_EMAIL") || "admin@chimera.com",
      password: System.get_env("ADMIN_PASSWORD") || "admin123",
      first_name: "Admin",
      last_name: "User",
      role: "admin",
      active: true
    }

    case Accounts.register_user(admin_user) do
      {:ok, user} ->
        IO.puts("✅ Admin user created: #{user.email}")
      {:error, changeset} ->
        IO.puts("❌ Failed to create admin user: #{inspect(changeset.errors)}")
    end
  end

  defp create_portfolio_projects do
    projects = [
      %{
        title: "Interactive Portfolio Website",
        description: "A responsive, interactive portfolio showcasing my work with dynamic layouts, animations, and advanced React components.",
        overview: "This portfolio website is designed as both a showcase of my projects and a project itself. It features an interactive grid layout, custom animations, theme switching, and advanced React components.",
        problem: "Traditional portfolio websites often present work in a static, non-interactive way that doesn't effectively demonstrate a developer's capabilities.",
        solution: "I built this portfolio using React and Tailwind CSS with a focus on interactivity. Features include a draggable project grid, custom cursor effects, dark mode support, and animated transitions.",
        outcome: "The result is a portfolio that not only presents my work effectively but also serves as a living demonstration of my technical skills and UX sensibilities.",
        tags: ["React", "TailwindCSS", "Responsive Design", "React Grid Layout", "Custom Animations"],
        tech_stack: ["React", "TailwindCSS", "React Grid Layout", "React Icons"],
        image: "/portfolioweb.png",
        repo_url: "https://github.com/abdulmuhaimin-work/Project-Chimera",
        live_url: "https://abdulmuhaimin.my",
        timeline: "2 months",
        role: "Full Stack Developer",
        client: "Personal Project",
        featured: true,
        sort_order: 1
      },
      %{
        title: "E-Commerce Platform",
        description: "A full-featured e-commerce platform with advanced search, payment integration, and admin dashboard.",
        overview: "A comprehensive e-commerce solution built with modern web technologies, featuring product management, order processing, and customer management.",
        problem: "Small businesses need affordable, customizable e-commerce solutions that can scale with their growth.",
        solution: "Built a modular e-commerce platform using Phoenix LiveView for real-time updates, with integrated payment processing and inventory management.",
        outcome: "Successfully deployed for multiple small businesses, processing thousands of orders monthly with 99.9% uptime.",
        tags: ["Phoenix", "LiveView", "E-commerce", "Payment Processing", "Inventory Management"],
        tech_stack: ["Elixir", "Phoenix", "LiveView", "TailwindCSS", "PostgreSQL"],
        image: "/ecommerce.png",
        repo_url: "https://github.com/abdulmuhaimin-work/ecommerce-platform",
        live_url: "https://shop-demo.example.com",
        timeline: "4 months",
        role: "Lead Developer",
        client: "Various Small Businesses",
        featured: true,
        sort_order: 2
      },
      %{
        title: "Real-time Chat Application",
        description: "A scalable real-time chat application with rooms, direct messaging, and file sharing capabilities.",
        overview: "A modern chat application supporting multiple chat rooms, private messaging, file uploads, and real-time notifications.",
        problem: "Need for a custom chat solution with specific business requirements not met by existing platforms.",
        solution: "Developed using Phoenix Channels for WebSocket connections, with presence tracking and message persistence.",
        outcome: "Deployed for internal company use, supporting 500+ concurrent users with sub-100ms message delivery.",
        tags: ["Phoenix", "WebSockets", "Real-time", "Chat", "File Upload"],
        tech_stack: ["Elixir", "Phoenix", "Phoenix Channels", "React", "TailwindCSS"],
        image: "/chat-app.png",
        repo_url: "https://github.com/abdulmuhaimin-work/chat-app",
        live_url: "https://chat.example.com",
        timeline: "3 months",
        role: "Backend Developer",
        client: "Tech Startup",
        featured: false,
        sort_order: 3
      }
    ]

    Enum.each(projects, fn project_attrs ->
      case Portfolio.create_project(project_attrs) do
        {:ok, project} ->
          IO.puts("✅ Created project: #{project.title}")
        {:error, changeset} ->
          IO.puts("❌ Failed to create project: #{inspect(changeset.errors)}")
      end
    end)
  end

  defp create_blog_posts do
    posts = [
      %{
        title: "Why I Chose Elixir for My Latest Project",
        content: """
        Elixir has become my go-to language for building scalable, fault-tolerant applications.
        In this post, I'll share why I chose Elixir for my latest project and what benefits it brought.

        ## Concurrency and Fault Tolerance

        The Actor model and supervision trees make Elixir incredibly robust...

        ## Performance

        With the BEAM VM's lightweight processes, handling millions of connections becomes feasible...

        ## Developer Experience

        Pattern matching, pipe operators, and functional programming concepts make code more readable...
        """,
        excerpt: "Exploring why Elixir is perfect for building scalable, fault-tolerant applications and my experience using it in production.",
        featured_image: "/elixir-blog.jpg",
        published: true,
        tags: ["Elixir", "Functional Programming", "Concurrency", "BEAM", "Phoenix"]
      },
      %{
        title: "Building Real-time Applications with Phoenix LiveView",
        content: """
        Phoenix LiveView has revolutionized how we build interactive web applications.
        Let me walk you through creating a real-time dashboard.

        ## Getting Started

        Setting up LiveView is straightforward...

        ## State Management

        LiveView handles state on the server side...

        ## Real-time Updates

        Using Phoenix PubSub for live updates...
        """,
        excerpt: "A comprehensive guide to building interactive real-time web applications using Phoenix LiveView.",
        featured_image: "/liveview-blog.jpg",
        published: true,
        tags: ["Phoenix", "LiveView", "Real-time", "Web Development", "Elixir"]
      },
      %{
        title: "Draft: The Future of Web Development",
        content: """
        This is a draft post about emerging trends in web development.

        ## WebAssembly

        The potential of running languages like Rust in the browser...

        ## Edge Computing

        Moving computation closer to users...
        """,
        excerpt: "Exploring emerging trends and technologies shaping the future of web development.",
        featured_image: "/future-web.jpg",
        published: false,
        tags: ["Web Development", "Future Tech", "WebAssembly", "Edge Computing"]
      }
    ]

    Enum.each(posts, fn post_attrs ->
      case Blog.create_post(post_attrs) do
        {:ok, post} ->
          IO.puts("✅ Created post: #{post.title}")
        {:error, changeset} ->
          IO.puts("❌ Failed to create post: #{inspect(changeset.errors)}")
      end
    end)
  end

  defp create_work_experiences do
    experiences = [
      %{
        title: "Senior Software Engineer",
        company: "TechCorp Solutions",
        period: "2022 - Present",
        description: """
        Leading a team of 5 developers in building scalable web applications using Elixir and Phoenix.
        Responsible for architecture decisions, code reviews, and mentoring junior developers.
        Successfully delivered 3 major projects on time and under budget.
        """,
        technologies: ["Elixir", "Phoenix", "PostgreSQL", "React", "Docker", "AWS"],
        sort_order: 1
      },
      %{
        title: "Full Stack Developer",
        company: "StartupXYZ",
        period: "2020 - 2022",
        description: """
        Developed the core platform features for a fast-growing SaaS startup.
        Built RESTful APIs, implemented real-time features, and created responsive user interfaces.
        Contributed to scaling the platform from 100 to 10,000+ users.
        """,
        technologies: ["Node.js", "Express", "MongoDB", "React", "Redis", "Kubernetes"],
        sort_order: 2
      },
      %{
        title: "Frontend Developer",
        company: "Digital Agency Pro",
        period: "2018 - 2020",
        description: """
        Created responsive websites and web applications for various clients.
        Specialized in React development and modern CSS frameworks.
        Collaborated closely with designers to implement pixel-perfect designs.
        """,
        technologies: ["React", "JavaScript", "HTML5", "CSS3", "Sass", "Webpack"],
        sort_order: 3
      }
    ]

    Enum.each(experiences, fn experience_attrs ->
      case Resume.create_work_experience(experience_attrs) do
        {:ok, experience} ->
          IO.puts("✅ Created work experience: #{experience.title} at #{experience.company}")
        {:error, changeset} ->
          IO.puts("❌ Failed to create work experience: #{inspect(changeset.errors)}")
      end
    end)
  end
end
