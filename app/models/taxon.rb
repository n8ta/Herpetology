class Taxon < ApplicationRecord
  belongs_to :taxon, optional: true
  belongs_to :taxon, class_name: 'Taxon', :foreign_key => :root_taxon_id, optional: true

  has_and_belongs_to_many :regions

  has_many :taxons
  has_many :common_names
  has_many :photos
  enum rank: [:root,:family,:subfamily,:genus,:species]

  scope :species, -> { where(rank: :species) }
  scope :genera, -> { where(rank: :genus) }
  scope :families, -> { where(rank: :family) }
  scope :subfamilies, -> { where(rank: :subfamilies) }
  scope :roots, -> { where(rank: :root) }

  def num_photos
    self.photos.count
  end

  before_create :title

  def root
    taxon.nil? ? self : self.taxon.root
  end

  def title
    self.name = self.name.titleize
  end

end
