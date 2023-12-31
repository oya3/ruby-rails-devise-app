# coding: utf-8
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require 'ksj_dataset'

class N02Dataset
  include KSJDataset
  # 内部 :description, :bound, :curves, :sections, :stations
  attr_accessor  :description, :bound, :curves, :sections, :stations
  # 外部 :train_routes, :file_name
  attr_accessor :contents, :train_routes, :file_name
  class Curve
    attr_accessor :key, :pos_array, :size
    def initialize(key, pos_array)
      @key = key
      @pos_array = pos_array
      @size = @pos_array.size
    end
    def get_start
      return @pos_array[0]
    end

    def get_end
      return @pos_array[@size-1]
    end
  end

  # # 入力される contents 情報
  # contents  = {
  #   "name"=>"test",
  #   "description"=>"N02Datasetから取得",
  #   "infile"=>"N02-15.xml",
  #   "outfile"=>"seeds.rb",
  #   "train_routes"=>[
  #     {"name"=>"草津線",
  #      "company"=>"西日本旅客鉄道",
  #      "stations"=>[
  #        {"name"=>"油日"},
  #        {"name"=>"柘植"}
  #      ]
  #     },
  #   ]
  # }
  #
  # # 本関数で contents に追加される内容
  # contents  = {
  #   "train_routes"=>[
  #     {"name"=>"草津線",
  #      "company"=>"西日本旅客鉄道",
  #      "stations"=>[
  #        {
  #          "name"=>"油日",
  #          "keys"=>["eb03_5338"], # 駅ホームのカーブ情報が付加される
  #          "section_keys"=>["eb02_11933", "eb02_11934", "eb02_11935"] # 次の駅までの線路カーブ情報
  #        },
  #        {
  #          "name"=>"柘植",
  #          "keys"=>["eb03_5340"], # 駅ホームのカーブ情報が付加される
  #          # 次の駅が存在しないので路線カーブ情報は無い
  #        }
  #      ],
  #      # この路線の全線路カーブ情報
  #      "section_keys"=>[
  #        "eb02_11913",
  #        "eb02_11917",
  #        "eb02_11918",
  #        "eb02_11920",
  #        "eb02_11921",
  #        "eb02_11924",
  #        "eb02_11925",
  #        "eb02_11926",
  #        "eb02_11927",
  #        "eb02_11929",
  #        # ...
  #      ]
  #     },
  #   ],
  #   "n02dataset"=>{
  #     "description"=> "国土数値情報 N02-15.xml",
  #     "bound"=>{
  #       "src_name"=>"JGD2011 / (B, L)",
  #       "frame"=>"GC / JST",
  #       "lower_corner"=>{"lat"=>"26.193190000", "lng"=>"127.652280000"},
  #       "upper_corner"=>{"lat"=>"45.416880000", "lng"=>"145.597430000"},
  #       "bigin_position"=>{"calendar_era_name"=>"西暦", "year"=>"1900"}
  #     },
  #     "curves"=>{
  #       "cv_sta1"=>[
  #         {"lat"=>"141.286590000", "lng"=>"40.260920000"},
  #         {"lat"=>"141.285380000", "lng"=>"40.258740000"}
  #       ],
  #       "cv_sta2"=>[
  #         {"lat"=>"141.290820000", "lng"=>"40.286150000"},
  #         {"lat"=>"141.290890000", "lng"=>"40.285820000"}
  #       ]
  #     },
  #     "sections"=>{
  #       "eb02_3000"=>{
  #         "location"=>"cv_rss1",
  #         "railway_type"=>"23",
  #         "service_provider_type"=>"5",
  #         "railway_line_name"=>"沖縄都市モノレール線",
  #         "operation_company"=>"沖縄都市モノレール"
  #       },
  #       "eb02_3001"=>{
  #         "location"=>"cv_rss2",
  #         "railway_type"=>"12",
  #         "service_provider_type"=>"5",
  #         "railway_line_name"=>"いわて銀河鉄道線",
  #         "operation_company"=>"アイジーアールいわて銀河鉄道"
  #       }
  #     }
  #     "stations"=>{
  #       "eb03_1053"=>{
  #         "location"=>"cv_sta1",
  #         "railway_type"=>"12",
  #         "service_provider_type"=>"5",
  #         "railway_line_name"=>"いわて銀河鉄道線",
  #         "operation_company"=>"アイジーアールいわて銀河鉄道",
  #         "station_name"=>"二戸",
  #         "railroad_section"=>"eb02_3003"
  #       },
  #       "eb03_1056"=>{
  #         "location"=>"cv_sta2",
  #         "railway_type"=>"12",
  #         "service_provider_type"=>"5",
  #         "railway_line_name"=>"いわて銀河鉄道線",
  #         "operation_company"=>"アイジーアールいわて銀河鉄道",
  #         "station_name"=>"斗米",
  #         "railroad_section"=>"eb02_3004"
  #       }
  #     }
  #   }
  # }
  
  def initialize(contents)
    @contents = contents
    raise "n02_dataset#initialize error 00" unless contents.has_key? :train_routes
    raise "n02_dataset#initialize error 01" unless contents.has_key? :infile
    @train_routes = contents[:train_routes]
    @file_name = contents[:infile]
    raise "n02_dataset#initialize error 02" unless File.exist?(@file_name)
    load_file @file_name
    
    # n02datasetを保持させておく
    @contents[:n02dataset] = Hash.new
    @contents[:n02dataset][:description] = @description
    @contents[:n02dataset][:bound] = @bound
    @contents[:n02dataset][:curves] = @curves
    @contents[:n02dataset][:sections] = @sections
    @contents[:n02dataset][:stations] = @stations
    
    setup_train_route
    make_between_station_curve
  end

  # stationに紐づいてるカーブを取得
  def get_station_curve(skey)
    raise "ERROR: get_station_curve() not found skey #{skey}" unless @stations.has_key? skey
    ckey = @stations[skey][:location]
    raise "ERROR: get_station_curve() not found ckey #{ckey}" unless @curves.has_key? ckey
    curve = Curve.new ckey, @curves[ckey]
    curve
  end

  private
  # 外部から指定されたtrain_routes情報にxmlから取得した情報を付加する
  def setup_train_route
    @train_routes.each do |train_route|
      # train_route[:name] # 路線名
      # train_route[:company] # 会社
      train_route[:section_keys] = Array.new
      @sections.each do |key,value|
        if value[:railway_line_name] == train_route[:name] &&
           value[:operation_company] == train_route[:company]
          train_route[:section_keys] << key # 対象のrailroadsection番号を取得
        end
      end
      # 駅の駅ホームカーブを取得する
      # n02_xxから取得した全国の駅名をもってるので
      # 第一ループはn02_xxで取得したものを回す
      @stations.each do |key,value|
        # configファイルで指定された駅にマッチしたかを確認している
        train_route[:stations].each do |station|
          # station[:name] # 駅名
          if value[:railway_line_name] == train_route[:name] &&
             value[:operation_company] == train_route[:company] &&
             value[:station_name] == station[:name]
            station[:keys] = Array.new unless station.has_key? :keys
            station[:keys] << key # 対象のstation番号を取得(複数ある)
          end
        end
      end
      # ここでconfigファイルに指定された駅が無い場合はエラー表示する
      not_found_stations = Array.new
      train_route[:stations].each do |station|
        not_found_stations << station[:name] unless station.has_key? :keys
      end
      if not_found_stations.size >= 1
        msg = not_found_stations.join("\n")
        raise "ERROR: not found station\n#{msg}"
      end
      
    end
  end

  # section_keysからcurveにマッチしたキーを取得する
  def get_section_key(section_keys, curve)
    section_keys.each do |section_key|
      section = @sections[section_key]
      temp_curve = @curves[section[:location]]
      if curve.size == temp_curve.size
        count = curve.size
        curve.size.times do |i|
          #   [{:lat=>"127.67948000", :lng=>"26.21454000"},
          if curve[i][:lat] == temp_curve[i][:lat] &&
             curve[i][:lng] == temp_curve[i][:lng]
            count -= 1
          end
        end
        return section_key if count == 0
      end
    end
    raise "get_section_key エラー"
  end

  # 指定したsection_nameの先頭、末尾の位置情報を返す
  # return [
  #   {"lat"=>"141.290820000", "lng"=>"40.286150000"}, # 0: first
  #   {"lat"=>"141.290890000", "lng"=>"40.285820000"}  # 1: last
  # }
  def get_first_last_curve_point(section_key)
    raise "get_first_last_curve_point error 00" unless @sections.has_key? section_key
    section = @sections[section_key]
    curve_points = @curves[section[:location]]
    raise "get_first_last_curve_point error 01" if curve_points.size <= 1
    last_index = curve_points.size - 1
    return [curve_points[0], curve_points[last_index]]
  end

  def get_points_from_section_key(section_key)
    raise "ERROR: 指定したsection_key[#{section_key}]がない" unless @sections.has_key? section_key
    section = @sections[section_key]
    raise "ERROR: カーブがない[#{section[:location]}]" unless @curves.has_key? section[:location]
    return @curves[section[:location]]
  end
  
  # 指定したpointがfirst,lastにあるsection_nameを得る
  def find_section_name(all_names, point)
    all_names.each do |key,value|
      next if value == :use
      points = get_points_from_section_key(key) # セクション名から座標位置を取得
      [ 0, (points.size-1)].each do |i|
        if points[i][:lat] == point[:lat] && points[i][:lng] == point[:lng]
          # name: section_key名, index: 発見した位置(0:first,1:last), points: 座標配列, size: 座標数
          return {name: key, index: i, points: points, size: point.size }
        end
      end
    end
    return nil # 発見できない
  end
  
  
  # 指定したscetion_name1,section_name2間のsection名を取得する
  # between_sections = get_between_sections( station_name1, station_name2, stations_section_key, train_route[:section_keys] )
  def get_between_sections( station_name1, station_name2, stations_section_key, section_name_keys)

    # 一度使ったsection_name_keyは使わせないためようエリア
    all_names = Hash.new
    section_name_keys.each do |name|
      all_names[name] = :nouse
    end
    
    # 対象2駅のsection_key名を取得
    raise "ERROR: get_between_sections() unknown station_name1[#{station_name1}]" unless stations_section_key.has_key? station_name1
    raise "ERROR: get_between_sections() unknown station_name2[#{station_name2}]" unless stations_section_key.has_key? station_name2
    section_name1 = stations_section_key[station_name1]
    section_name2 = stations_section_key[station_name2]
    
    # 開始、終了のsection名があるか確認
    raise "get_between_sections エラー section_name1[#{section_name1}]" unless all_names.has_key? section_name1
    raise "get_between_sections エラー section_name2[#{section_name2}]" unless all_names.has_key? section_name2
    all_names[section_name1] = :use
    # all_names[section_name2] = :use

    start_point = get_first_last_curve_point(section_name1)
    end_point = get_first_last_curve_point(section_name2)

    # first[0] and last[1] = 2 times
    out = nil
    complete = false
    2.times do |i|
      _out = Array.new
      _out << section_name1
      _all_names = all_names.clone
      target_point = start_point[i]
      # 指定したpointがあるsection_nameを得る
      while (find = find_section_name(_all_names, target_point))
        index = find[:index]
        find_point = find[:points][index] # indexはfirst(0)かlast(1)の見つけた側の番号が入る
        _all_names[find[:name]] = :use
        
        # 見つけたsection_keyが対象2駅以外の駅カーブ情報と一致したら無視する（環状なんかのループで逆回りを防止するため用）
        find_inner_station = false
        stations_section_key.each do |name,key|
          next if name == station_name1 # 対象駅１ならチェックしない
          next if name == station_name2 # 対象駅２ならチェックしない
          
          curve = get_points_from_section_key key
          # pointが同値の場合は別の駅情報となるはず。。。
          next if curve.size != find[:points].size
          count = curve.size
          curve.size.times do |i|
            if curve[i][:lat] == find[:points][i][:lat] && curve[i][:lng] == find[:points][i][:lng]
              count -= 1
            end
          end
          if count == 0
            find_inner_station = true
          end
        end
        next if find_inner_station
        
        _out << find[:name] # 対象
        # 探し出したpointがend_pointのfirstかlastにマッチしたか確認
        2.times do |i|
          if( end_point[i][:lat] == find_point[:lat] && end_point[i][:lng] == find_point[:lng] )
            complete = true
            break
          end
        end
        if complete
          break
        end
        # 次のsection名を探す
        target_point = index == 0 ? find[:points][ find[:points].size - 1  ]: find[:points][0]
      end
      if complete
        out = _out
        break
      end
    end
    raise "ERROR: get_between_sections" if out.nil?
    return out
  end

  # train_routes(路線情報) に紐づく駅(stations)の順番通りの駅間の線路情報を作成する
  # 
  # 以下の方法では対応できなかった。2017/07/03
  # 例えば、train_routes[0].stations[0]（駅1) と train_routes[0].stations[1] (駅2)の場合、
  # この路線の全路線カーブ情報から、駅１、駅２の駅ホームのカーブ情報にマッチする路線情報名(eb02_xxx)を
  # 抽出し、２つの路線情報の間にある路線情報が駅間の路線情報名とする。
  # 抽出した路線情報名が駅１がeb02_001、駅２がeb02_003 の場合、eb02_001,eb02_002,eb02_003 が駅間の路線情報となる
  def make_between_station_curve
    @train_routes.each do |train_route|

      # 路線駅の全て駅ホームカーブと同値の路線情報名(section_key)を取得
      stations_section_key = Hash.new
      train_route[:stations].each.with_index(0) do |station|
        curve = get_station_curve station[:keys][0] # TODO: [0] は複数駅情報があっても１つめを対象。要考慮が必要
        stations_section_key[station[:name]] = get_section_key(train_route[:section_keys],curve.pos_array)
      end
      
      between_station_count = train_route[:stations].size - 1 # 駅間数
      between_station_count.times do |i|
        # # FIXME: 駅間の線路カーブを取得する実験的な試み 2017/07/03
        station_name1 = train_route[:stations][i][:name]
        station_name2 = train_route[:stations][i+1][:name]
        between_sections = get_between_sections( station_name1, station_name2, stations_section_key, train_route[:section_keys] )
        train_route[:stations][i+0][:section_keys] = between_sections
      end
      # ループ（環状線)か判断
      station = train_route[:stations][between_station_count]
      if station.has_key? :next
        station_name1 = station[:name]
        station_name2 = station[:next]
        between_sections = get_between_sections( station_name1, station_name2, stations_section_key, train_route[:section_keys] )
        train_route[:stations][between_station_count][:section_keys] = between_sections
      end
      
    end
  end
  
  # :description
  # =>"国土数値情報（鉄道）データ N02-13.xml"
  #
  # :bound
  # =>:src_name=>"JGD2000 / (B, L)",
  #  :frame=>"GC / JST",
  #  :lower_corner=>{:lat=>"26.19315000", :lng=>"127.65228000"},
  #  :upper_corner=>{:lat=>"45.41688000", :lng=>"145.59801000"},
  #  :bigin_position=>{:calendar_era_name=>"西暦", :year=>"1900"},
  #  :end_position=>{:indeterminate_position=>"unknown"}}
  #
  # 経度,緯度の連続情報から曲線を表すデータ群
  # :curves
  # =>"cv_rss1"=>
  #   [{:lat=>"127.67948000", :lng=>"26.21454000"},
  #    {:lat=>"127.67970000", :lng=>"26.21474000"},
  #    {:lat=>"127.67975000", :lng=>"26.21480000"},
  #    {:lat=>"127.68217000", :lng=>"26.21728000"},
  #    {:lat=>"127.68357000", :lng=>"26.21862000"},
  #    {:lat=>"127.68394000", :lng=>"26.21891000"},
  #    {:lat=>"127.68419000", :lng=>"26.21905000"}],
  #
  # :curve情報がどの路線に紐づくかを表すデータ群
  # :sections
  # =>"eb02_3"=>
  #   {:location=>"cv_rss3",
  #    :railway_type=>"12",
  #    :service_provider_type=>"5",
  #    :railway_line_name=>"いわて銀河鉄道線",
  #    :operation_company=>"アイジーアールいわて銀河鉄道"},
  #
  # 路線名、鉄道会社、駅名の情報を表すデータ群。またその駅の位置(駅ホームのカーブ)情報も持つ
  # :stations
  # =>"eb03_1"=>
  #   {:location=>"cv_stn1",
  #    :railway_type=>"11",
  #    :service_provider_type=>"2",
  #    :railway_line_name=>"指宿枕崎線",
  #    :operation_company=>"九州旅客鉄道",
  #    :station_name=>"二月田",
  #    :railroad_section=>"eb02_2881"},
  def load_file(file_name)
    begin
      file_body = File.read file_name.encode('cp932')
      file_body.gsub!("\r\n","\n") # mac だけ必要?

      # 不要なヘッダ削除
      # <?xml version=\"1.0\" encoding=\"UTF-8\"?>
      file_body.gsub!(/\<\?xml version\=.+?\?\>/) { "# xml" }
      file_body.gsub!(/\<ksj\:Dataset gml\:id=\".+?\".+?\>/m) { "# ksj:Dataset" }
      file_body.gsub!(/\<\/ksj\:Dataset\>/) { "# \/ksj:Dataset" }
      
      # タイトル取得
      file_body.gsub!(/\<gml\:description\>(.+?)\<\/gml\:description\>/m) do
        @description = $1
        "# gml:description"
      end
      
      # バウンドデータ取得
      @bound = get_xml_bound(file_body)
      # カーブデータ取得
      @curves = get_xml_curves(file_body)
      # レールデータ取得
      @sections = get_xml_commons(file_body,'RailroadSection')
      # 駅データ取得
      @stations = get_xml_commons(file_body,'Station')
  
      # 取りこぼしデータチェック
      if file_body =~ /[\<\>]/
        raise "取りこぼしている\n#{file_body}"
      end
    rescue => exception
      puts "Exception:#{exception.message}"
      puts $@
    ensure
    end
  end
end
