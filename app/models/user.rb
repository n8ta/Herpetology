class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true
  validates :encrypted_password, presence: true

  has_and_belongs_to_many :user_taxon_data

  enum type: ["user","contributor","admin"]

  def admin?
    type == "admin"
  end
  def contributor?
    type == "contributor"
  end
  def admin_or_contributor?
    admin? or contributor?
  end
end
