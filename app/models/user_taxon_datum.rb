class UserTaxonDatum < ApplicationRecord
  belongs_to :taxon
  belongs_to :user
  def guess_correct
    self.correct += 1
    self.seen += 1
    self.save
  end
  def guess_incorrect
    self.seen += 1
    self.save
  end
end
