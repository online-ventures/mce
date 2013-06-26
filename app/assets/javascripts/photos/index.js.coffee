if $('body').hasClass('index photos')
  $form = $('#new_photo')
  $text = $form.find('span#upload-text')
  $file = $('#photo_image')
  $modal = $('#view-image-modal')
  $image = $('#view-image-modal-image')
  $delete = $modal.find('a.delete')
  $featured = $modal.find('a.featured')
  $reactivate = $modal.find('a.reactivate')
  $object = 'Photo'

  $file.change ->
    if $(this).val().match(/\.zip$/)
      $object = 'Zip'
    else
      $object = 'Photo'
    $text.html('Upload '+$object)


  $('.existing-photos a').click ->
    if $(this).hasClass('featured')
      $featured.addClass('is_featured').html('✔ Featured')
    else
      $featured.removeClass('is_featured').html('✔ Make Featured')
    if $(this).attr('data-active') == 'false'
      $reactivate.removeClass('is_featured').html('✔ Reactivate Photo')
    $image.attr('src', $(this).attr('data-big-url'))
    $featured.attr('href', $(this).attr('data-path')+'?featured=true')
    $delete.attr('href', $(this).attr('data-path'))
    $reactivate.attr('href', $(this).attr('data-path')+'?activate=true')

  $featured_div = $('.existing-photos div.photo.featured').detach()
  $('.existing-photos').prepend($featured_div)

  $form.find('input[type=submit]').click ->
    if $file.val() == ''
      return false
    $text.html('Uploading '+$object+ (' (This might take a while.)' if $object == 'Zip'))
    $text.parent('div.button').animate({
      backgroundColor: '#aaa'
      borderColor: '#888'
    }, 1)