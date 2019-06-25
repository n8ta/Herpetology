class UserTaxonDatum < ApplicationRecord
  belongs_to :taxon
  belongs_to :user

  def correct
    return (self.sci_correct + self.common_correct)/2
  end

  def seen
    self.sci_correct
  end

  def sci_guess_correct
    self.sci_correct += 1
    self.sci_seen += 1
    self.save
  end
  def sci_guess_incorrect
    self.sci_seen += 1
    self.save
  end

  def common_guess_correct
    self.common_correct += 1
    self.common_seen += 1
    self.save
  end
  def common_guess_incorrect
    self.common_seen += 1
    self.save
  end
end
