$ ->
  # 駅名、次駅リスト更新
  $('.train-route-select').chosen
    #disable_search_threshold: 2
    allow_single_deselect: true
    # enable_split_word_search: false
    # no_results_text: 'No results matched'
    # width: '200px'

  $('.train-route-select').on 'change', (evt, params) ->
    # 以下のＵＲＬでtrain_route_stationsがもらえるはず
    # http://localhost:3000/train_routes/1/get_route_station
    # /train_routes/1/get_route_station
    # value = $('.train-route-select').val();
    # text  = $('.train-route-select option:selected').text()
    ajax_update_train_route(params["selected"])
    console.log 'select1112 change'
    return

  ajax_update_train_route = (train_route_id) ->
    $.ajax
      type: 'GET'
      url: "/train_routes/" + train_route_id + "/get_route_station"
      dataType: 'json'
      # data: params
      success: (json) ->
        update_train_route( json )
        return

  update_train_route = (json) ->
    # json.railsections[0].railways[0].points[0]
    # json.railsections.length
    $('#train_route_stations').find('tr:gt(0)').remove() # リスト全削除
    i = 0
    trs = json["train_route_stations"]
    btrs = json["between_train_route_stations"]
    len = trs.length
    while i < len
      ts = trs[i] #["station"]["name"]
      if i == len - 1
        # 最終行
        $('#train_route_stations').append getRowData(trs[i],null)
        td0 = $('#train_route_stations tr:last td')[0]
        $(td0).attr('class','ol_station')
        $(td0).attr('data-get-url','/train_route_stations/' + trs[i]["id"] + '/get_railway')
        $(td0).attr('data-id', trs[i]["id"])
        $(td0).attr('data-model-name', 'train_route_station')
        # tr = $('#train_route_stations.tr:last')
      else
        # その他
        $('#train_route_stations').append getRowData(trs[i],trs[i+1])
        td0 = $('#train_route_stations tr:last td')[0]
        $(td0).attr('class','ol_station')
        $(td0).attr('data-get-url','/train_route_stations/' + trs[i]["id"] + '/get_railway')
        $(td0).attr('data-id', trs[i]["id"])
        $(td0).attr('data-model-name', 'train_route_station')

        # class="ol_railway"
        # data-get-url="/between_train_route_stations/1/get_railway"
        # data-id="1"
        # data-model-name="between_train_route_station"
        # data-color="rgba(208,32,32,0.5)"
        td1 = $('#train_route_stations tr:last td')[1]
        $(td1).attr('class','ol_railway')
        $(td1).attr('data-get-url','/between_train_route_stations/' + btrs[i]["id"] + '/get_railway')
        $(td1).attr('data-id', btrs[i]["id"])
        $(td1).attr('data-model-name', 'between_train_route_station')
        $(td1).attr('data-color', 'rgba(208,32,32,0.5)')
        # tr = $('#train_route_stations.tr:last')
      ++i
    return

  getRowData = (ts,ns)->
    # '.ol_station'
    # class="ol_station"
    # data-get-url="/train_route_stations/1/get_railway"
    # data-id="1" data-model-name="train_route_station"

    # class="ol_railway"
    # data-get-url="/between_train_route_stations/1/get_railway"
    # data-id="1"
    # data-model-name="between_train_route_station"
    # attr = "class=ol_station data-get-url='/train_route_stations/" + ts["station"]["code"] + "/get_railway' data-id='" + ts["station"]["code"] + "' data-model-name='train_route_station'"
    # attr = 'class=ol_station data-get-url=\'/train_route_stations/' + ts['id'] + '/get_railway\' data-id=\'' + ts['id'] + '\' data-model-name=\'train_route_station\''
    if ns
      return '<tr><td>' + ts["station"]["name"] + '</td><td>' + ns["station"]["name"] + '</td></tr>'
    else
      return '<tr><td>' + ts["station"]["name"] + '</td><td>' + "-" + '</td></tr>'
    return


    # data-get-url="/train_route_stations/1/get_railway"
    # data-id="1"
    # data-model-name="train_route_station"　
