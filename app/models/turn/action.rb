class Turn::Action < Action
  belongs_to :turn
  belongs_to :user

  after_create :calculate_turn
private
  def calculate_turn

    turn.calculate
  end
end
