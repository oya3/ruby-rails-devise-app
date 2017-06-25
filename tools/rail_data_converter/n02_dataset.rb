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

  def initialize(contents)
    @contents = contents
    @train_routes = contents[:train_routes]
    @file_name = contents[:infile]
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
    ckey = @stations[skey][:location]
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

      @stations.each do |key,value|
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
  
  def make_between_station_curve
    @train_routes.each do |train_route|
      between_stations = train_route[:stations].size - 1 # 駅間数

      between_stations.times do |i|
        mt = Array.new
        2.times do |j|
          station = train_route[:stations][i+j]
          curve = get_station_curve station[:keys][0]
          # train_routeに所属するsection情報から curve.pos_arrayと同じ
          # カーブポジションを持ってるsection_keyを取得する
          section_key = get_section_key(train_route[:section_keys],curve.pos_array)
          mt[j] = section_key.match(/eb02_(\d+)/)
        end
        if mt[0].nil? || mt[1].nil?
          raise "make_between_station_curve エラー"
        end
        start_number = mt[0][1].to_i
        end_number = mt[1][1].to_i
        if start_number > end_number
          start_number = mt[1][1].to_i
          end_number = mt[0][1].to_i
        end
        section_keys = Array.new
        for num in start_number..end_number do
          section_keys << "e02_#{num}"
        end
        # train_routes.stationsに:section_keys追加
        train_route[:stations][i+0][:section_keys] = section_keys
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
  # :sections
  # =>"eb02_3"=>
  #   {:location=>"cv_rss3",
  #    :railway_type=>"12",
  #    :service_provider_type=>"5",
  #    :railway_line_name=>"いわて銀河鉄道線",
  #    :operation_company=>"アイジーアールいわて銀河鉄道"},
  #
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
      file_body.gsub!(/\<\?xml version=\"1\.0\" encoding\=\"UTF\-8\" \?\>/) { "# xml" }
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
        raise "取りこぼしている"
      end
    rescue => exception
      puts "Exception:#{exception.message}"
      puts $@
    ensure
    end
  end
end
