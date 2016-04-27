# == Schema Information
#
# Table name: staff
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  email                  :string(255)
#  phone                  :string(30)
#  created_at             :datetime
#  updated_at             :datetime
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  role                   :integer          default(0)
#  deleted_at             :datetime
#
# Indexes
#
#  index_staff_on_deleted_at            (deleted_at)
#  index_staff_on_email                 (email) UNIQUE
#  index_staff_on_reset_password_token  (reset_password_token) UNIQUE
#

class Staff < ActiveRecord::Base
  include PgSearch

  self.table_name = :staff

  acts_as_paranoid
  acts_as_taggable

  has_many :alerts, as: :alertable
  has_many :authentications
  has_many :memberships, through: :groups
  has_many :notifications
  has_many :projects, through: :memberships
  has_many :roles, -> { uniq }, through: :memberships
  has_many :api_tokens

  has_many :groups_staff
  has_many :groups, through: :groups_staff, dependent: :destroy

  validates :phone, length: { maximum: 30 }, allow_blank: true, format: { with: /\A\+?[0-9\-]+\*?\z/ }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :registerable
  # Enabling others may require migrations to be made and run
  devise :database_authenticatable, :trackable, :validatable

  enum role: { user: 0, admin: 1, manager: 2 }

  attr_accessor :api_token

  pg_search_scope :search, against: [:first_name, :last_name, :email], using: { tsearch: { prefix: true } }

  def latest_alerts
    alerts.latest
  end

  def self.find_by_auth(auth_hash)
    auth_match = Authentications.find_by(provider: auth_hash['provider'], uid: auth_hash['uid'].to_s)

    staff = if auth_match
              Staff.find(auth_match.staff_id)
            else
              Staff.find_by!(email: auth_hash['info']['email'])
            end

    if staff
      Authentications.create staff_id: staff.id, provider: auth_hash['provider'], uid: auth_hash['uid'].to_s
    end

    staff
  end
end
