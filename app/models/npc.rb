class Npc
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  has_many :battles
  field :hit_points,         type: Integer, default: 20
  field :current_hit_points, type: Integer, default: 20
  field :name,               type: String, default: "NPC"

  has_many :actions, class_name: 'Npc::Action'
  accepts_nested_attributes_for :actions

  has_many :turn_actions, class_name: 'Turn::Action'
  after_create :make_default_actions

private
  def make_default_actions
    actions.create(name: 'Attack', damage: 6, piercing: 0, defense: 0)
    actions.create(name: 'Jab',    damage: 0, piercing: 3, defense: 0)
    actions.create(name: 'Defend', damage: 0, piercing: 0, defense: 6)
  end
end
