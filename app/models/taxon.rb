class Taxon < ApplicationRecord
  belongs_to :taxon, optional: true
  has_many :taxons
  has_many :common_names
  has_many :photos
  enum rank: [:root,:family,:genus,:species]

  scope :species, -> { where(rank: :species) }
  scope :genera, -> { where(rank: :genus) }
  scope :families, -> { where(rank: :family) }
  scope :roots, -> { where(rank: :root) }

  before_create :title

  def title
    self.name = self.name.titleize
  end

end
