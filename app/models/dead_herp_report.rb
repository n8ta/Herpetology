class DeadHerpReport < Report
  belongs_to :photo
  def approve(approver)
    photo = self.photo
    photo.dead = true
    photo.save!
    super(approver)
  end
end
