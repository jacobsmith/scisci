require './database_models.rb'

task :setup_database do 
  admin = User.create_new_user('smittles2003', 'smittles2003@yahoo.com', 'password', nil)
  Project.create_new_project('Initial Project', admin)
end

