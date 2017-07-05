$ ->
  $('.railway_test').click ->
    # $train_route_station_id = $(this).data().trainRouteStationId
    item_data = $(this).data()
    # params = item_data
    # params[item_data.modelName] = { row_order_position: 99 }
    $.ajax
      type: 'GET'
      url: item_data.getUrl
      dataType: 'json'
      # data: params
      success: (json) ->
        console.log(json)
        # 参考：jsonデータにアクセス方法
        # json.created_at
        # json.railsections[0]
        # json.railsections[0].railways[0]
        # json.railsections[0].railways[0].points[0]
        # json.railsections.length
        return

