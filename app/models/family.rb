class Family < ApplicationRecord

  has_many :genera
  belongs_to :superfamily

  validates :name, presence: true,  uniqueness: {scope: :superfamily}

  def name=(s)
    write_attribute(:name, s.to_s.titleize) # The to_s is in case you get nil/non-string
  end

end
