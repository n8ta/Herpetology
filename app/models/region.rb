class Region < ApplicationRecord
  belongs_to :region, optional: true
  has_many :regions
  has_many :taxons


  has_and_belongs_to_many :taxons
  validate :not_own_parent
  before_create :extra_spaces

  def extra_spaces
    return if self.name == "" or self.name.nil?
    self.name = self.name.split(' ').join(' ')
  end

  scope :countries, -> {where(region: nil)}

  def not_own_parent
    regions = []
    current = self
    while current != nil
      if regions.include?(current)
        errors.add(:region, 'Loop detected with this regions parent')
      end
      regions << current
      current = current.region
    end
  end

  def subregions_with_6(taxon)
    self.regions.select {|t2| t2.taxons.species.where(root_taxon_id: taxon.id).select {|sp| sp.photos.any?}.count > 5}
  end
end
