class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true
  validates :encrypted_password, presence: true

  has_many :user_taxon_data, dependent: :delete_all

  enum user_class: ["user","contributor","admin"]

  def place_on_scoreboard
    User.all.sort {|a, b| b.total_correct <=> a.total_correct}.find_index(self) + 1
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
    total_sci / (total_seen == 0 ? 1.0 : total_seen)
  end
  def accuracy_common
    total_com / (total_seen == 0 ? 1.0 : total_seen)
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
