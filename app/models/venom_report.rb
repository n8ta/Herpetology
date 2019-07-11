class VenomReport < Report
  belongs_to :taxon

  validates :venomous, presence: true
  enum venomous: ["venomous", "nonvenomous", "unknown"]

  def approve(approver)
    taxon = self.taxon
    case self.venomous
    when "venomous"
      taxon.venomous = true
    when "nonvenomous"
      taxon.venomous = false
    when "unknown"
      taxon.venomous = nil
    end
    taxon.save!
    super(approver)
  end
end
