class Battle
  include Mongoid::Document
  field :active, type: Boolean, default: true
  has_and_belongs_to_many :users
  has_many :turns

  after_create :create_turn

  def send_action action
    turns.last.actions << Turn::Action.create(
      action.attributes.except('_id', '_type')
    )
  end

private

  def create_turn
    turns.create
  end
end
