require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
  # t.verbose = true
end

task default: :test

namespace :crosswords do
  task :json do
    puts JSON.dump(
      YAML
      .load_file("var/crosswords.yml")
      .map { |key, value|
        date = Date.parse(key)
        min, sec, errors = value.scan(/^(\d+)m(\d+)s(?: \((\d+)\))?$/)[0]
        { date: date,
          time: min.to_i * 60 + sec.to_i,
          errors: errors.to_i }
      }
    )
  end
end
