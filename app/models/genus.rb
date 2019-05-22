class Genus < ApplicationRecord
  belongs_to :family
  has_many :species

  validates :family, presence: true
  validates :name, presence: true

end
