class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  validates :email, presence: true

  enum user_class: ["user","contributor","admin"]

  def self.from_omniauth(access_token)
    data = access_token.info
    firstname = data[:first_name]
    lastname = data[:last_name]
    email = data[:email]

    user = User.find_by(email: email, google_user: true)
    return user if user

    user = User.create(email: email, google_user: true, username: nil, password: SecureRandom.hex(30)) ## This is hacky as fuck and I'm well aware
    user.save!
    return user
  end

  def approved_reports
    Report.all_reports.select{ |rep| rep.created_by_id == self.id && rep.approved == true }
  end


  # has_many :reports, class_name: 'Report', table_name: 'Reports', foreign_key: "created_by" # Column name on report, there a handled_by user and a created_By user
  has_many :user_taxon_data, dependent: :delete_all



  def place_on_scoreboard
    User.all.sort {|a, b| b.total_correct <=> a.total_correct}.find_index(self) + 1
  end
  def place_on_sci_scoreboard
    User.all.sort {|a, b| b.accuracy_scientific <=> a.accuracy_scientific}.find_index(self) + 1
  end
  def place_on_common_scoreboard
    User.all.sort {|a, b| b.accuracy_common <=> a.accuracy_common}.find_index(self) + 1
  end
  def place_report_scoreboard
    User.all.sort {|a, b| b.approved_reports.size <=> a.approved_reports.size }.find_index(self) + 1
  end

  def admin?
    user_class == "admin"
  end

  def contributor?
    user_class == "contributor"
  end

  def admin_or_contributor?
    admin? or contributor?
  end

  def total_correct
      total_sci + total_com
  end

  def accuracy_scientific
    acc = total_sci / (total_seen == 0 ? 1.0 : total_seen)
    return 0 if (acc == 1 and total_seen < 100)
    return acc
  end
  def accuracy_common
    acc = total_com / (total_seen == 0 ? 1.0 : total_seen)
    return 0 if (acc == 1 and total_seen < 100)
    return acc
  end

  def total_sci
    self.user_taxon_data.sum(:sci_correct).to_f
  end

  def total_com
    self.user_taxon_data.sum(:common_correct).to_f
  end

  def total_seen
    self.user_taxon_data.sum(:sci_seen).to_f
  end

end
