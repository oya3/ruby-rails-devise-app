# coding: utf-8
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require 'yaml'
require 'optparse' # オプション解析
require 'n02_dataset'
require 'active_support/all'

require 'pry'

Encoding.default_external = 'utf-8'
Encoding.default_internal = 'utf-8'

puts "create_rails_seeds version.0.2017.06.22.1352"

if ARGV.length != 1 then
  puts "usage create_rails_seeds <config file path>"
  exit
end

# yml = YAML.load_file(ARGV[0]).with_indifferent_access
yml = HashWithIndifferentAccess.new(YAML.load_file(ARGV[0]))
contents = yml[:contents]
N02Dataset.new contents

# ぽくseedsファイルを作成してみる
train_routes = contents[:train_routes]
n02dataset = contents[:n02dataset]
result = Hash.new
result[:users] = <<'USERS_END'
user_admin = Role.find_or_create_by({name: :admin}) # admin権限
user_member = Role.find_or_create_by({name: :member}) # member権限
user_guest = Role.find_or_create_by({name: :guest}) # guest権限

user = User.create(email: 'admin@test.com', password: 'admin3', username: 'admin', role_ids: [ user_admin.id ])
user = User.create(email: 'oya@test.com', password: 'oya333', username: 'oya', role_ids: [ user_member.id ])
user = User.create(email: 'shibata@test.com', password: 'shibata3', username: 'shibata', role_ids: [ user_member.id])
user = User.create(email: 'test@test.com', password: 'test333', username: 'test', role_ids: [ user_admin.id, user_member.id, user_guest.id] )
USERS_END
result[:stations] = Array.new
result[:train_routes] = Array.new
result[:between_stations] = Array.new

train_routes = contents[:train_routes]
pp train_routes
binding.pry

# contents を出力に必要な最小構成にする
train_info = create_train_info(contents)

class RailsSeeds
  attr_accessor  :info_train_routes, :info_stations, :info_curces
  
  def initialize(contents)
    @info_train_routes = Array.new
    @info_stations = Hash.new
    @info_curces = Hash.new
    @info_between_stations = Array.new
    create(contents)
  end

  private
  def create(contents)
    train_routes = contents[:train_routes]
    n02dataset = contents[:n02dataset]
    train_routes.each.with_index(0) do |train_route,train_route_id|
      info_train_route = Hash.new
      @info_train_routes << info_train_route
      info_train_route[:name] = train_route[:name]
      info_train_route[:company] = train_route[:company]
      info_stations = Array.new
      info_train_route[:stations] = info_stations
      train_route[:stations].each.with_index(0) do |station,station_id|
        # 駅名が新たに登場したら覚える。ついでに番号も
        @stations[station[:name]] = @stations.size unless @stations.has_key? station[:name]
        info_station = Hash.new
        info_stations << info_station
        info_station[:name_id] = @stations[station[:name]]
        curve_name = n02dataset[ station[:keys][0] ][:location]
        @info_curves[curve_name] = @info_curves.size unless @info_curves.has_key? curve_name
        info_station[:curve_id] = @info_curves[curve_name]
        
        # 次の駅があればbetween_stationsを作成
        next if station_id == (train_route[:stations].size -1)
        info_between_station = Hash.new
        @info_between_stations << info_between_station
        next_station = train_route[:stations][station_id+1]
        @stations[next_station[:name]] = @stations.size unless @stations.has_key? station_next[:name]
        
      end
    end
    
  end
  
end




train_routes.each.with_index(0) do |train_route,train_route_id|
  result[:train_routes] << "train_route = TrainRoute.create( code: #{train_reoute_id+1}, name: #{train_route[:name]}, company: #{train_route[:company]})"
  train_route[:stations].each
end



puts 'complate.'
