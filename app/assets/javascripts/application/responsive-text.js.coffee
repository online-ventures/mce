toggle = 768
previous = 'large'

$(window).resize ->
  width = $(document).width()
  console.log(width)
  console.log(previous)
  if(previous is 'large' and width <= toggle)
    previous = 'small'
    $('[small-text]').each ->
      $(this).attr('large-text', $(this).html())
      $(this).html($(this).attr('small-text'))
      $(this).attr('small-text', '')
  else if(previous is 'small' and width > toggle)
    previous = 'large'
    $('[large-text]').each ->
      $(this).attr('small-text', $(this).html())
      $(this).html($(this).attr('large-text'))
      $(this).attr('large-text', '')
$(window).resize();