# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# 権限の種類を登録
#[ :admin, :member, :guest ].each do |role|
#  Role.find_or_create_by({name: role})
#end

user_admin = Role.find_or_create_by({name: :admin}) # admin権限
user_member = Role.find_or_create_by({name: :member}) # member権限
user_guest = Role.find_or_create_by({name: :guest}) # guest権限

user = User.create(email: 'admin@test.com', password: 'admin3', username: 'admin', role_ids: [ user_admin.id ])
user = User.create(email: 'oya@test.com', password: 'oya333', username: 'oya', role_ids: [ user_member.id ])
user = User.create(email: 'shibata@test.com', password: 'shibata3', username: 'shibata', role_ids: [ user_member.id])
user = User.create(email: 'test@test.com', password: 'test333', username: 'test', role_ids: [ user_admin.id, user_member.id, user_guest.id] )

Station.create(code: 1, name: '京都')
Station.create(code: 2, name: '山科')
Station.create(code: 3, name: '大津')
Station.create(code: 4, name: '膳所')
Station.create(code: 5, name: '石山')
Station.create(code: 6, name: '瀬田')
Station.create(code: 7, name: '南草津')
Station.create(code: 8, name: '草津')
Station.create(code: 9, name: '栗東')
Station.create(code: 10, name: '守山')
Station.create(code: 11, name: '野洲')
Station.create(code: 12, name: '篠原')
Station.create(code: 13, name: '近江八幡')
Station.create(code: 14, name: '安土')
Station.create(code: 15, name: '能登川')
Station.create(code: 16, name: '稲枝')
Station.create(code: 17, name: '河瀬')
Station.create(code: 18, name: '南彦根')
Station.create(code: 19, name: '彦根')
Station.create(code: 20, name: '米原')

Station.create(code: 21, name: '大津京')
Station.create(code: 22, name: '唐崎')
Station.create(code: 23, name: '比叡山坂本')
Station.create(code: 24, name: 'おごと温泉')
Station.create(code: 25, name: '堅田')
Station.create(code: 26, name: '小野')
Station.create(code: 27, name: '和邇')
Station.create(code: 28, name: '蓬莱')
Station.create(code: 29, name: '志賀')
Station.create(code: 30, name: '比良')
Station.create(code: 31, name: '近江舞子')
Station.create(code: 32, name: '北小松')
Station.create(code: 33, name: '近江高島')
Station.create(code: 34, name: '安曇川')
Station.create(code: 35, name: '新旭')
Station.create(code: 36, name: '近江今津')
Station.create(code: 37, name: '近江中庄')
Station.create(code: 38, name: 'マキノ')
Station.create(code: 39, name: '永原')
Station.create(code: 40, name: '近江塩津')

Station.create(code: 41, name: '手原')
Station.create(code: 42, name: '石部')
Station.create(code: 43, name: '甲西')
Station.create(code: 44, name: '三雲')
Station.create(code: 45, name: '貴生川')
Station.create(code: 46, name: '甲南')
Station.create(code: 47, name: '寺庄')
Station.create(code: 48, name: '甲賀')
Station.create(code: 49, name: '油日')
Station.create(code: 50, name: '柘植')

train_route = TrainRoute.create(code: 1, name: '琵琶湖線')
train_route.train_route_stations_attributes=[
  {:distance=>'10', :station_id =>Station.find_by(name: '京都').id},
  {:distance=>'11', :station_id =>Station.find_by(name: '山科').id},
  {:distance=>'12', :station_id =>Station.find_by(name: '大津').id},
  {:distance=>'13', :station_id =>Station.find_by(name: '膳所').id},
  {:distance=>'14', :station_id =>Station.find_by(name: '石山').id},
  {:distance=>'15', :station_id =>Station.find_by(name: '瀬田').id},
  {:distance=>'16', :station_id =>Station.find_by(name: '南草津').id},
  {:distance=>'17', :station_id =>Station.find_by(name: '草津').id},
  {:distance=>'18', :station_id =>Station.find_by(name: '栗東').id},
  {:distance=>'19', :station_id =>Station.find_by(name: '守山').id},
  {:distance=>'10', :station_id =>Station.find_by(name: '野洲').id},
  {:distance=>'11', :station_id =>Station.find_by(name: '篠原').id},
  {:distance=>'12', :station_id =>Station.find_by(name: '近江八幡').id},
  {:distance=>'13', :station_id =>Station.find_by(name: '安土').id},
  {:distance=>'14', :station_id =>Station.find_by(name: '能登川').id},
  {:distance=>'15', :station_id =>Station.find_by(name: '稲枝').id},
  {:distance=>'16', :station_id =>Station.find_by(name: '河瀬').id},
  {:distance=>'17', :station_id =>Station.find_by(name: '南彦根').id},
  {:distance=>'18', :station_id =>Station.find_by(name: '彦根').id},
  {:distance=>'29', :station_id =>Station.find_by(name: '米原').id},
]
train_route.save
  
# train_route.stations << Station.find_by(name: '京都')
# train_route.stations << Station.find_by(name: '山科')
# train_route.stations << Station.find_by(name: '大津')
# train_route.stations << Station.find_by(name: '膳所')
# train_route.stations << Station.find_by(name: '石山')
# train_route.stations << Station.find_by(name: '瀬田')
# train_route.stations << Station.find_by(name: '南草津')
# train_route.stations << Station.find_by(name: '草津')
# train_route.stations << Station.find_by(name: '栗東')
# train_route.stations << Station.find_by(name: '守山')
# train_route.stations << Station.find_by(name: '野洲')
# train_route.stations << Station.find_by(name: '篠原')
# train_route.stations << Station.find_by(name: '近江八幡')
# train_route.stations << Station.find_by(name: '安土')
# train_route.stations << Station.find_by(name: '能登川')
# train_route.stations << Station.find_by(name: '稲枝')
# train_route.stations << Station.find_by(name: '河瀬')
# train_route.stations << Station.find_by(name: '南彦根')
# train_route.stations << Station.find_by(name: '彦根')
# train_route.stations << Station.find_by(name: '米原')

