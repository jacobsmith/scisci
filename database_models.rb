require 'data_mapper'

DataMapper.setup(:default, "sqlite3:notes.db")

class Project 
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :created_at, DateTime
  property :project_name, String
  has n, :source
  belongs_to :user
end

 class Source 
   include DataMapper::Resource
  
  property :id, Serial, :key => true, :lazy => false
  property :created_at, DateTime, :lazy => false
  property :title, String, :required => true
  property :author, String
  property :copyright_date, String
  property :website_url, String

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

  belongs_to :source 
end

class User
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :username, String, :unique => true
  property :email, String, :format => :email_address
  property :password_hash, String, :length => 60
  property :password_salt, String, :length => 60

  has n, :project
end
