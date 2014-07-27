class Battle
  include Mongoid::Document
  field :active, type: Boolean, default: true
  has_and_belongs_to_many :users
  has_many :turns, dependent: :destroy

  def send_action action
    turns.find_or_create_by(active: true).actions.create(
      action.attributes.except('_id', '_type')
    )
  end

  def last_action_for user
    return nil unless turns.last
    turns.last.actions.where(user: user).first
  end
end
