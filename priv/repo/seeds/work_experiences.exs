alias ChimeraCms.Resume

work_experiences = [
  %{
    title: "Consultant, Full Stack Developer",
    company: "Bestinet Sdn Bhd, Kuala Lumpur",
    period: "August 2024 – Present",
    description: "Developed and maintained web applications using NextJS, Typescript and TailwindCSS. Implemented integration with microservices API. Planned and implemented new features and improvements. Automated build, test and deployment of pipelines using Gitlab and Jenkins.",
    technologies: ["NextJS", "TypeScript", "TailwindCSS", "GitLab", "Jenkins"],
    sort_order: 1
  },
  %{
    title: "Mid-level Developer",
    company: "Nematix Sdn Bhd, Seri Kembangan",
    period: "August 2023 – August 2024",
    description: "Built responsive web applications using Typescript and React. Collaborated with designers to implement user-friendly interfaces. Developed Interactive Data Visualization dashboards using React Charts and CubeJS. Implemented GIS related features using Google Maps API and Kinetica.",
    technologies: ["React", "TypeScript", "CubeJS", "Google Maps API", "Kinetica", "Supertokens", "Supabase"],
    sort_order: 2
  },
  %{
    title: "Front End Developer",
    company: "REKA Inisiatif Sdn Bhd, Kuala Lumpur",
    period: "September 2021 – August 2023",
    description: "Developed and maintained web applications using ReactJS and Bootstrap. Implemented authentication and authorization using Firebase Auth. Developed and maintained RESTful APIs using Firebase Cloud Functions. Developed backend services using NodeJS and Express.",
    technologies: ["React", "Bootstrap", "Firebase", "NodeJS", "Express", "Stripe", "MongoDB"],
    sort_order: 3
  },
  %{
    title: "Software Developer",
    company: "Elm Lab Sdn Bhd, Beranang",
    period: "February 2020 – April 2020",
    description: "Heavily involved in the development of the landing page to onboard new users of the system. Developed the front end interface and integrated with RESTful API. Ensured deliverables and tasks were completed on time for project delivery date.",
    technologies: ["HTML", "CSS", "JavaScript", "RESTful API"],
    sort_order: 4
  }
]

# Insert work experiences
Enum.each(work_experiences, fn work_experience_attrs ->
  case Resume.create_work_experience(work_experience_attrs) do
    {:ok, work_experience} ->
      IO.puts("Created work experience: #{work_experience.title}")
    {:error, changeset} ->
      IO.puts("Failed to create work experience: #{inspect(changeset.errors)}")
  end
end)

IO.puts("Work experiences seeded successfully!")
