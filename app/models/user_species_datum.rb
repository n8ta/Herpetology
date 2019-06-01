class UserSpeciesDatum < ApplicationRecord
  belongs_to :species
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
