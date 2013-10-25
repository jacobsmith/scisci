require "sinatra"
require "sinatra/cookies"
require "./form_helpers.rb"
require "dm_noisy_failures"
require "./database_models.rb"
require "bcrypt"
require "pry"

configure(:development) { set :session_secret, "something"
                          set :domain, "127.0.0.1" 
                          set :public_folder, File.dirname(__FILE__) + '/public' }

include ERB::Util
set :sessions, true
set :session_secret, "you'll never guess this!"
set :session_expire_after,  2592000


helpers do
  def login?
    if cookies[:username].nil?
      return false
    else
      return true
    end
  end

  def users_only
    redirect '/login' if login? == false
  end

  def return_all_sources
     Project.first(:user_id => User.first(:username => cookies[:username]).id, :project_name => cookies[:project_name]).source
  end
end

before do
  @projects = User.first(:username => cookies[:username]).project.all if login?
  @sources = Source.all(:project => cookies[:project_name]) if login?
  DataMapper.finalize
  DataMapper.auto_upgrade!
end

get "/" do
  @title = "Welcome!"
  erb :index
end

get "/create_project" do
  if login?
    @title = "New Project"
    erb :create_project
  else
    erb :please_login
  end
end

post "/create_project" do
  project = Project.new 
  @user = User.first(:username => cookies[:username])
  project.project_name = params[:project_name]
  
  begin
    if @user.project(:project_name => params[:project_name]) == []
      @user.project << project
      project.save
      session[:flash] = "Project #{project.project_name} created!"
      redirect "/all_projects"
    else
      "Please choose a different Project name. You already have one with that name!"
    end
  rescue Exception => e
    "Error while saving: " + e.to_s
  end

end

get "/project/:project_name" do
  cookies[:project_name] = params[:project_name].to_s
  redirect "/all_sources"
end

get "/all_projects" do
  if login?
    @projects = User.first(:username => cookies[:username]).project
    @title = "All Projects"
    erb :all_projects
  else
    erb :please_login
  end
end

get "/add_note" do
  if login?
    @sources = return_all_sources() 
    @title = "Add Note"
    erb :add_note
  else
    erb :please_login
  end
end

post "/add_note" do
  if login?
    source = Source.first(:title => params['source_name']) 
    note = Note.new
    
    params.each do |param|
      note.attributes = { param[0].to_sym => param[1] || nil }
    end

    begin
      source.note << note
      source.save
      note_first_phrase = note.quote.split(" ").each_with_index.map { |word, index| word + " " if index < 10 }.join(" ")
      flash = "Note starting with: #{note_first_phrase}... saved successfully!"
      session[:flash] = flash 
      puts session.inspect
      #      erb :add_note
      redirect "/add_note"
    rescue Exception => e
      "Error while saving: " + e.to_s
    end
  else
    erb :please_login
  end

end

get "/all_notes" do
  if login?
    @sources = return_all_sources()
    @title = "All Notes"
    erb :all_notes
  else
    erb :please_login  
  end 
end

get "/add_source" do
  if login? 
    @project_name = cookies[:project_name] 
    @title = "Add Source"
    erb :add_source
  else
    erb :please_login
  end
end

post "/add_source" do
  if login?
    source = Source.new 
    source.project = Project.first(:project_name => params[:project_name])
    params.delete("project_name")  

    params.each do |param|
      if !param.nil?
        source.attributes = { param[0].to_sym => param[1] || nil }
      end 
    end

    begin
      source.save
      session[:flash] = "Source #{source.name} successfully created!"
      redirect "/all_sources"
    rescue Exception => e
      "Error while saving: " + e.to_s
    end
  else
    erb :please_login
  end
end

get "/all_sources" do
  if login? 
    @sources = Source.all(:project => {:project_name => cookies[:project_name]} ) 
    if @sources != nil
      @title = "All Sources"
      erb :all_sources
    else
      redirect "/add_source"
      session[:flash] = "You must add a source first (: "
    end
  else
    erb :please_login
  end
end

get "/source/:id" do
  if login? 
    sources = return_all_sources 
    @source = sources.first(:id => params[:id])
    @title = @source.title
    session[:source] = @title 
    erb :notes_of_source
  else
    erb :please_login
  end
end

post "/search" do
  if login?
    @collection = []
    sources = return_all_sources 
    sources.note.all.each do |note|
      if note.tags != nil
        @collection << note if note.tags.match(params[:search])
      end
    end

    @title = "Search Results"
    erb :search_return

  else
    erb :please_login
  end

end

get "/tag/:tag" do
  if login?
    @collection = [] 
    sources = return_all_sources 
    sources.note.each do |note|
      @collection << note if note.tags.match(params[:tag]) 
    end 
    @title = "Tags"
    erb :search_return
  else
    erb :please_login
  end
end


get "/login" do
  @title = "Login"
  erb :login
end

post "/login" do
     if User.first(:username => params[:username])
       user = User.first(:username => [params[:username]])
      if user[:password_hash] == BCrypt::Engine.hash_secret(params[:password], user[:password_salt])
         cookies[:username] = user[:username]
         redirect "/all_projects"
      end 
    else
     "Could not log in. Please double check your username and password and try again." 
    end
end

get "/signup" do
  @title = "Signup"
  erb :signup
end

post "/signup" do
  user = User.new
  
  if params[:password] != params[:password_verification]
    "Passwords do not match. Please try again."
  else
    password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)

    user.attributes = { :username => params[:username],
                        :password_salt => password_salt,
                        :password_hash => password_hash,
                        :email => params[:email] }
    user.expires_at = Date.today + 90
  end

  begin
    user.save
    cookies[:username] = params[:username]
    session[:flash] = "You successfully signed up--thanks! If you need any help, please just email me at jacob.wesley.smith@gmail.com (:"
    redirect "/all_projects" 
  rescue Exception => e
    "Error while saving: " + e.to_s
  end
end

get "/logout" do
  session[:username] = nil
  session[:project_name] = nil
  cookies.clear
  redirect "/"
end
