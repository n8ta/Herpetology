class Family < ApplicationRecord
  has_many :genera
  belongs_to :superfamily
  validates :name, presence: true
end
