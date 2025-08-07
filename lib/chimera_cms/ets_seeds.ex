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
        id: 1,
        title: "Interactive Portfolio Website",
        description: "A responsive, interactive portfolio showcasing my work with dynamic layouts, animations, and advanced React components.",
        overview: "This portfolio website is designed as both a showcase of my projects and a project itself. It features an interactive grid layout, custom animations, theme switching, and advanced React components to create an engaging user experience that demonstrates my frontend development capabilities.",
        problem: "Traditional portfolio websites often present work in a static, non-interactive way that doesn't effectively demonstrate a developer's capabilities, especially in dynamic UI development and state management.",
        solution: "I built this portfolio using React and Tailwind CSS with a focus on interactivity. Features include a draggable projects grid, custom cursor effects, dark mode support, lazy-loaded images, 3D animations, and animated transitions between sections.",
        outcome: "The result is a portfolio that not only presents my work effectively but also serves as a living demonstration of my technical skills, UX sensibilities, and attention to detail in frontend development.",
        tags: ["React", "TailwindCSS", "Responsive Design", "React Grid Layout", "3D Animations"],
        tech_stack: ["React", "TailwindCSS", "React Grid Layout", "ThreeJS"],
        image: "/portfolioweb.png",
        repo_url: "https://github.com/abdulmuhaimin-work/Project-Chimera",
        live_url: "https://abdulmuhaimin.my",
        timeline: "2 months",
        role: "Full-stack Developer",
        client: "Personal Project",
        featured: true,
        sort_order: 1,
        inserted_at: "2025-07-20T08:53:55Z",
        updated_at: "2025-07-20T08:53:55Z"
      },
      %{
        id: 2,
        title: "SERV Sfera Auto",
        description: "A comprehensive web app for auto workshop management with secure authentication and role-based access control",
        overview: "SERV Sfera Auto is a comprehensive web application designed to streamline the daily operations of auto workshop owners and their customers. The platform provides tools for appointment scheduling, service tracking, inventory management, and customer communication. The system features secure authentication and role-based access control to protect sensitive business and customer data.",
        problem: "Auto workshop owners faced challenges with manual booking systems, difficulty tracking service history, and inefficient inventory management, leading to lost revenue and customer dissatisfaction.",
        solution: "We developed a centralized platform that digitizes all aspects of workshop management, allowing owners to track appointments, manage inventory, and communicate with customers through a single interface.",
        outcome: "The application resulted in a reduction in administrative tasks, improvement in customer satisfaction, and an increase in revenue for workshop owners through better inventory management and appointment scheduling.",
        tags: ["ReactJS", "Firebase", "Bootstrap", "Cloudfunction"],
        tech_stack: ["ReactJS", "Firebase", "Bootstrap", "Cloudfunction"],
        image: "/SferaAuto.PNG",
        repo_url: nil,
        live_url: "https://business.sfera.ai",
        timeline: "6 months",
        role: "Frontend Developer",
        client: "Sfera Auto",
        featured: true,
        sort_order: 2,
        inserted_at: "2025-07-20T08:53:55Z",
        updated_at: "2025-07-20T08:53:55Z"
      },
      %{
        id: 3,
        title: "Stripe Payment Server",
        description: "Back-end API for the payment system to integrate the payment of our various apps with the Stripe payment system.",
        overview: "A centralized payment processing server that integrates multiple company applications with Stripe, handling transactions, subscriptions, and payment analytics in a secure environment.",
        problem: "The company had multiple applications but no ways to subscribe or buy their product yet.",
        solution: "We created a unified payment API that interfaces with Stripe, allowing all company applications to process payments through a single, secure channel with consistent behavior and centralized reporting.",
        outcome: "The system has processed transactions, reduced payment-related customer support tickets, and simplified financial reconciliation processes.",
        tags: ["ExpressJS", "NodeJS", "MongoDB", "Stripe", "Payment"],
        tech_stack: ["ExpressJS", "NodeJS", "MongoDB"],
        image: "/project-2.jpg",
        repo_url: nil,
        live_url: nil,
        timeline: "3 months",
        role: "Backend Developer",
        client: "Internal Project",
        featured: false,
        sort_order: 3,
        inserted_at: "2025-07-20T08:53:56Z",
        updated_at: "2025-07-20T08:53:56Z"
      },
      %{
        id: 4,
        title: "Autonomous Vehicle Dashboard",
        description: "Tasked with developing the dashboard for displaying data that was pulled from our autonomous vehicle",
        overview: "A real-time monitoring dashboard for autonomous vehicle data, providing engineers and operators with critical insights into vehicle performance, sensor readings, and system health.",
        problem: "Engineers needed a way to visualize and analyze complex data streams from autonomous vehicles during testing, with the ability to spot anomalies and issues in real-time.",
        solution: "We developed a responsive dashboard that processes and visualizes telemetry data from multiple vehicle sensors, that is uploaded to the cloud every 10 seconds.",
        outcome: "The dashboard improved debugging efficiency, and became an essential tool for the autonomous vehicle development team.",
        tags: ["ReactJS", "Data Visualization", "Autonomous Vehicle"],
        tech_stack: ["ReactJS"],
        image: "/project-3.jpg",
        repo_url: nil,
        live_url: nil,
        timeline: "4 months",
        role: "Frontend Developer",
        client: "Automotive R&D Department",
        featured: false,
        sort_order: 4,
        inserted_at: "2025-07-20T08:53:57Z",
        updated_at: "2025-07-20T08:53:57Z"
      },
      %{
        id: 5,
        title: "Forklift Management System Integration",
        description: "Project scope is to integrate data from our system to client old system",
        overview: "A middleware solution that bridges the new modern cloud-based forklift management software with a client's legacy warehouse management system, enabling seamless data flow and migration.",
        problem: "The client needed to maintain their existing warehouse management system while migrating to a new system that is more efficient,modern, and has more features.",
        solution: "We developed a custom integration layer that translates data bidirectionally between systems, allowing the client to leverage new forklift capabilities without replacing their core infrastructure.",
        outcome: "The integration increased warehouse efficiency, provided previously unavailable analytics on forklift utilization, and extended the useful life of the client's existing systems.",
        tags: ["React", "Firebase", "Integration", "Middleware"],
        tech_stack: ["React", "Firebase"],
        image: "/project-4.jpg",
        repo_url: nil,
        live_url: nil,
        timeline: "5 months",
        role: "Integration Specialist",
        client: "Manufacturing Company",
        featured: false,
        sort_order: 5,
        inserted_at: "2025-07-20T08:53:57Z",
        updated_at: "2025-07-20T08:53:57Z"
      },
      %{
        id: 6,
        title: "A Simple Math Quiz Website",
        description: "A simple math quiz website that allows users to answer math questions and see their result.",
        overview: "An interactive math quiz application designed to help users practice basic arithmetic skills in an engaging format, with instant feedback and score tracking.",
        problem: "Many existing math practice tools are either too complex for beginners or lack engaging elements to maintain user interest, particularly for younger students.",
        solution: "We created a straightforward yet visually appealing quiz application that focuses on fundamental math operations with progressive difficulty levels and immediate feedback.",
        outcome: "The application was successfully completed within the one-week time constraint and received positive feedback from users for its simplicity and educational value.",
        tags: ["HTML", "CSS", "JavaScript", "Education"],
        tech_stack: ["HTML", "CSS", "JavaScript"],
        image: "/math.png",
        repo_url: "https://github.com/abdulmuhaimin-work/test-bridge",
        live_url: "https://test-bridge-seven.vercel.app/",
        timeline: "1 week",
        role: "Developer",
        client: "Personal Project",
        featured: false,
        sort_order: 7,
        inserted_at: "2025-07-20T08:53:58Z",
        updated_at: "2025-07-20T08:53:58Z"
      },
      %{
        id: 7,
        title: "Sanatoria",
        description: "A horror game developed in Unity during a 1-month game jam at REKA.",
        overview: "Sanatoria is an atmospheric horror puzzle game that immerses players in a tense, psychological experience. Developed during a one-month game jam at REKA, the game demonstrates rapid prototyping, 3D environment design, and gameplay mechanics that create suspense and fear.",
        problem: "Creating an engaging horror puzzle experience requires carefully crafted puzzles, atmospheric sound design, and visual elements that work together to create tension and fear in players.",
        solution: "We focused on creating a psychologically tense atmosphere through strategic lighting, immersive sound design, and unpredictable NPCs. The game was successfully completed within the one-month time constraint and received positive feedback from game jam judges and players for its atmosphere and tension-building mechanics.",
        outcome: "The game was successfully completed within the one-month time constraint and received positive feedback from game jam judges and players for its atmosphere and tension-building mechanics.",
        tags: ["Unity", "C#", "3D", "Game Development"],
        tech_stack: ["Unity", "C#"],
        image: "/sanatoria.jpg",
        repo_url: nil,
        live_url: "https://drive.google.com/drive/folders/1Snn7Z5bUt7SyO0eUhI5uYKJAvqQQbMm5?usp=sharing",
        timeline: "1 month",
        role: "Game Developer",
        client: "Game Jam Project",
        featured: false,
        sort_order: 8,
        inserted_at: "2025-07-20T08:54:04Z",
        updated_at: "2025-07-20T08:54:04Z"
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
        id: 2,
        title: "Consultant, Full Stack Developer",
        company: "Bestinet Sdn Bhd, Kuala Lumpur",
        period: "August 2024 – Present",
        description: "- Developed and maintained web applications using NextJS, Typescript and TailwindCSS. \n- Implemented integration with microservices API which is in Java Springboot. Planned and implemented new features and improvements. \n- Maintain/update/fix web pages using Drupal CMS.\n- Automated build, test and deployment of pipelines using Gitlab and Jenkins.\n- Using Agile methodology for daily workflow with team",
        technologies: [
          "NextJS",
          "TypeScript",
          "TailwindCSS",
          "Drupal CMS",
          "GitLab",
          "Jenkin",
          "Docker"
        ],
        sort_order: 1,
        inserted_at: "2025-07-20T08:50:14Z",
        updated_at: "2025-07-22T07:17:25Z"
      },
      %{
        id: 3,
        title: "Mid-level Developer",
        company: "Nematix Sdn Bhd, Seri Kembangan",
        period: "August 2023 – August 2024",
        description: "Built responsive web applications using Typescript and React. Collaborated with designers to implement user-friendly interfaces. Developed Interactive Data Visualization dashboards using React Charts and CubeJS. Implemented GIS related features using Google Maps API and Kinetica.",
        technologies: [
          "React",
          "TypeScript",
          "CubeJS",
          "Google Maps API",
          "Kinetica",
          "Supertokens",
          "Supabase"
        ],
        sort_order: 2,
        inserted_at: "2025-07-20T08:50:14Z",
        updated_at: "2025-07-20T08:50:14Z"
      },
      %{
        id: 4,
        title: "Front End Developer",
        company: "REKA Inisiatif Sdn Bhd, Kuala Lumpur",
        period: "September 2021 – August 2023",
        description: "Developed and maintained web applications using ReactJS and Bootstrap. Implemented authentication and authorization using Firebase Auth. Developed and maintained RESTful APIs using Firebase Cloud Functions. Developed backend services using NodeJS and Express.",
        technologies: [
          "React",
          "Bootstrap",
          "Firebase",
          "NodeJS",
          "Express",
          "Stripe",
          "MongoDB"
        ],
        sort_order: 3,
        inserted_at: "2025-07-20T08:50:15Z",
        updated_at: "2025-07-20T08:50:15Z"
      },
      %{
        id: 5,
        title: "Software Developer",
        company: "Elm Lab Sdn Bhd, Beranang",
        period: "February 2020 – April 2020",
        description: "Heavily involved in the development of the landing page to onboard new users of the system. Developed the front end interface and integrated with RESTful API. Ensured deliverables and tasks were completed on time for project delivery date.",
        technologies: [
          "HTML",
          "CSS",
          "JavaScript",
          "RESTful API"
        ],
        sort_order: 4,
        inserted_at: "2025-07-20T08:50:19Z",
        updated_at: "2025-07-20T08:50:19Z"
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
