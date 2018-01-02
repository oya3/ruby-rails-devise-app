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

  # $('.ol_railway_delete').click ->
  $(document).on 'click', '.ol_railway_delete', ->
    $.each railwayLayers, (id,railwayLayer) ->
      map.removeLayer railwayLayer
    railwayLayers = {}

  # $('.ol_railway').click ->
  $(document).on 'click', '.ol_railway', ->
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

  convertCoordinate = (lat, lng) ->
    ol.proj.transform [
      lat
      lng
    ], 'EPSG:4326', 'EPSG:3857'

  markerStyleDefault = new (ol.style.Style)(image: new (ol.style.Icon)(
    anchor: [
      0.5
      1
    ]
    anchorXUnits: 'fraction'
    anchorYUnits: 'fraction'
    opacity: 0.75
    src: 'assets/icons/marker.png'))

  stationLayers = {}
  addStation = (json, item_data) ->
    # json.railsections[0].railways[0].points[0]
    # json.railsections.length
    lineStrArray = new Array
    lat = 0.0
    lng = 0.0
    cnt = 0
    $.each json.railsections, (rsi,railsection) ->
      $.each railsection.railways, (rwi,railway) ->
        pi = 0
        # point$.each railway.points, (pi,point) ->
        while pi < railway.points.length
          point = railway.points[pi]
          lat += parseFloat(point.lat)
          lng += parseFloat(point.lng)
          cnt++
          pi++
    lat = lat/cnt
    lng = lng/cnt
    markerFeature = new (ol.Feature)(geometry: new (ol.geom.Point)(convertCoordinate(lat, lng)))
    markerSource = new (ol.source.Vector)(features: [markerFeature])
    # 駅用の station layer の作成
    stationLayer = new (ol.layer.Vector)(
      source: markerSource
      style: markerStyleDefault)
    # vector layer の追加
    map.addLayer stationLayer
    stationLayers[item_data.id] = stationLayer
    return

  # $('.ol_station_delete').click ->
  $(document).on 'click', '.ol_station_delete', ->
    $.each stationLayers, (id,stationLayer) ->
      map.removeLayer stationLayer
    stationLayers = {}

# $('p').on 'click', ->
#   hogehoge
#   return
# $(document).on 'click', 'p', ->
#   hogehoge
#   return
  # $('.ol_station').click ->
  $(document).on 'click', '.ol_station', ->
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
    return
