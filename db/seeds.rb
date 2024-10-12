require 'faker'

# Array of locations from USA, Europe, South America, and Asia
locations = [
  { city: "New York", country: "USA", lat: 40.7128, lon: -74.0060 },
  { city: "San Francisco", country: "USA", lat: 37.7749, lon: -122.4194 },
  { city: "Chicago", country: "USA", lat: 41.8781, lon: -87.6298 },
  { city: "London", country: "UK", lat: 51.5074, lon: -0.1278 },
  { city: "Paris", country: "France", lat: 48.8566, lon: 2.3522 },
  { city: "Berlin", country: "Germany", lat: 52.5200, lon: 13.4050 },
  { city: "Sao Paulo", country: "Brazil", lat: -23.5505, lon: -46.6333 },
  { city: "Buenos Aires", country: "Argentina", lat: -34.6037, lon: -58.3816 },
  { city: "Tokyo", country: "Japan", lat: 35.6762, lon: 139.6503 },
  { city: "Singapore", country: "Singapore", lat: 1.3521, lon: 103.8198 },
  { city: "Mumbai", country: "India", lat: 19.0760, lon: 72.8777 },
  { city: "Remote", country: "Worldwide", lat: nil, lon: nil },
  { city: "Los Angeles", country: "USA", lat: 34.0522, lon: -118.2437 },
  { city: "Toronto", country: "Canada", lat: 43.6532, lon: -79.3832 },
  { city: "Sydney", country: "Australia", lat: -33.8688, lon: 151.2093 },
  { city: "Madrid", country: "Spain", lat: 40.4168, lon: -3.7038 },
  { city: "Rome", country: "Italy", lat: 41.9028, lon: 12.4964 },
  { city: "Amsterdam", country: "Netherlands", lat: 52.3676, lon: 4.9041 },
  { city: "Dubai", country: "UAE", lat: 25.2048, lon: 55.2708 },
  { city: "Hong Kong", country: "China", lat: 22.3193, lon: 114.1694 },
  { city: "Seoul", country: "South Korea", lat: 37.5665, lon: 126.9780 },
  { city: "Moscow", country: "Russia", lat: 55.7558, lon: 37.6173 },
  { city: "Stockholm", country: "Sweden", lat: 59.3293, lon: 18.0686 },
  { city: "Bangkok", country: "Thailand", lat: 13.7563, lon: 100.5018 },
  { city: "Istanbul", country: "Turkey", lat: 41.0082, lon: 28.9784 },
  { city: "Cape Town", country: "South Africa", lat: -33.9249, lon: 18.4241 },
  { city: "Mexico City", country: "Mexico", lat: 19.4326, lon: -99.1332 },
  { city: "Vancouver", country: "Canada", lat: 49.2827, lon: -123.1207 },
  { city: "Dublin", country: "Ireland", lat: 53.3498, lon: -6.2603 },
  { city: "Vienna", country: "Austria", lat: 48.2082, lon: 16.3738 },
  { city: "Helsinki", country: "Finland", lat: 60.1699, lon: 24.9384 },
  { city: "Oslo", country: "Norway", lat: 59.9139, lon: 10.7522 },
  { city: "Lisbon", country: "Portugal", lat: 38.7223, lon: -9.1393 },
  { city: "Warsaw", country: "Poland", lat: 52.2297, lon: 21.0122 },
  { city: "Prague", country: "Czech Republic", lat: 50.0755, lon: 14.4378 },
  { city: "Athens", country: "Greece", lat: 37.9838, lon: 23.7275 },
  { city: "Budapest", country: "Hungary", lat: 47.4979, lon: 19.0402 },
  { city: "Zurich", country: "Switzerland", lat: 47.3769, lon: 8.5417 },
  { city: "Copenhagen", country: "Denmark", lat: 55.6761, lon: 12.5683 },
  { city: "Brussels", country: "Belgium", lat: 50.8503, lon: 4.3517 }
]

# Clear existing jobs
Job.destroy_all

# Create 500 jobs
100.times do
  location = locations.sample
  Job.create!(
    title: Faker::Job.title,
    description: Faker::Lorem.paragraph(sentence_count: 5),
    company: Faker::Company.name,
    location: location[:city] == "Remote" ? "Remote" : "#{location[:city]}, #{location[:country]}",
    job_type: ["Full-time", "Part-time", "Contract"].sample,
    apply_link: Faker::Internet.url,
    industry: Faker::Job.field,
    experience_level: ["Entry", "Mid", "Senior"].sample,
    salary_min: rand(30000..80000),
    salary_max: rand(80001..200000),
    latitude: location[:lat],
    longitude: location[:lon]
  )
end

puts "Created #{Job.count} jobs"
