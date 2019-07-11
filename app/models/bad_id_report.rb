class BadIdReport < Report
  belongs_to :created_by, class_name: 'User', inverse_of: :created_reports, optional: true
  belongs_to :handled_by, class_name: 'User', inverse_of: :handled_reports, optional: true
  belongs_to :photo
  belongs_to :taxon

  def approve(approver)
    photo = self.photo
    photo.taxon = self.taxon
    photo.save!
    super(approver)
  end

end
