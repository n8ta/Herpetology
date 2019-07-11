class VenomReport < Report
  belongs_to :taxon
  belongs_to :created_by, class_name: 'User', inverse_of: :created_reports, optional: true
  belongs_to :handled_by, class_name: 'User', inverse_of: :handled_reports, optional: true

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
