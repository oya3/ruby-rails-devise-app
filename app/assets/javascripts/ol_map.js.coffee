$ ->
  map = new (ol.Map)(
    layers: [ new (ol.layer.Tile)(source: new (ol.source.OSM)) ]
    target: 'ol_map'
    controls: ol.control.defaults(attributionOptions: collapsible: false)
    view: new (ol.View)(
      center: ol.proj.transform([136.0785, 35.2269], 'EPSG:4326', 'EPSG:3857')
      zoom: 10
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
    
