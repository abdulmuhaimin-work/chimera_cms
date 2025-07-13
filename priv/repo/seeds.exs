# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ChimeraCms.Repo.insert!(%ChimeraCms.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ChimeraCms.Repo
alias ChimeraCms.Accounts.User
alias ChimeraCms.Portfolio.Project
alias ChimeraCms.Blog.Post

# Create admin user
admin_user = %{
  email: System.get_env("ADMIN_EMAIL") || "admin@chimera.com",
  password: System.get_env("ADMIN_PASSWORD") || "admin123",
  first_name: "Admin",
  last_name: "User",
  role: "admin",
  active: true
}

case ChimeraCms.Accounts.register_user(admin_user) do
  {:ok, user} ->
    IO.puts("✅ Admin user created: #{user.email}")
  {:error, changeset} ->
    IO.puts("❌ Failed to create admin user: #{inspect(changeset.errors)}")
end

# Create portfolio projects
projects = [
  %{
    id: 1,
    title: "Interactive Portfolio Website",
    description: "A responsive, interactive portfolio showcasing my work with dynamic layouts, animations, and advanced React components.",
    overview: "This portfolio website is designed as both a showcase of my projects and a project itself. It features an interactive grid layout, custom animations, theme switching, and advanced React components to create an engaging user experience that demonstrates my frontend development capabilities.",
    problem: "Traditional portfolio websites often present work in a static, non-interactive way that doesn't effectively demonstrate a developer's capabilities, especially in dynamic UI development and state management.",
    solution: "I built this portfolio using React and Tailwind CSS with a focus on interactivity. Features include a draggable project grid, custom cursor effects, dark mode support, lazy-loaded images, and animated transitions between sections.",
    outcome: "The result is a portfolio that not only presents my work effectively but also serves as a living demonstration of my technical skills, UX sensibilities, and attention to detail in frontend development.",
    tags: ["React", "TailwindCSS", "Responsive Design", "React Grid Layout", "Custom Animations"],
    tech_stack: ["React", "TailwindCSS", "React Grid Layout", "React Icons"],
    image: "/portfolioweb.png",
    repo_url: "https://github.com/abdulmuhaimin-work/Project-Chimera",
    live_url: "https://abdulmuhaimin.my",
    timeline: "2 months",
    role: "Full-stack Developer",
    client: "Personal Project",
    featured: true,
    sort_order: 1
  },
  %{
    id: 2,
    title: "SERV Sfera Auto",
    description: "A comprehensive web app for auto workshop management with secure authentication and role-based access control",
    overview: "SERV Sfera Auto is a comprehensive web application designed to streamline the daily operations of auto workshop owners and their customers. The platform provides tools for appointment scheduling, service tracking, inventory management, and customer communication. The system features secure authentication and role-based access control to protect sensitive business and customer data.",
    problem: "Auto workshop owners faced challenges with manual booking systems, difficulty tracking service history, and inefficient inventory management, leading to lost revenue and customer dissatisfaction.",
    solution: "We developed a centralized platform that digitizes all aspects of workshop management, allowing owners to track appointments, manage inventory, and communicate with customers through a single interface.",
    outcome: "The application resulted in a 35% reduction in administrative tasks, 28% improvement in customer satisfaction, and an average 15% increase in revenue for workshop owners through better inventory management and appointment scheduling.",
    tags: ["ReactJS", "Firebase", "Bootstrap", "Cloudfunction"],
    tech_stack: ["ReactJS", "Firebase", "Bootstrap", "Cloudfunction"],
    image: "/SferaAuto.PNG",
    repo_url: "",
    live_url: "https://business.sfera.ai",
    timeline: "6 months",
    role: "Frontend Developer",
    client: "Sfera Auto",
    featured: true,
    sort_order: 2
  },
  %{
    id: 3,
    title: "Stripe Payment Server",
    description: "Back-end API for the payment system to integrate the payment of our various apps with the Stripe payment system.",
    overview: "A centralized payment processing server that integrates multiple company applications with Stripe, handling transactions, subscriptions, and payment analytics in a secure environment.",
    problem: "The company had multiple applications each with their own payment implementation, leading to inconsistent user experiences, security concerns, and difficulty in financial reporting.",
    solution: "We created a unified payment API that interfaces with Stripe, allowing all company applications to process payments through a single, secure channel with consistent behavior and centralized reporting.",
    outcome: "The system has processed over $2M in transactions with 99.9% uptime, reduced payment-related customer support tickets by 64%, and simplified financial reconciliation processes.",
    tags: ["ExpressJS", "NodeJS", "MongoDB", "API", "Payment"],
    tech_stack: ["ExpressJS", "NodeJS", "MongoDB"],
    image: "/project-2.jpg",
    repo_url: "",
    live_url: "",
    timeline: "3 months",
    role: "Backend Developer",
    client: "Internal Project",
    featured: false,
    sort_order: 3
  },
  %{
    id: 4,
    title: "Autonomous Vehicle Dashboard",
    description: "Tasked with developing the dashboard for displaying data that was pulled from our autonomous vehicle",
    overview: "A real-time monitoring dashboard for autonomous vehicle data, providing engineers and operators with critical insights into vehicle performance, sensor readings, and system health.",
    problem: "Engineers needed a way to visualize and analyze complex data streams from autonomous vehicles during testing, with the ability to spot anomalies and issues in real-time.",
    solution: "We developed a responsive dashboard that processes and visualizes telemetry data from multiple vehicle sensors, with customizable views and alert systems for critical parameters.",
    outcome: "The dashboard reduced issue detection time by 73%, improved debugging efficiency by 45%, and became an essential tool for the autonomous vehicle development team.",
    tags: ["ReactJS", "Data Visualization", "Real-time", "Autonomous"],
    tech_stack: ["ReactJS"],
    image: "/project-3.jpg",
    repo_url: "",
    live_url: "",
    timeline: "4 months",
    role: "Frontend Developer",
    client: "Automotive R&D Department",
    featured: false,
    sort_order: 4
  },
  %{
    id: 5,
    title: "Forklift Management System Integration",
    description: "Project scope is to integrate data from our system to client old system",
    overview: "A middleware solution that bridges modern cloud-based forklift management software with a client's legacy warehouse management system, enabling seamless data flow and operation.",
    problem: "The client needed to maintain their existing warehouse management system while integrating new smart forklifts that used a modern cloud platform, creating a significant technology gap.",
    solution: "We developed a custom integration layer that translates data bidirectionally between systems, allowing the client to leverage new forklift capabilities without replacing their core infrastructure.",
    outcome: "The integration increased warehouse efficiency by 22%, provided previously unavailable analytics on forklift utilization, and extended the useful life of the client's existing systems.",
    tags: ["React", "Firebase", "Integration", "Middleware"],
    tech_stack: ["React", "Firebase"],
    image: "/project-4.jpg",
    repo_url: "",
    live_url: "",
    timeline: "5 months",
    role: "Integration Specialist",
    client: "Manufacturing Company",
    featured: false,
    sort_order: 5
  },
  %{
    id: 6,
    title: "MicroFrontend Analytics Module",
    description: "Developed a dynamic dashboard module for an analytics and monitoring system.",
    overview: "A standalone analytics module built using micro-frontend architecture that integrates into a larger enterprise monitoring system, providing customizable data visualization and reporting capabilities.",
    problem: "The company needed a flexible analytics solution that could be integrated into their existing monitoring platform without requiring a complete rebuild of the system.",
    solution: "We developed a self-contained micro-frontend module using React and Typescript that communicates through a well-defined API, allowing it to be embedded in the main application while maintaining independent deployment.",
    outcome: "The module has been successfully integrated across 3 different internal applications, reduced report generation time by 87%, and allowed non-technical users to create custom analytics dashboards.",
    tags: ["Typescript", "TailwindCSS", "ReactJS", "CubeJS", "Vite", "NodeJS", "MicroFrontend"],
    tech_stack: ["Typescript", "TailwindCSS", "ReactJS", "CubeJS", "Vite", "NodeJS"],
    image: "/project-5.jpg",
    repo_url: "",
    live_url: "",
    timeline: "7 months",
    role: "Frontend Developer",
    client: "Internal Product Team",
    featured: false,
    sort_order: 6
  },
  %{
    id: 7,
    title: "A Simple Math Quiz Website",
    description: "A simple math quiz website that allows users to answer math questions and see their result.",
    overview: "An interactive math quiz application designed to help users practice basic arithmetic skills in an engaging format, with instant feedback and score tracking.",
    problem: "Many existing math practice tools are either too complex for beginners or lack engaging elements to maintain user interest, particularly for younger students.",
    solution: "We created a straightforward yet visually appealing quiz application that focuses on fundamental math operations with progressive difficulty levels and immediate feedback.",
    outcome: "The application has been used by over 500 students, with an average session length of 15 minutes and a 70% completion rate for quiz sets.",
    tags: ["HTML", "CSS", "JavaScript", "Education"],
    tech_stack: ["HTML", "CSS", "JavaScript"],
    image: "/math.png",
    repo_url: "https://github.com/abdulmuhaimin-work/test-bridge",
    live_url: "https://test-bridge-seven.vercel.app/",
    timeline: "1 week",
    role: "Developer",
    client: "Personal Project",
    featured: false,
    sort_order: 7
  },
  %{
    id: 8,
    title: "Sanatoria",
    description: "A horror game developed in Unity during a 1-month game jam at REKA.",
    overview: "Sanatoria is an atmospheric horror game that immerses players in a tense, psychological experience. Developed during a one-month game jam at REKA, the game demonstrates rapid prototyping, 3D environment design, and gameplay mechanics that create suspense and fear.",
    problem: "Creating an engaging horror experience requires carefully balanced gameplay mechanics, atmospheric sound design, and visual elements that work together to create tension without frustrating players.",
    solution: "We focused on creating a psychologically tense atmosphere through strategic lighting, immersive sound design, and unpredictable enemy AI rather than relying solely on jump scares.",
    outcome: "The game was successfully completed within the one-month time constraint and received positive feedback from game jam judges and players for its atmosphere and tension-building mechanics.",
    tags: ["Unity", "C#", "3D", "Game Development", "Horror"],
    tech_stack: ["Unity", "C#"],
    image: "/sanatoria.jpg",
    repo_url: "",
    live_url: "https://drive.google.com/drive/folders/1Snn7Z5bUt7SyO0eUhI5uYKJAvqQQbMm5?usp=sharing",
    timeline: "1 month",
    role: "Game Developer",
    client: "Game Jam Project",
    featured: false,
    sort_order: 8
  }
]

