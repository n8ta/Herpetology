class Tip < ApplicationRecord
  belongs_to :user
  belongs_to :taxon

  def to_hash
    return { taxon: taxon.to_hash, content: content, approved: approved}
  end
end
