class Battle
  include Mongoid::Document
  field :active, type: Boolean
  has_and_belongs_to_many :users
end
