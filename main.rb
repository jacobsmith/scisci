require "sinatra"
require "./form_helpers.rb"
require "dm_noisy_failures"
require "./database_models.rb"

before do
  DataMapper.finalize
#  DataMapper.auto_migrate!
  DataMapper.auto_upgrade!

end

get "/" do
  redirect '/all_sources'
end

get "/add_note" do
  @sources = Source.all
  erb :add_note
end

post "/add_note" do
  puts params
  source = Source.first(:title => params['source_name']) 
  puts "putting source"
  puts source
  note = Note.new
  params.each do |param|
    note.attributes = { param[0].to_sym => param[1] || nil }
  end

  begin
    source.note << note
    source.save
    redirect '/all_sources'
  rescue Exception => e
    puts e
    "Error while saving: " + e.to_s
    "Please email jacob.wesley.smith@gmail.com with the error message. Sorry for the inconvenience."
    "Try clicking the back button and resubmitting the page."
  end

end

get "/all_notes" do
  @notes = Note.all
  erb :all_notes
end

get "/add_source" do
  erb :add_source
end


post "/add_source" do
  puts params

  source = Source.new 
  params.each do |param|
    source.attributes = { param[0].to_sym => param[1] || nil }
  end

  begin
    source.save
  rescue Exception => e
    e.each.map { |i| puts i } 
    "Error while saving: " + e.to_s
    "Please email jacob.wesley.smith@gmail.com with the error message. Sorry for the inconvenience."
    "Try clicking the back button and resubmitting the page."
  end
end


get "/all_sources" do
  @sources = Source.all
  erb :all_sources
end

get "/source/:id" do
  @source = Source.first(:id => params[:id])
  erb :notes_of_source
end

post "/search" do
  @collection = [] 
  Note.all.each do |note|
    if note.tags != nil
      @collection << note if note.tags.match(params[:search])
    end
  end


  erb :search_return
end

get "/tag/:tag" do
  @collection = [] 
  Note.all.each do |note|
  if note.tags != nil
    @collection << note if note.tags.match(params[:tag])
  end

  erb :search_return
  end
end

