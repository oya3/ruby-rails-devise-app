$ ->
  $('.table-sortable-nested-form').sortable
    axis: 'y',
    items: '.nested-item',
    update: (e, ui) ->
      # ドラッグ&ドロップしたら各entryのhidden_fieldに現在の位置を入れる
      $('.position').each ->
        $(this).val( $('.position').index( $(this) )  )
        # $(this).val(0)
