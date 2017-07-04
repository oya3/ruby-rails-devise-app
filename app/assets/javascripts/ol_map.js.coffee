$ ->
  map = new (ol.Map)(
    layers: [ new (ol.layer.Tile)(source: new (ol.source.OSM)) ]
    target: 'ol_map'
    controls: ol.control.defaults(attributionOptions: collapsible: false)
    view: new (ol.View)(
      # center: ol.proj.transform([136.0785, 35.2269], 'EPSG:4326', 'EPSG:3857')
      center: ol.proj.transform([136.0785, 35.2269], 'EPSG:4326', 'EPSG:3857')
      zoom: 9
    )
  )

  $('#zoom-out').onclick = ->
    view = map.getView()
    zoom = view.getZoom()
    view.setZoom zoom - 1
    return

  $('#zoom-in').onclick = ->
    view = map.getView()
    zoom = view.getZoom()
    view.setZoom zoom + 1
    return

  railwayLayers = {}
  addRailway = (json, item_data) ->
    # json.railsections[0].railways[0].points[0]
    # json.railsections.length
    lineStrArray = new Array
    $.each json.railsections, (rsi,railsection) ->
      $.each railsection.railways, (rwi,railway) ->
        pi = 0
        # point$.each railway.points, (pi,point) ->
        while pi < railway.points.length - 1
          point0 = railway.points[pi]
          point1 = railway.points[pi+1]
          lineStrArray.push [
            [parseFloat(point0.lat),parseFloat(point0.lng)]
            [parseFloat(point1.lat),parseFloat(point1.lng)]
          ]
          pi++
    lineStrings = new (ol.geom.MultiLineString)([])
    lineStrings.setCoordinates lineStrArray
    vectorFeature = new (ol.Feature)(lineStrings.transform('EPSG:4326', 'EPSG:3857'))
    vectorSource = new (ol.source.Vector)(features: [ vectorFeature ])
    # 経路用の vector layer の作成
    railwayLayer = new (ol.layer.Vector)(
      source: vectorSource
      style: new (ol.style.Style)(stroke: new (ol.style.Stroke)(
        color: item_data.color
        width: 10)))
    # vector layer の追加
    map.addLayer railwayLayer
    railwayLayers[item_data.id] = railwayLayer
    map.setIndex(railwayLayer, -1)
    return

  $('.ol_railway_delete').click ->
    $.each railwayLayers, (id,railwayLayer) ->
      map.removeLayer railwayLayer
    railwayLayers = {}

  $('.ol_railway').click ->
    item_data = $(this).data()
    if item_data.id of railwayLayers
      return
    $.ajax
      type: 'GET'
      url: item_data.getUrl
      dataType: 'json'
      # data: params
      success: (json) ->
        addRailway( json, item_data)
        return

  stationLayers = {}
  addStation = (json, item_data) ->
    # json.railsections[0].railways[0].points[0]
    # json.railsections.length
    lineStrArray = new Array
    $.each json.railsections, (rsi,railsection) ->
      $.each railsection.railways, (rwi,railway) ->
        pi = 0
        # point$.each railway.points, (pi,point) ->
        while pi < railway.points.length - 1
          point0 = railway.points[pi]
          point1 = railway.points[pi+1]
          lineStrArray.push [
            [parseFloat(point0.lat),parseFloat(point0.lng)]
            [parseFloat(point1.lat),parseFloat(point1.lng)]
          ]
          pi++
    lineStrings = new (ol.geom.MultiLineString)([])
    lineStrings.setCoordinates lineStrArray
    vectorFeature = new (ol.Feature)(lineStrings.transform('EPSG:4326', 'EPSG:3857'))
    vectorSource = new (ol.source.Vector)(features: [ vectorFeature ])
    # 経路用の vector layer の作成
    stationLayer = new (ol.layer.Vector)(
      source: vectorSource
      style: new (ol.style.Style)(stroke: new (ol.style.Stroke)(
        color: item_data.color
        width: 10)))
    # vector layer の追加
    map.addLayer stationLayer
    stationLayers[item_data.id] = stationLayer
    return

  $('.ol_station_delete').click ->
    $.each stationLayers, (id,stationLayer) ->
      map.removeLayer stationLayer
    stationLayers = {}

  $('.ol_station').click ->
    item_data = $(this).data()
    if item_data.id of stationLayers
      return
    $.ajax
      type: 'GET'
      url: item_data.getUrl
      dataType: 'json'
      success: (json) ->
        addStation( json, item_data)
        return

        
