class Report < ApplicationRecord

  belongs_to :taxon, optional: true # Suggested taxon by reporter
  belongs_to :photo

  belongs_to :handled_by, class_name: 'User', foreign_key: 'handled_by', optional: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by', optional: true

  scope :pending, -> { where(handled: false) }

end
