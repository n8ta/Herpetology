class Superfamily < ApplicationRecord
  has_many :families
  validates :name, presence: true
  def name=(s)
    write_attribute(:name, s.to_s.titleize) # The to_s is in case you get nil/non-string
  end
end
