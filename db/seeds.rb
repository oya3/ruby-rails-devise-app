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

