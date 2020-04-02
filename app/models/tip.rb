class Tip < ApplicationRecord
  belongs_to :user
  belongs_to :taxon

  def to_hash
    return { taxon_id: taxon.id, sci_name: taxon.name, common_name: taxon.common_name }
  end

end
