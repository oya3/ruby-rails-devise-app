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

  lineLayer = null
  lineLayers = []
  addLine = (json,color) ->
    console.log(json)
    # json.railsections[0].railways[0].points[0]
    # json.railsections.length
    $.each json.railsections, (rsi,railsection) ->
      $.each railsection.railways, (rwi,railway) ->
        lineStrArray = new Array
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
        lineColor = color # '#ff0000'
        # 経路用の vector layer の作成
        lineLayer = new (ol.layer.Vector)(
          source: vectorSource
          style: new (ol.style.Style)(stroke: new (ol.style.Stroke)(
            color: lineColor
            width: 10)))
          # vector layer の追加
        map.addLayer lineLayer
        lineLayers.push(lineLayer)
        return
    return

  $('.railway_delete').click ->
    $.each lineLayers, (lli,lineLayer) ->
      map.removeLayer lineLayer


  $('.railway').click ->
    item_data = $(this).data()
    $.ajax
      type: 'GET'
      url: item_data.getUrl
      dataType: 'json'
      # data: params
      success: (json) ->
        addLine(json,item_data.color)
        return
        
