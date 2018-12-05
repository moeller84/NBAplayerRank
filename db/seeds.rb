# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'json'
require 'open-uri'

Player.destroy_all

url = 'http://data.nba.net/prod/v1/2018/players.json'
players_serialized = open(url).read
players = JSON.parse(players_serialized)

  players['league']['standard'].each do |x|   
   Player.create({firstName: x['firstName'], lastName: x['lastName'], personId: x['personId'], teamId: x['teamId']})  
  end


puts Player.first.firstName
puts Player.first.lastName 
puts Player.last.firstName
puts Player.last.lastName 
