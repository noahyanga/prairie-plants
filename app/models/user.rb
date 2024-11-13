class User < ApplicationRecord
  belongs_to :address, optional: true
  has_many :orders

  validates :name, presence: true
  validates :password, presence: true, length: {minimum: 5}
  validates :email, presence: true, format {with: URI::MailTo::EMAIL_REGEXP}
  validates :role, presence: true, inclusion: {in: %w[admin customer]}
end
