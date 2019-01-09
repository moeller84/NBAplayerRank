# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'json'
require 'open-uri'
require "pry-byebug"


Player.destroy_all
Game.destroy_all
PlayerGame.destroy_all


url = 'http://data.nba.net/prod/v2/2018/schedule.json'
schedule_serialized = open(url).read
gameIds_json = JSON.parse(schedule_serialized)

game_id_dateCode = [[],[]]
game_info_array = []

  gameIds_json['league']['standard'].each do |x|
    if x['statusNum'] == 3 && x['seasonStageId'] == 2
      Game.create(gameId: x['gameId'], gameDateCode: x['startDateEastern'], HomeTeamId: x['hTeam']['teamId'], VisitorTeamId: x['vTeam']['teamId'])
      game_id_dateCode[0] << x['gameId']
      game_id_dateCode[1] << x['startDateEastern']
      game_info_array << {:gameIdCode => x['gameId'], :gameDateCode => x['startDateEastern']}
    end
  end
 #binding.pry



puts game_id_dateCode[0].length

puts game_id_dateCode[1].length

player_hash = []

game_info_array.each do |x|


#    url = "http://data.nba.net/json/cms/noseason/game/#{x[:gameDateCode]}/#{x[:gameIdCode]}/boxscore.json"
url = "http://data.nba.net/json/cms/noseason/game/#{x[:gameDateCode]}/#{x[:gameIdCode]}/boxscore.json"
    boxscore_serialized = open(url).read
    boxscore_json = JSON.parse(boxscore_serialized)

    boxscore_home = boxscore_json['sports_content']['game']['home']['players']['player']
    #puts boxscore_home['points']


      boxscore_home.each do |y|
        #puts x['person_id']

        player_hash << {:personId => y['person_id'], :firstName => y['first_name'], :lastName => y['last_name']}

      end

end

player_hash = player_hash.uniq

player_hash.each do |x|
  Player.create({firstName: x[:firstName], lastName: x[:lastName], personId: x[:personId]})
end

game_info_array.each do |x|

    url = "http://data.nba.net/json/cms/noseason/game/#{x[:gameDateCode]}/#{x[:gameIdCode]}/boxscore.json"
#url = "http://data.nba.net/json/cms/noseason/game/20180928/0011800001/boxscore.json"
    boxscore_serialized = open(url).read
    boxscore_json = JSON.parse(boxscore_serialized)

    boxscore_home = boxscore_json['sports_content']['game']['home']['players']['player']
    #puts boxscore_home['points']


      boxscore_home.each do |y|
        #puts x['person_id']

        playerGame = PlayerGame.create(no_points: y['points'],
          no_rebounds: y['rebounds_offensive'].to_i + y['rebounds_defensive'].to_i,
          no_assists: y['assists'],
          no_blocks: y['blocks'],
          no_steals: y['steals'],
          no_tpm: y['three_pointers_made'],
          no_fta: y['free_throws_attempted'],
          no_ftm: y['free_throws_made'],
          no_fga: y['field_goals_attempted'],
          no_fgm: y['field_goals_made'],
          no_turnovers: y['turnovers'],
          personId: y['person_id'],
          game: Game.find_by(gameId: x[:gameIdCode]))
        player = Player.find_by(personId: y['person_id'])
        if player.nil? == FALSE
      #binding.pry
        player.player_games << playerGame
        end
        #puts playerGame
      #   if player.nil?
      #     player
      #   else
      # #
      #   z = y['player_code']
      #   end

      end

end
