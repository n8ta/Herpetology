class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true
  validates :encrypted_password, presence: true

  has_many :user_taxon_data, dependent: :delete_all

  enum user_class: ["user","contributor","admin"]

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
    self.user_taxon_data.sum(:correct)
  end

  def total_seen
    self.user_taxon_data.sum(:seen)
  end

  def ratio
    return 0 if total_seen == 0
    total_correct/total_seen
  end

  def score
    total_correct
  end
end
