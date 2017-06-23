# coding: utf-8
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

module KSJDataset
  def get_xml_bound(file_body)
    bound = Hash.new
    file_body.gsub!(/\<gml\:boundedBy\>.+?\<gml\:EnvelopeWithTimePeriod srsName\=\"(.+?)\" frame\=\"(.+?)\"\>(.+?)\<\/gml\:EnvelopeWithTimePeriod\>.+?\<\/gml\:boundedBy\>/m) do
      bound[:src_name] = $1
      bound[:frame] = $2
      body = $3
      if body =~ /\<gml\:lowerCorner\>([0-9\.]+?)\s+([0-9\.]+?)\<\/gml\:lowerCorner\>/
        pos = { :lat => $1, :lng => $2}
        bound[:lower_corner] = pos
      end
      if body =~ /\<gml\:upperCorner\>([0-9\.]+?)\s+([0-9\.]+?)\<\/gml\:upperCorner\>/
        pos = { :lat => $1, :lng => $2}
        bound[:upper_corner] = pos
      end
      if body =~ /\<gml\:beginPosition calendarEraName\=\"(.+?)\"\>(\d+?)\<\/gml\:beginPosition\>/
        hash = { :calendar_era_name => $1, :year => $2}
        bound[:bigin_position] = hash
      end
      if body =~ /\<gml\:endPosition indeterminatePosition=\"(.+?)\"\/\>/
        hash = { :indeterminate_position => $1 }
        bound[:end_position] = hash
      end
      "# bml:boundedBy"
    end
    return bound
  end
  
  def get_xml_curves(file_body)
    curves = Hash.new
    # file_body.gsub!(/\<gml\:Curve gml\:id\=\"(.+?)\"\>.+?\<gml\:posList\>(.+?)\<\/gml\:posList\>.+?\<\/gml\:Curve\>/m) do |curve|
    file_body.gsub!  (/\<gml\:Curve gml\:id\=\"(.+?)\"\>.+?\<gml\:posList\>(.+?)\<\/gml\:posList\>.+?\<\/gml\:Curve\>/m) do |curve|
      key = $1
      poslists = $2.split("\n")
      posArray = Array.new
      poslists.each do|pos|
        if pos =~ /(-*[0-9\.]+?)\s+(-*[0-9\.]+?)$/
          pos = Hash.new
          pos[:lat] = $2
          pos[:lng] = $1
          posArray << pos
        end
      end
      curves[key] = posArray
      "# #{key}"
    end
    return curves
  end

  # レール
  # <ksj:location xlink:href="#cv_rss17298"/>
  # <ksj:railwayType>11</ksj:railwayType>
  # <ksj:serviceProviderType>2</ksj:serviceProviderType>
  # <ksj:railwayLineName>八戸線</ksj:railwayLineName>
  # <ksj:operationCompany>東日本旅客鉄道</ksj:operationCompany>
  # <ksj:station xlink:href="#eb03_8090"/>
  # 駅
  # <ksj:location xlink:href="#cv_stn3081"/>
  # <ksj:railwayType>12</ksj:railwayType>
  # <ksj:serviceProviderType>4</ksj:serviceProviderType>
  # <ksj:railwayLineName>多摩線</ksj:railwayLineName>
  # <ksj:operationCompany>小田急電鉄</ksj:operationCompany>
  # <ksj:stationName>新百合ヶ丘</ksj:stationName>
  # <ksj:railroadSection xlink:href="#eb02_6211"/>
  def get_xml_commons(file_body,ksj_name)
    commons = Hash.new
    file_body.gsub!(/\<ksj\:#{ksj_name} gml\:id=\"(.+?)\"\>(.+?)\<\/ksj\:#{ksj_name}\>/m) do |rail_road|
      key = $1
      body = $2
      hash = Hash.new
      # レール＆駅 共通エリア
      if body =~ /\<ksj\:location xlink\:href\=\"\#(.+?)\"\/\>/
        hash[:location] = $1
      end
      if body =~ /\<ksj\:railwayType\>(\d+?)\<\/ksj\:railwayType\>/
        hash[:railway_type] = $1
      end
      if body =~ /\<ksj\:serviceProviderType\>(\d+?)\<\/ksj\:serviceProviderType\>/
        hash[:service_provider_type] = $1
      end
      if body =~ /\<ksj\:railwayLineName>(.+?)\<\/ksj\:railwayLineName\>/
        hash[:railway_line_name] = $1
      end
      if body =~ /\<ksj\:operationCompany\>(.+?)\<\/ksj\:operationCompany\>/
        hash[:operation_company] = $1
      end
      # レール専用エリア
      if body =~ /\<ksj\:station xlink\:href\=\"\#(.+?)\"\/\>/
        hash[:station] = $1
      end
      
      # 駅専用エリア
      if body =~ /\<ksj\:stationName\>(.+?)\<\/ksj\:stationName\>/
        hash[:station_name] = $1
      end
      if body =~ /\<ksj\:railroadSection xlink\:href\=\"\#(.+?)\"\/\>/
        hash[:railroad_section] = $1
      end
      
      commons[key] = hash
      "# #{key}"
    end
    return commons
  end

end

