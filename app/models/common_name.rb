class CommonName < ApplicationRecord
  belongs_to :species
  validates :name, presence: true
  validates :species_id, presence: true

  def name=(s)
    write_attribute(:name, s.to_s.titleize) # The to_s is in case you get nil/non-string
  end

end