# Insert projects
Enum.each(projects, fn project_data ->
  case Repo.insert(%Project{
    title: project_data.title,
    description: project_data.description,
    overview: project_data.overview,
    problem: project_data.problem,
    solution: project_data.solution,
    outcome: project_data.outcome,
    tags: project_data.tags,
    tech_stack: project_data.tech_stack,
    image: project_data.image,
    repo_url: project_data.repo_url,
    live_url: project_data.live_url,
    timeline: project_data.timeline,
    role: project_data.role,
    client: project_data.client,
    featured: project_data.featured,
    sort_order: project_data.sort_order
  }) do
    {:ok, project} ->
      IO.puts("✅ Project created: #{project.title}")
    {:error, changeset} ->
      IO.puts("❌ Failed to create project: #{project_data.title} - #{inspect(changeset.errors)}")
  end
end)

# Create sample blog posts
blog_posts = [
  %{
    title: "Building Modern Web Applications with Elixir and Phoenix",
    content: """
    # Building Modern Web Applications with Elixir and Phoenix

    Phoenix is a web framework written in Elixir that provides productivity and maintainability.
    In this post, we'll explore how to build a modern CMS using Phoenix and LiveView.

    ## What makes Phoenix special?

    Phoenix leverages the Actor Model through lightweight processes, making it perfect for real-time applications.
    With features like:

    - **LiveView**: Real-time UI updates without JavaScript
    - **Channels**: WebSocket abstraction for real-time features
    - **Ecto**: Powerful database toolkit
    - **OTP**: Fault-tolerant, concurrent, and distributed system building

    ## Getting Started

    ```elixir
    mix phx.new my_app --live
    cd my_app
    mix ecto.create
    mix phx.server
    ```

    This creates a new Phoenix application with LiveView support, perfect for building modern web applications.

    ## Conclusion

    Phoenix offers a unique approach to web development that combines the productivity of Ruby on Rails
    with the performance and fault-tolerance of Erlang/OTP.
    """,
    excerpt: "Exploring how to build modern web applications using Elixir and Phoenix framework with LiveView for real-time features.",
    featured_image: "/blog-phoenix.jpg",
    published: true,
    tags: ["Elixir", "Phoenix", "Web Development", "LiveView"]
  },
  %{
    title: "The Future of Frontend Development",
    content: """
    # The Future of Frontend Development

    Frontend development is evolving rapidly. From React to Vue, from Webpack to Vite,
    the landscape continues to change. Let's explore what's coming next.

    ## Key Trends

    ### 1. Server-Side Rendering (SSR) Renaissance
    - Next.js leading the charge
    - Improved SEO and performance
    - Better user experience

    ### 2. Micro-frontends Architecture
    - Breaking down monolithic frontends
    - Independent team development
    - Technology diversity

    ### 3. WebAssembly Integration
    - High-performance applications
    - Language diversity in browsers
    - Gaming and multimedia applications

    ## Conclusion

    The future of frontend development is bright, with new technologies
    enabling more performant and maintainable applications.
    """,
    excerpt: "Exploring the latest trends and technologies shaping the future of frontend development.",
    featured_image: "/blog-frontend.jpg",
    published: true,
    tags: ["Frontend", "React", "JavaScript", "WebAssembly", "Trends"]
  },
  %{
    title: "Building Scalable APIs with GraphQL",
    content: """
    # Building Scalable APIs with GraphQL

    GraphQL has revolutionized how we think about API design. Unlike REST,
    GraphQL provides a query language that allows clients to request exactly what they need.

    ## Why GraphQL?

    - **Single Endpoint**: All data accessible through one URL
    - **Type Safety**: Strong typing system
    - **Efficient**: Fetch only needed data
    - **Introspective**: Self-documenting APIs

    ## Getting Started

    ```javascript
    const typeDefs = `
      type Query {
        user(id: ID!): User
        posts: [Post]
      }

      type User {
        id: ID!
        name: String!
        email: String!
      }
    `;
    ```

    This shows a simple GraphQL schema definition for a user management system.

    ## Best Practices

    1. Design your schema first
    2. Use strong typing
    3. Implement proper error handling
    4. Consider performance implications
    5. Use DataLoader for N+1 problem

    GraphQL is not just a technology, it's a paradigm shift in API design.
    """,
    excerpt: "Learn how to build scalable and efficient APIs using GraphQL with practical examples and best practices.",
    featured_image: "/blog-graphql.jpg",
    published: false,
    tags: ["GraphQL", "API", "Backend", "JavaScript", "Scalability"]
  }
]

# Insert blog posts
Enum.each(blog_posts, fn post_data ->
  case Repo.insert(%Post{
    title: post_data.title,
    content: post_data.content,
    excerpt: post_data.excerpt,
    featured_image: post_data.featured_image,
    published: post_data.published,
    tags: post_data.tags,
    published_at: if(post_data.published, do: DateTime.utc_now() |> DateTime.truncate(:second), else: nil)
  }) do
    {:ok, post} ->
      IO.puts("✅ Blog post created: #{post.title}")
    {:error, changeset} ->
      IO.puts("❌ Failed to create blog post: #{post_data.title} - #{inspect(changeset.errors)}")
  end
end)

IO.puts("\n🎉 Database seeding completed!")
IO.puts("👤 Admin login: admin@chimera.com / admin123")
IO.puts("📊 Projects: #{length(projects)} created")
IO.puts("📝 Blog posts: #{length(blog_posts)} created")
