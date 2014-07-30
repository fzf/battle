class Turn::Action < Action
  field :damage_dealt
  belongs_to :turn
  belongs_to :user

  after_create :calculate_turn

  validates :turn_id, uniqueness: { scope: :user_id }
private

  def calculate_turn
    turn.calculate
  end
end
