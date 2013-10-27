require "data_mapper"
require "bcrypt"

DataMapper.setup(:default, "sqlite3:notes.db")

class Project 
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :created_at, DateTime
  property :project_name, String
  has n, :source
  belongs_to :user

  def self.create_new_project(project_name, user)
    project = Project.new

    project.attributes = {
      :project_name => project_name,
    }

    begin 
      user << project
      project.save
    rescue
      raise SaveError
   end
  end
end

 class Source 
   include DataMapper::Resource
  
  property :id, Serial, :key => true, :lazy => false
  property :created_at, DateTime, :lazy => false
  property :title, String, :required => true
  property :author, String
  property :copyright_date, String
  property :website_url, String
  property :comments, Text 

  has n, :note
  belongs_to :project
end

class Note
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :quote, Text
  property :page, String
  property :source_name, String 
  property :tags, String
  property :comments, Text 

  belongs_to :source 
end

class User
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :username, String, :unique => true
  property :email, String, :format => :email_address
  property :password_hash, String, :length => 60
  property :password_salt, String, :length => 60
  property :expires_at, Date


  has n, :project
  
  def self.create_new_user(username, email, password, expires_at)

    user = User.new

    password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    
    user.attributes = {
      :username => username,
      :email => email,
      :password_salt => password_salt,
      :password_hash => password_hash,
      :expires_at => expires_at
    }

  begin
    user.save
  rescue
    raise UserSaveError
  end
  end

end
