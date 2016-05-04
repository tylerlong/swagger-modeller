# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


# enable tab insertion in <textarea>
$ ->
  $("textarea").keydown (e) ->
    if e.keyCode == 9
      start = this.selectionStart
      end = this.selectionEnd
      $this = $(this)
      $this.val($this.val().substring(0, start) + "\t" + $this.val().substring(end))
      this.selectionStart = this.selectionEnd = start + 1
      return false
