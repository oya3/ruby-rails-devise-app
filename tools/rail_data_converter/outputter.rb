# coding: utf-8
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

class Outputter
  # attr_accessor  :contents, :info_train_routes, :info_stations, :info_curces
  
  def initialize(contents)
    @contents = contents
    @results = Hash.new
    @info_train_routes = Array.new
    @info_stations = Hash.new
    @info_curves = Hash.new
    @info_between_stations = Array.new
    analyze
  end

  def put
    make_users
    make_stations
    make_curves
    make_train_routes
    all = Array.new
    all << ["# --- users ---"]
    all << @results[:users]
    all << ["\n# -- stations ---"]
    all << @results[:stations]
    all << ["\n# -- curves ---"]
    all << @results[:curves]
    all << ["\n# -- train_routes ---"]
    all << @results[:train_routes]
    return all.join "\n"
  end

  private
  def make_users
    @results[:users] = <<'USERS_END'
user_admin = Role.find_or_create_by({name: :admin}) # admin権限
user_member = Role.find_or_create_by({name: :member}) # member権限
user_guest = Role.find_or_create_by({name: :guest}) # guest権限

user = User.create(email: 'admin@test.com', password: 'admin3', username: 'admin', role_ids: [ user_admin.id ])
user = User.create(email: 'oya@test.com', password: 'oya333', username: 'oya', role_ids: [ user_member.id ])
user = User.create(email: 'shibata@test.com', password: 'shibata3', username: 'shibata', role_ids: [ user_member.id])
user = User.create(email: 'test@test.com', password: 'test333', username: 'test', role_ids: [ user_admin.id, user_member.id, user_guest.id] )
USERS_END
  end
  
  def make_stations
    out = Array.new
    @results[:stations] = out
    @info_stations.each.with_index(1) do |(station_name,id),index|
      out << "Station.create(code: #{index}, name: '#{station_name}')"
    end
  end


  # curve は railway とする
  def make_curves
    out = Array.new
    @results[:curves] = out
    n02dataset = @contents[:n02dataset]
    curves = n02dataset[:curves]
    @info_curves.each.with_index(1) do |(curve_name,id),index|
      out << "railway = Railway.create( name: '#{curve_name}')"
      if curves[curve_name].nil?
        binding.pry
      end
      curves[curve_name].each do |curve|
        out << "railway.points.create(lat: '#{curve[:lat]}', lng: '#{curve[:lng]}')"
      end
    end
  end

  # section は railsection とする
  def make_train_routes
    train_routes = @contents[:train_routes]
    n02dataset = @contents[:n02dataset]
    out = Array.new
    @results[:train_routes] = out
    # 路線
    train_routes.each.with_index(1) do |train_route,train_route_code|
      out << "train_route = TrainRoute.create(code: '#{train_route_code}', name: '#{train_route[:name]}')"
      # 駅
      train_route[:stations].each.with_index(0) do |station,station_code|
        # 駅追加
        out << "train_route_station = TrainRouteStation.new(station_id: Station.find_by(name: '#{station[:name]}').id)"
        out << "train_route.train_route_stations << train_route_station"
        # 駅カーブ追加
        curve_name = n02dataset[:stations][ station[:keys][0] ][:location]
        out << "railsection = Railsection.new(name: '#{station[:keys][0]}')"
        out << "railway = Railway.find_by(name: '#{curve_name}')"
        out << "railsection.railways << railway"
        out << "train_route_station.railsections << railsection"
      end
    end
  end

  # 駅名一覧
  # カーブ一覧
  def analyze
    train_routes = @contents[:train_routes]
    n02dataset = @contents[:n02dataset]
    # 路線
    train_routes.each.with_index(0) do |train_route,train_route_id|
      #binding.pry
      #@info_train_routes[train_route[:name]] = @info_train_routes.size unless @info_train_routes.has_key? train_route[:name]
      # 駅
      train_route[:stations].each.with_index(0) do |station,station_id|
        # 新駅登場の場合、保持
        @info_stations[station[:name]] = @info_stations.size unless @info_stations.has_key? station[:name]
        
        # 新駅カーブ登場の場合、保持
        curve_name = n02dataset[:stations][ station[:keys][0] ][:location]
        @info_curves[curve_name] = @info_curves.size unless @info_curves.has_key? curve_name
        # 新路線カーブ登場の場合、保持
        next unless station.has_key? :section_keys
        station[:section_keys].each do |section_name|
          curve_name = n02dataset[:sections][ section_name ][:location]
          @info_curves[curve_name] = @info_curves.size unless @info_curves.has_key? curve_name
        end

        # # 次の駅があればbetween_stationsを作成
        # next if station_id == (train_route[:stations].size -1)
      end
    end
  end

  
  # def analyze(contents)
  #   train_routes = contents[:train_routes]
  #   n02dataset = contents[:n02dataset]
  #   train_routes.each.with_index(0) do |train_route,train_route_id|
  #     info_train_route = Hash.new
  #     @info_train_routes << info_train_route
  #     info_train_route[:name] = train_route[:name]
  #     info_train_route[:company] = train_route[:company]
  #     info_stations = Array.new
  #     info_train_route[:stations] = info_stations
  #     train_route[:stations].each.with_index(0) do |station,station_id|
  #       # 駅名が新たに登場したら覚える。ついでに番号も
  #       @stations[station[:name]] = @stations.size unless @stations.has_key? station[:name]
  #       info_station = Hash.new
  #       info_stations << info_station
  #       info_station[:name] = station[:name]
  #       curve_name = n02dataset[ station[:keys][0] ][:location]
  #       @info_curves[curve_name] = @info_curves.size unless @info_curves.has_key? curve_name
  #       info_station[:curve] = curve_name
        
  #       # 次の駅があればbetween_stationsを作成
  #       next if station_id == (train_route[:stations].size -1)
  #       info_between_station = Hash.new
  #       @info_between_stations << info_between_station
  #       next_station = train_route[:stations][station_id+1]
  #       @stations[next_station[:name]] = @stations.size unless @stations.has_key? station_next[:name]
        
  #     end
  #   end
end

