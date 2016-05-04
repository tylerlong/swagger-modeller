# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


# anchor links and bootstrap tabs
$ ->
  hash = window.location.hash
  hash && $('ul.nav a[href="' + hash + '"]').tab('show')
  setTimeout(
   ->
     $(window).scrollTop(0)
   8
  )

  $('.nav-tabs a').click (e) ->
    $(this).tab('show')
    window.location.hash = this.hash
    setTimeout(
     ->
       $(window).scrollTop(0)
     8
    )
