require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "lib/**/*.rb"
  t.test_files = FileList['spec/**/*_spec.rb']
  t.verbose = true
end
