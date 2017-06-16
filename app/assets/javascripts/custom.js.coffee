$ ->
  toggleAddLink = ($nested_logs)->
    # count = $nested_logs.find('.fields').length
    count = $nested_logs.find('.fields:visible').length
    $link = $nested_logs.find('a.add_nested_fields')
    count_max = $nested_logs.data().max
    $link.toggle count < count_max
    return
  $(document).on 'nested:fieldAdded nested:fieldRemoved', (event)->
    $temp = $(event.target)
    $nested_logs = $temp.closest(".nested_logs") 
    toggleAddLink($nested_logs)
    return
  $(document).find('.nested_logs').each ->
    toggleAddLink($(@))
  return

# nprogress-rails 利用時のプログレスバー設定
# NProgress.configure
#   showSpinner: false
#   ease: 'ease'
#   speed: 500

