require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "zerigo_dns"
    gem.summary = %Q{Zerigo DNS Gem}
    gem.description = %Q{This gem is a resource wrapper of the example provide by zerigo dns}
    gem.email = "tom@jackhq.com"
    gem.homepage = "http://github.com/twilson63/zerigo_dns"
    gem.authors = ["Tom Wilson"]
    gem.add_dependency "activeresource", ">= 3.0"
    gem.add_development_dependency "rspec", ">= 2.0"
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    gem.add_development_dependency "rdoc", ">= 0"
    gem.add_development_dependency "rcov", ">= 0"
    gem.files = FileList['example/*.rb'] + FileList['lib/**/*.rb'] + ['README.rdoc', 'LICENSE', 'VERSION.yml', 'Rakefile']
    
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec

# require 'rdoc/task'
# RDoc::Task.new do |rdoc|
#   version = File.exist?('VERSION') ? File.read('VERSION') : ""
# 
#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.title = "zerigo_dns #{version}"
#   rdoc.rdoc_files.include('README*')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end
