# 2017-07-02
# --- users ---
user_admin = Role.find_or_create_by({name: :admin}) # admin権限
user_member = Role.find_or_create_by({name: :member}) # member権限
user_guest = Role.find_or_create_by({name: :guest}) # guest権限

user = User.create(email: 'admin@test.com', password: 'admin3', username: 'admin', role_ids: [ user_admin.id ])
user = User.create(email: 'oya@test.com', password: 'oya333', username: 'oya', role_ids: [ user_member.id ])
user = User.create(email: 'shibata@test.com', password: 'shibata3', username: 'shibata', role_ids: [ user_member.id])
user = User.create(email: 'test@test.com', password: 'test333', username: 'test', role_ids: [ user_admin.id, user_member.id, user_guest.id] )


# -- stations ---
Station.create(code: 1, name: '油日')
Station.create(code: 2, name: '柘植')

# -- curves ---
railway = Railway.create( name: 'cv_sta4370')
railway.points.create(lat: '136.230140000', lng: '34.889120000')
railway.points.create(lat: '136.229040000', lng: '34.890270000')
railway = Railway.create( name: 'cv_rss9127')
railway.points.create(lat: '136.256590000', lng: '34.846010000')
railway.points.create(lat: '136.255740000', lng: '34.847490000')
railway = Railway.create( name: 'cv_rss8751')
railway.points.create(lat: '136.254450000', lng: '34.849710000')
railway.points.create(lat: '136.254500000', lng: '34.849620000')
railway.points.create(lat: '136.254650000', lng: '34.849370000')
railway.points.create(lat: '136.255250000', lng: '34.848370000')
railway.points.create(lat: '136.255740000', lng: '34.847490000')
railway = Railway.create( name: 'cv_rss9326')
railway.points.create(lat: '136.230140000', lng: '34.889120000')
railway.points.create(lat: '136.229040000', lng: '34.890270000')
railway = Railway.create( name: 'cv_sta4123')
railway.points.create(lat: '136.256590000', lng: '34.846010000')
railway.points.create(lat: '136.255740000', lng: '34.847490000')

# -- train_routes ---
train_route = TrainRoute.create(code: '1', name: '草津線')
train_route_station = TrainRouteStation.create(station: Station.find_by(name: '油日'))
train_route.train_route_stations << train_route_station
railsection = Railsection.create(name: 'eb03_5338')
railsection.railways << Railway.find_by(name: 'cv_sta4370')
train_route_station.railsections << railsection
train_route_station = TrainRouteStation.create(station: Station.find_by(name: '柘植'))
train_route.train_route_stations << train_route_station
railsection = Railsection.create(name: 'eb03_5340')
railsection.railways << Railway.find_by(name: 'cv_sta4123')
train_route_station.railsections << railsection