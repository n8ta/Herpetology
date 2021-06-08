class NoHerpReport < Report
  belongs_to :photo
  belongs_to :user
  def approve(approver)
    photo = self.photo
    photo.hidden = true
    photo.save!
    super(approver)
  end
end
