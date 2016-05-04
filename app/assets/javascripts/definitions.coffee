# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  if $('textarea').length > 0
    CodeMirror.fromTextArea(
      $('textarea').get(0),
      {
        lineNumbers: true,
        lineWrapping: true,
        viewportMargin: Infinity,
        tabSize: 16,
      }
    )
