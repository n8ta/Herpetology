class Report < ApplicationRecord
  self.abstract_class = true

  def self.all_reports
    reports = BadIdReport.all.to_a
    reports.concat(DeadHerpReport.all.to_a)
    reports.concat(NoHerpReport.all.to_a)
    reports.concat(VenomReport.all.to_a)
    reports.concat(BadRegionReport.all.to_a)
  end

  def self.pending
    self.all_reports.select { |r| r.handled == false}
  end


  # All implentations of the abstract class have the following columns
  # - timestamps
  # - handled_by: user
  # - created_by: user
  # - handled: bool

  def approve(approver)
    self.handled_by_id = approver.id
    self.approved = true
    self.handled = true
    self.save!
  end

  def reject(rejecter)
     self.handled_by_id = rejecter.id
     self.approved = false
     self.handled = true
     self.save!
  end

end
