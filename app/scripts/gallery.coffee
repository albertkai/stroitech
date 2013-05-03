$ ->
  $container = $('.gallery-cont')
  $container.imagesLoaded ()->
    $container.find('.image-cont').removeClass('h-invisible')
    $container.masonry
      itemSelector : '.image-cont'
  $container.find('.image-cont').viewer()