class BadRegionReport < Report
  belongs_to :taxon
  belongs_to :region

  def approve(approver)
    self.region.remove_taxon(self.taxon)
    super(approver)
  end
end
