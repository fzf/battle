class Action
  include Mongoid::Document
  field :name,     type: String
  field :damage,   type: Integer
  field :piercing, type: Integer
  field :defense,  type: Integer
  embedded_in :user
end
