class Battle
  include Mongoid::Document
  field :active, type: Boolean, default: true
  has_and_belongs_to_many :users
end
