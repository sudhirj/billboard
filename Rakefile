require 'rake/testtask'

Rake::TestTask.new do |t|
	t.libs.push 'lib'
	p FileList['test/*_test.rb']
	t.test_files = FileList['test/*_test.rb']
	t.verbose = false
end

task default: :test
