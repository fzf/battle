# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  dispatcher = new WebSocketRails(window.location.origin.replace('http://', '') + "/websocket")
  dispatcher.trigger "users.index", {},
    ((users) ->
      $.each users, (index, user) ->
        $("#users").append """
          <li user_id=#{user._id} class='table-view-cell'>
            <a href='users/#{user._id}' class='navigate-right'>
              #{user.name}
            </a>
          </td>
        """
        return
    ),
    ((users) ->
      console.log users.name
    )

  user_channel = dispatcher.subscribe('users')
  user_channel.bind 'disconnected', (user) ->
    $("td[user_id='#{user._id}']").remove()
    return
  user_channel.bind "available", (user) ->
    $("#users").append """
      <li user_id=#{user._id} class='table-view-cell'>
        <a href='users/#{user._id}' class='navigate-right'>
          #{user.name}
        </a>
      </td>
    """
    return

  battle_channel = dispatcher.subscribe('battles')
  dispatcher.bind 'battle.joined', (battle) ->
    window.location.href = '/battles/' + battle._id
    return

  turn_channel = dispatcher.subscribe('turns')
  dispatcher.bind 'turn.calculated', ->
    window.location.reload()
    return

  # Instance
  snapper = new Snap(element: document.getElementById('content'))
  $("#menu").click ->
    if snapper.state().state is "left"
      snapper.close()
      $('.left-drawer').hide()
    else
      $('.left-drawer').show()
      snapper.open "left"
    return

  #
  # UpdateDrawers = ->
  #   state = snapper.state()
  #   towards = state.info.towards
  #   opening = state.info.opening
  #   if opening is "right" and towards is "left"
  #     $("right-drawer").classList.add "active-drawer"
  #     $("left-drawer").classList.remove "active-drawer"
  #   else if opening is "left" and towards is "right"
  #     $("right-drawer").classList.remove "active-drawer"
  #     $("left-drawer").classList.add "active-drawer"
  #   return


  # snapper.on "drag", UpdateDrawers
  # snapper.on "animating", UpdateDrawers
  # snapper.on "animated", UpdateDrawers

  return
