# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  # anchor links
  hash = window.location.hash
  hash && $('ul.nav a[href="' + hash + '"]').tab('show')
  setTimeout(
   ->
     $(window).scrollTop(0)
   8
  )

  # bootstrap tabs
  $('.nav-tabs a').click (e) ->
    $(this).tab('show')
    window.location.hash = this.hash
    setTimeout(
     ->
       $(window).scrollTop(0)
     8
    )

  # CodeMirror
  $('textarea.properties-editor').each ->
    CodeMirror.fromTextArea(
      $(this).get(0),
      {
        lineNumbers: true,
        lineWrapping: false,
        viewportMargin: Infinity,
        tabSize: 32,
        indentUnit: 32,
        indentWithTabs: true,
      }
    )
  $('textarea.article-editor').each ->
    CodeMirror.fromTextArea(
      $(this).get(0),
      {
        lineNumbers: true,
        lineWrapping: true,
        viewportMargin: Infinity,
      }
    )

  # bootstrap tooltips
  $('[data-toggle="tooltip"]').tooltip()
