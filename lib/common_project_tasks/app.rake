namespace :app do
  desc 'Setup the application. Usage: rake app:setup. Set RAILS_ENV for other environments. The default is development'
  task :setup do
    ENV['RAILS_ENV'] = 'development' unless ENV.include?('RAILS_ENV')
    
    file = "#{RAILS_ROOT}/config/app_vars.yml"
    app_vars = YAML::load(ERB.new(IO.read(file)).result)
    
    file = "#{RAILS_ROOT}/config/database.yml"
    database = YAML::load(ERB.new(IO.read(file)).result)    

    # update git submodules in case new ones were added
    system('git submodule init')
    system('git submodule update')
    
    if !app_vars[ENV['RAILS_ENV']]['rebuild_database'].nil? and app_vars[ENV['RAILS_ENV']]['rebuild_database'] == true
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke    
    end
    
    Rake::Task['db:migrate'].invoke
    
    if !app_vars[ENV['RAILS_ENV']]['load_fixtures'].nil? and app_vars[ENV['RAILS_ENV']]['load_fixtures'] == true
      ENV['FIXTURES'] = app_vars[ENV['RAILS_ENV']]['fixtures']
      Rake::Task['spec:db:fixtures:load'].invoke
    end
  end
  
  ##############################################
  # The tasks below will not work because the
  # commandline argument RAILS_ENV has already 
  # been read by the Rails environment by the 
  # time this task is executed.
  ##############################################
  
  # desc 'Setup the application for production.'
  # task :setup_production => :environment do
  #   ENV['RAILS_ENV'] = 'production'
  #   Rake::Task['app:setup'].invoke
  # end
  # 
  # desc 'Setup the application for development.'
  # task :setup_development => :environment do
  #   ENV['RAILS_ENV'] = 'development'
  #   Rake::Task['app:setup'].invoke
  # end
  # 
  # desc 'Setup the application for testing.'
  # task :setup_test => :environment do
  #   ENV['RAILS_ENV'] = 'test'
  #   Rake::Task['app:setup'].invoke
  # end    
  # 
  # desc 'Setup the application for production, development and testing environments.'
  # task :setup_all => [:setup_production, :setup_development, :setup_test] 
end

    
    