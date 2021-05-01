class Taxon < ApplicationRecord

  mount_uploader :photo, TaxonPhotoUploader

  belongs_to :taxon, optional: true
  belongs_to :taxon, class_name: 'Taxon', :foreign_key => :root_taxon_id, optional: true

  has_and_belongs_to_many :groups
  has_and_belongs_to_many :regions # Regions the taxon has been seen on herpmapper

  has_many :taxons
  has_many :common_names
  has_many :photos
  has_many :tips
  has_many :bad_region_reports
  has_many :bad_id_reports

  # Only used on root taxon, these are the regions for a root taxon where there are at least 5 species with photos
  has_and_belongs_to_many :valid_regions, join_table: 'regions_root_taxons', class_name: 'Region'

  enum rank: [:root, :family, :subfamily, :genus, :species]

  scope :species, -> { where(rank: :species) }
  scope :genera, -> { where(rank: :genus) }
  scope :families, -> { where(rank: :family) }
  scope :subfamilies, -> { where(rank: :subfamilies) }
  scope :roots, -> { where(rank: :root) }

  def num_photos
    self.photos.size
  end

  def get_root_txn_rank
    # for root taxons return their proper rank (not root) since we dont' have the entire tree
    if common_name == "Snakes"
      return "Suborder"
    elsif common_name == "Lizards"
      return "Suborder"
    elsif common_name == "Turtles and Tortoises"
      return "Order"
    elsif common_name == "Salamanders"
      return "Suborder"
    elsif common_name == "Worm Lizards"
      return "Clade"
    elsif common_name == "Limbless Amphibians"
      return "Order"
    elsif common_name == "Alligators, Crocodiles, and Caimans"
      return "Order"
    elsif common_name == "Frogs and Toads"
      return "Order"
    else
      raise("That's not a root taxon id:#{id}!")
    end
  end

  before_create :title
  before_create :only_species_have_venomous_tag

  def only_species_have_venomous_tag
    if venomous != nil && rank != 'species'
      raise 'Only species can be tagged as venemous'
    end
  end

  def root
    taxon.nil? ? self : self.taxon.root
  end

  def to_hash
    return {
        id: id,
        name: name,
        taxon_id: taxon_id,
        rank: rank,
        root_taxon_id: root_taxon_id,
        photographed: photographed,
        venomous: venomous,
        common_name: common_name,
    }
  end

  def title
    self.name = self.name.titleize
  end

  def sci_name
    begin
      split = self.name.split(" ")
      first = split[0].titleize
      second = split[1].downcase
      return first + " " + second
    rescue
      return self.name
    end
  end

end
