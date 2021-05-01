class Group < ApplicationRecord
  has_and_belongs_to_many :taxons
  validates :name, presence: true
end
