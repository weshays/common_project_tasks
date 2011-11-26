namespace :app do
  desc 'Setup the application. Usage: rake app:setup. Set RAILS_ENV for other environments. The default is development'
  task :setup do
    ENV['RAILS_ENV'] = 'development' unless ENV.include?('RAILS_ENV')
    
    file = "#{Rails.root.to_s}/config/app_vars.yml"
    app_vars = YAML::load(ERB.new(IO.read(file)).result)
    
    file = "#{Rails.root.to_s}/config/database.yml"
    database = YAML::load(ERB.new(IO.read(file)).result)    

    # update git submodules in case new ones were added
    if !app_vars[ENV['RAILS_ENV']]['update_git_submodules'].nil? and app_vars[ENV['RAILS_ENV']]['update_git_submodules'] == true
      system('git submodule init')
      system('git submodule update')
    end
    
    if !app_vars[ENV['RAILS_ENV']]['rebuild_database'].nil? and app_vars[ENV['RAILS_ENV']]['rebuild_database'] == true
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke    
    end
    
    if !app_vars[ENV['RAILS_ENV']]['run_db_migrate'].nil? and app_vars[ENV['RAILS_ENV']]['run_db_migrate'] == true
      Rake::Task['db:migrate'].invoke
    end
    
    if !app_vars[ENV['RAILS_ENV']]['load_fixtures'].nil? and app_vars[ENV['RAILS_ENV']]['load_fixtures'] == true
      ENV['FIXTURES'] = app_vars[ENV['RAILS_ENV']]['fixtures']
      Rake::Task['spec:db:fixtures:load'].invoke
    end

    unless app_vars[ENV['RAILS_ENV']]['post_fixture_tasks'].nil?
      begin
        Rake::Task[app_vars[ENV['RAILS_ENV']]['post_fixture_tasks']].invoke
      rescue
        puts 'There was an error invoking the post fixture task. Make sure it exists.'
      end
    end    
    
    unless app_vars[ENV['RAILS_ENV']]['load_sql_file'].nil?
      begin
        path_to_sql_file = app_vars[ENV['RAILS_ENV']]['load_sql_file']         
        db = database[ENV['RAILS_ENV']]['database']
        username = database[ENV['RAILS_ENV']]['username']
        password = database[ENV['RAILS_ENV']]['password']
        ENV['PGUSER'] = username
        ENV['PGPASSWORD'] = password
        system("psql -d #{db} < #{path_to_sql_file}")
      rescue
        puts 'There was an error loading sql file'
      end
    end    
    
    if !app_vars[ENV['RAILS_ENV']]['run_post_db_migrate'].nil? and app_vars[ENV['RAILS_ENV']]['run_post_db_migrate'] == true
      Rake::Task['db:migrate'].invoke
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

    
    
