# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  dispatcher = new WebSocketRails("localhost:3000/websocket")
  dispatcher.trigger "users.index", {},
    ((users) ->
      $.each users, (index, user) ->
        $("#users").append """
          <tr>
            <td user_id=#{user._id}>
              #{user.name}
              <a href='battles/create?opponent_id=#{user._id}'>
                Battle
              </a>
            </td>
          </tr>
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
      <tr>
        <td user_id=#{user._id}>
          #{user.name}
          <a href='battles/create?opponent_id=#{user._id}'>
            Battle
          </a>
        </td>
      </tr>
      """
    return

  battle_channel = dispatcher.subscribe('battles')
  dispatcher.bind 'battle.joined', (battle) ->
    window.location.href = '/battles/' + battle._id
    return
  return
