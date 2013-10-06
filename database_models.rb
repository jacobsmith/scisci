require 'data_mapper'

DataMapper.setup(:default, "sqlite3:notes.db")

class Source 
  include DataMapper::Resource
  
  property :id, Serial, :key => true, :lazy => false
  property :created_at, DateTime, :lazy => false
  property :title, String
  property :author, String
  property :copyright_date, String
  property :website_url, String

  has n, :note
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


DataMapper.finalize
DataMapper.auto_upgrade!
