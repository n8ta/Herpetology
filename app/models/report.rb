class Report < ApplicationRecord

  belongs_to :taxon, class_name: 'Taxon', foreign_key: 'taxon_id'
  belongs_to :suggested_taxon, class_name: 'Taxon', foreign_key: 'suggested_taxon', optional: true

  belongs_to :photo

  belongs_to :handled_by, class_name: 'User', foreign_key: 'handled_by', optional: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by', optional: true
end