train_route = TrainRoute.create(code: 2, name: '湖西線')
train_route.train_route_stations_attributes=[
  {:distance=>'20', :station_id =>Station.find_by(name: '京都').id},
  {:distance=>'21', :station_id =>Station.find_by(name: '山科').id},
  {:distance=>'22', :station_id =>Station.find_by(name: '大津京').id},
  {:distance=>'23', :station_id =>Station.find_by(name: '唐崎').id},
  {:distance=>'24', :station_id =>Station.find_by(name: '比叡山坂本').id},
  {:distance=>'25', :station_id =>Station.find_by(name: 'おごと温泉').id},
  {:distance=>'26', :station_id =>Station.find_by(name: '堅田').id},
  {:distance=>'27', :station_id =>Station.find_by(name: '小野').id},
  {:distance=>'28', :station_id =>Station.find_by(name: '和邇').id},
  {:distance=>'29', :station_id =>Station.find_by(name: '蓬莱').id},
  {:distance=>'30', :station_id =>Station.find_by(name: '志賀').id},
  {:distance=>'31', :station_id =>Station.find_by(name: '比良').id},
  {:distance=>'32', :station_id =>Station.find_by(name: '近江舞子').id},
  {:distance=>'33', :station_id =>Station.find_by(name: '北小松').id},
  {:distance=>'34', :station_id =>Station.find_by(name: '近江高島').id},
  {:distance=>'35', :station_id =>Station.find_by(name: '安曇川').id},
  {:distance=>'36', :station_id =>Station.find_by(name: '新旭').id},
  {:distance=>'37', :station_id =>Station.find_by(name: '近江今津').id},
  {:distance=>'38', :station_id =>Station.find_by(name: '近江中庄').id},
  {:distance=>'39', :station_id =>Station.find_by(name: 'マキノ').id},
  {:distance=>'40', :station_id =>Station.find_by(name: '永原').id},
  {:distance=>'41', :station_id =>Station.find_by(name: '近江塩津').id},
]
train_route.save

# train_route.stations << Station.find_by(name: '京都')
# train_route.stations << Station.find_by(name: '山科')
# train_route.stations << Station.find_by(name: '大津京')
# train_route.stations << Station.find_by(name: '唐崎')
# train_route.stations << Station.find_by(name: '比叡山坂本')
# train_route.stations << Station.find_by(name: 'おごと温泉')
# train_route.stations << Station.find_by(name: '堅田')
# train_route.stations << Station.find_by(name: '小野')
# train_route.stations << Station.find_by(name: '和邇')
# train_route.stations << Station.find_by(name: '蓬莱')
# train_route.stations << Station.find_by(name: '志賀')
# train_route.stations << Station.find_by(name: '比良')
# train_route.stations << Station.find_by(name: '近江舞子')
# train_route.stations << Station.find_by(name: '北小松')
# train_route.stations << Station.find_by(name: '近江高島')
# train_route.stations << Station.find_by(name: '安曇川')
# train_route.stations << Station.find_by(name: '新旭')
# train_route.stations << Station.find_by(name: '近江今津')
# train_route.stations << Station.find_by(name: '近江中庄')
# train_route.stations << Station.find_by(name: 'マキノ')
# train_route.stations << Station.find_by(name: '永原')
# train_route.stations << Station.find_by(name: '近江塩津')

train_route = TrainRoute.create(code: 3, name: '草津線')
train_route.train_route_stations_attributes=[
  {:distance=>'30', :station_id =>Station.find_by(name: '草津').id},
  {:distance=>'31', :station_id =>Station.find_by(name: '手原').id},
  {:distance=>'32', :station_id =>Station.find_by(name: '石部').id},
  {:distance=>'33', :station_id =>Station.find_by(name: '甲西').id},
  {:distance=>'34', :station_id =>Station.find_by(name: '三雲').id},
  {:distance=>'35', :station_id =>Station.find_by(name: '貴生川').id},
  {:distance=>'36', :station_id =>Station.find_by(name: '甲南').id},
  {:distance=>'37', :station_id =>Station.find_by(name: '寺庄').id},
  {:distance=>'38', :station_id =>Station.find_by(name: '甲賀').id},
  {:distance=>'39', :station_id =>Station.find_by(name: '油日').id},
  {:distance=>'40', :station_id =>Station.find_by(name: '柘植').id},
]
train_route.save

# train_route.stations << Station.find_by(name: '草津')
# train_route.stations << Station.find_by(name: '手原')
# train_route.stations << Station.find_by(name: '石部')
# train_route.stations << Station.find_by(name: '甲西')
# train_route.stations << Station.find_by(name: '三雲')
# train_route.stations << Station.find_by(name: '貴生川')
# train_route.stations << Station.find_by(name: '甲南')
# train_route.stations << Station.find_by(name: '寺庄')
# train_route.stations << Station.find_by(name: '甲賀')
# train_route.stations << Station.find_by(name: '油日')
# train_route.stations << Station.find_by(name: '柘植')
