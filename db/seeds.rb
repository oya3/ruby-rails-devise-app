# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# 権限の種類を登録
[ :admin, :member, :guest ].each do |role|
  Role.find_or_create_by({name: role})
end
user = User.create(email: 'admin@test.com', password: 'admin3', username: 'admin')
user.add_role :admin # admin権限付与
user = User.create(email: 'oya@test.com', password: 'oya333', username: 'oya')
user.add_role :member # member権限付与
user = User.create(email: 'shibata@test.com', password: 'shibata3', username: 'shibata')
user.add_role :member # member権限付与

Station.create(code: 1, name: '京都')
Station.create(code: 2, name: '山科')
Station.create(code: 3, name: '大津')
Station.create(code: 4, name: '膳所')

TrainRoute.create(name: '琵琶湖線')
TrainRoute.create(name: '湖西線')

TrainRoute.find_by(name: '琵琶湖線').stations << Station.find_by(name: '京都')
TrainRoute.find_by(name: '琵琶湖線').stations << Station.find_by(name: '山科')
TrainRoute.find_by(name: '琵琶湖線').stations << Station.find_by(name: '大津')
TrainRoute.find_by(name: '琵琶湖線').stations << Station.find_by(name: '膳所')

TrainRoute.find_by(name: '湖西線').stations << Station.find_by(name: '京都')
TrainRoute.find_by(name: '湖西線').stations << Station.find_by(name: '山科')
