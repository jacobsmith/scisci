require "sinatra"
require "./form_helpers.rb"
require "dm_noisy_failures"
require "./database_models.rb"
require "bcrypt"
require "pry"
require "./main.rb"


set :root, Pathname(__FILE__).dirname
set :environment, :production
set :run, false
run SciSci 
