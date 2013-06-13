toggle = 768
previous = 'large'

$.extend $.fn.grow_text = ->
  this.each ->
    $(this).attr('large-text', $(this).html())
    $(this).html($(this).attr('small-text'))
    $(this).removeAttr('small-text')

$.extend $.fn.shrink_text = ->
  this.each ->
    $(this).attr('small-text', $(this).html())
    $(this).html($(this).attr('large-text'))
    $(this).removeAttr('large-text')
$html = $('html')
unless $html.hasClass('ie8') || $html.hasClass('ie7') || $html.hasClass('ie6')
  $(window).resize ->
    width = $(document).width()
    if(previous is 'large')
      if(width <= toggle)
        previous = 'small'
        $('[small-text]').grow_text()
      else
        $('[small-text]').each ->
          if($(this).height() > ($(this).css('line-height').substring(0,2) * 1))
            $(this).grow_text()
    else if(previous is 'small' and width > toggle)
      previous = 'large'
      $('[large-text]').shrink_text()

  $(window).resize();