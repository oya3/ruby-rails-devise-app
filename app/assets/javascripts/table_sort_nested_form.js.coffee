$ ->
  $('.table-sortable-nested-form').sortable
    axis: 'y',
    items: '.nested-item',
    update: (e, ui) ->
      # ドラッグ&ドロップしたら各entryのhidden_fieldに現在の位置を入れる
      values =  $(e.target).closest(".table-sortable-nested-form").data().values
      order = 0
      $('.nested-item').each ->
        terget = $(this).find('.form-control')
        len = terget.size()
        terget.each ->
          if $(this).val() == ''
            len -= 1
          return
        
        if len != 0
          $(this).find('.position').val( order )
          order++
        
        return

      # .positon 属性の入力フィールドを０始まりで埋める
      # $('.position').each ->
      #   $(this).val( $('.position').index( $(this) )  )
      #   # $(this).val(0)
