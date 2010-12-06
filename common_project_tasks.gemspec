Gem::Specification.new do |s|
  PROJECT_GEM = 'common_project_tasks'
  PROJECT_GEM_VERSION = '0.3.2'  
  
  s.name = PROJECT_GEM
  s.version = PROJECT_GEM_VERSION
  s.platform = Gem::Platform::RUBY
  #s.date = '2009-01-05'

  s.homepage = 'http://github.com/gbdev/common_project_tasks'
  s.rubyforge_project = 'Project on www.github.com'
  s.authors = ['Wes Hays', 'John Dell']
  s.email = 'gems@gbdev.com'

  s.summary = 'Rails gem/plugin to load common project tasks.'
  s.description = 'Rails gem/plugin to load common project tasks.'

  s.add_dependency('rake','>= 0.8.3')

  s.require_path = 'lib/'
  
  s.files = ['LICENSE',
             'README',
             'lib/common_project_tasks.rb',
             'lib/common_project_tasks/app.rake',
             'examples/app_vars.yml']
             
  s.has_rdoc = true
  s.extra_rdoc_files = %w{README LICENSE}
  s.rdoc_options << '--title' << 'Common Project Tasks Documentation' <<
                    '--main'  << 'README' << '-q'
end
