class NoHerpReport < Report
  belongs_to :photo

  def approve(approver)
    photo = self.photo
    photo.hidden = true
    photo.save!
    super(approver)
  end
end
