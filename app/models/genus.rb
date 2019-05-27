class Genus < ApplicationRecord
  belongs_to :family
  has_many :species

  validates :family, presence: true
  validates :name, presence: true,  uniqueness: {scope: :family}


  def name=(s)
    write_attribute(:name, s.to_s.titleize) # The to_s is in case you get nil/non-string
  end
end
