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
    if window.confirm('A user challenged you to a battle, accept?')
      window.location.href = '/battles/' + battle._id
      return
    return
  dispatcher.bind 'battle.won', ->
    window.confirm('You won!')
    window.location.href = '/users'
    return
  dispatcher.bind 'battle.lost', ->
    window.confirm('You lost')
    window.location.href = '/users'
    return
  dispatcher.bind 'battle.draw', ->
    window.confirm('You drew.')
    window.location.href = '/users'
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

  return
