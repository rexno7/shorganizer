# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#$(document).ready ->
#  $(".submittable").click ->
#    $(this).parents("form:first").submit()
#    return

#$(document).ready ->
#  $(".toggle").click ->
#    $(this).text("Watched")

#$(document).on "page:change", ->
#  $(".toggle").click ->
#    $(this).toggleClass "watched"
#    text = $(this).text()
#    $(this).text (if text is "Watched" then "Not Watched" else "Watched")
#  return
#return

# Function: checkAll
# Description: Used for checking all the checkboxes to 'watched'
window.checkAll = (bx) ->
  cbs = document.getElementsByClassName("watched")
  i = 0
  while i < cbs.length
    cbs[i].checked = bx.checked  if cbs[i].type is "checkbox"
    i++
  return