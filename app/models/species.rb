class Species < ApplicationRecord

  belongs_to :genus
  has_many :photos
  has_many :common_names
  has_and_belongs_to_many :user_species_data
  has_and_belongs_to_many :tier3s
  has_and_belongs_to_many :tier2s
  has_and_belongs_to_many :tier1s

  validates :genus, presence: true
  validates :name, presence: true,  uniqueness: {scope: :genus}

  def name=(s)
    write_attribute(:name, s.to_s.titleize) # The to_s is in case you get nil/non-string
  end

  def sci_name
    self.genus.name + ' ' + self.name
  end

end
