class Turn
  include Mongoid::Document
  belongs_to :battle
  has_many :actions, class_name: 'Turn::Action'

  validates :actions, length: { maximum: 2 }

  def calculate
    return unless actions.count == 2

    calculate_damage(actions.first, actions.last)
    calculate_damage(actions.last, actions.first)
  end

  def calculate_damage(action1, action2)
    total_damage = damage_to(action1, action2) +
                   damage_prevented(action2, action1) +
                   action2.piercing

    action1.user.update_attribute(
      :current_hit_points,
      action1.user.current_hit_points - total_damage
    )
  end

  def damage_to action1, action2
    total_damage =  (action2.damage - action1.defense)
    total_damage > 0 ? total_damage : 0
  end

  def damage_prevented action1, action2
    # TODO Fuck this method
    return 0 if action2.  damage == 0
    defense_difference = action1.defense - action2.damage
    total_defense = (defense_difference <= 0) ? defense_difference : 0

    if total_defense + action1.defense > 0
      total_defense + action1.defense
    else
      0
    end
  end
end
