class BadIdReport < Report
  belongs_to :photo
  belongs_to :taxon

  def approve(approver)
    photo = self.photo
    photo.taxon = self.taxon
    photo.save!
    super(approver)
  end

end
