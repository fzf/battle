class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  has_and_belongs_to_many :battles
  field :hit_points,         type: Integer, default: 20
  field :current_hit_points, type: Integer, default: 20
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :name,               type: String, default: ""
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  embeds_many :actions

  after_create :make_default_actions

private
  def make_default_actions
    actions.create(name: 'Attack', damage: 6, piercing: 0, defense: 0)
    actions.create(name: 'Jab',    damage: 0, piercing: 3, defense: 0)
    actions.create(name: 'Defend', damage: 0, piercing: 0, defense: 6)
  end
end
