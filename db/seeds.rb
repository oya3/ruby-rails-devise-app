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
railway = Railway.create( name: 'cv_stn4339')
railway.points.create(lat: '136.23014000', lng: '34.88912000')
railway.points.create(lat: '136.22904000', lng: '34.89027000')
railway = Railway.create( name: 'cv_rss8934')
railway.points.create(lat: '136.25659000', lng: '34.84601000')
railway.points.create(lat: '136.25574000', lng: '34.84749000')
railway = Railway.create( name: 'cv_rss8935')
railway.points.create(lat: '136.25445000', lng: '34.84971000')
railway.points.create(lat: '136.25450000', lng: '34.84962000')
railway.points.create(lat: '136.25465000', lng: '34.84937000')
railway.points.create(lat: '136.25525000', lng: '34.84837000')
railway.points.create(lat: '136.25574000', lng: '34.84749000')
railway = Railway.create( name: 'cv_rss8936')
railway.points.create(lat: '136.23014000', lng: '34.88912000')
railway.points.create(lat: '136.22904000', lng: '34.89027000')
railway = Railway.create( name: 'cv_stn4341')
railway.points.create(lat: '136.25659000', lng: '34.84601000')
railway.points.create(lat: '136.25574000', lng: '34.84749000')

# -- train_routes ---
train_route = TrainRoute.create(code: '1', name: '草津線')
train_route_station = TrainRouteStation.new(station_id: Station.find_by(name: '油日').id)
train_route.train_route_stations << train_route_station
railsection = Railsection.new(name: 'eb03_4339')
railway = Railway.find_by(name: 'cv_stn4339')
railsection.railways << railway
train_route_station.railsections << railsection
train_route_station = TrainRouteStation.new(station_id: Station.find_by(name: '柘植').id)
train_route.train_route_stations << train_route_station
railsection = Railsection.new(name: 'eb03_4341')
railway = Railway.find_by(name: 'cv_stn4341')
railsection.railways << railway
train_route_station.railsections << railsection