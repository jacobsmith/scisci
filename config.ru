require "sinatra"
require "sinatra/cookies"
require "./form_helpers.rb"
require "dm_noisy_failures"
require "./database_models.rb"
require "bcrypt"
require "pry"
require "./main.rb"

run Sinatra::Application
