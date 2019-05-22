class Family < ApplicationRecord
  has_many :genera

  validates :name, presence: true
end
