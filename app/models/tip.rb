class Tip < ApplicationRecord
  belongs_to :user, {optional: :true}
  belongs_to :taxon

  scope :pending, -> { where(handled: false) }

  def to_hash
    return { taxon: taxon.to_hash, content: content, approved: approved}
  end
end
