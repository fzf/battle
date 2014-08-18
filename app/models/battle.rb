class Battle
  include Mongoid::Document
  field :active, type: Boolean, default: true
  has_and_belongs_to_many :users, inverse_of: :battles
  has_many :turns, dependent: :destroy
  belongs_to :npc
  belongs_to :winner, class_name: 'User', inverse_of: :wins
  belongs_to :loser, class_name: 'User', inverse_of: :losses

  def send_action action
    last_turn = turns.last

    turn = turns.find_or_create_by(active: true)
    turn.actions.create(
      action.attributes.except('_id', '_type')
    )
    turn.actions.create(
      npc.choose_action_from_last_turn(last_turn).
        attributes.except('_id', '_type')
    ) if npc
  end

  def opponent(user)
    return npc if npc
    (users - [user]).first
  end

  def is_over?
    losers = users.where(:current_hit_points.lte => 0)
    if npc.current_hit_points <= 0 || losers.present?
      if npc.present?
        if npc.current_hit_points <= 0
          if users.first.current_hit_points <= 0
            WebsocketRails.users[users.first._id].send_message 'battle.draw'
          else
            update_attribute(:winner, users.first)
            WebsocketRails.users[users.first._id].send_message 'battle.win'
          end
        else
          update_attribute(:loser, users.first)
          WebsocketRails.users[users.first._id].send_message 'battle.lose'
        end
      else
        if losers.count == 2
          WebsocketRails.users[users.first._id].send_message 'battle.draw'
          WebsocketRails.users[users.last._id].send_message 'battle.draw'
        else
          update_attribute(:loser, losers.first)
          update_attribute(:winner, (users - losers).first)
          WebsocketRails.users[losers.first._id].send_message 'battle.lose'
          WebsocketRails.users[(users - losers).first._id].send_message 'battle.win'
        end
      end
      update_attribute(:active, false)
      return true
    end

    return false
  end

  def last_action_for user
    return nil unless turns.last
    turns.last.actions.where(user: user).first
  end
end
