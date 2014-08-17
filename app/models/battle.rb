class Battle
  include Mongoid::Document
  field :active, type: Boolean, default: true
  has_and_belongs_to_many :users
  has_many :turns, dependent: :destroy
  belongs_to :npc

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

  def last_action_for user
    return nil unless turns.last
    turns.last.actions.where(user: user).first
  end
end
