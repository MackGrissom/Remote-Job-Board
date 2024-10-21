module JobsHelper
  def formatSalary(min, max)
    "#{(min / 1000).round}k-#{(max / 1000).round}k"
  end

  def industry_emoji(industry)
    industry_options_with_emoji.find { |option| option[1] == industry }&.first&.split&.first || '👨‍💻'
  end

  def industry_options_with_emoji
    [
      ['💻 Software Development', 'Software Development'],
      ['📊 Data Science', 'Data Science'],
      ['🔒 Cybersecurity', 'Cybersecurity'],
      ['🤖 AI/Machine Learning', 'AI/Machine Learning'],
      ['☁️ Cloud Computing', 'Cloud Computing'],
      ['🛠️ DevOps', 'DevOps'],
      ['🎨 UX/UI Design', 'UX/UI Design'],
      ['🌐 Web Development', 'Web Development'],
      ['📱 Mobile Development', 'Mobile Development'],
      ['🌐 Network Engineering', 'Network Engineering'],
      ['🖥️ IT Support', 'IT Support'],
      ['🗄️ Database Administration', 'Database Administration'],
      ['🔗 Blockchain', 'Blockchain'],
      ['🏠 IoT', 'IoT'],
      ['👓 AR/VR', 'AR/VR'],
      ['🎮 Game Development', 'Game Development'],
      ['🔬 Quantum Computing', 'Quantum Computing'],
      ['🦾 Robotics', 'Robotics'],
      ['🧬 Bioinformatics', 'Bioinformatics'],
      ['📡 Telecommunications', 'Telecommunications'],
      ['🔧 Other', 'Other']
    ]
  end
end
