class BadIdReport < Report
  belongs_to :photo
  belongs_to :taxon
  belongs_to :user

  def approve(approver)
    photo = self.photo
    photo.taxon = self.taxon
    photo.save!
    super(approver)
  end

end
