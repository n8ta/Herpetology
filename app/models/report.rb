class Report < ApplicationRecord

  belongs_to :taxon, optional: true # Suggested taxon by reporter
  belongs_to :photo

  belongs_to :created_by, class_name: 'User', inverse_of: :created_reports, optional: true
  belongs_to :handled_by, class_name: 'User', inverse_of: :handled_reports, optional: true

  scope :pending, -> { where(handled: false) }

end
