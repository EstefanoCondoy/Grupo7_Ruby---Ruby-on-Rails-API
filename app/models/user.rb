class User < ApplicationRecord
  has_secure_password

  has_many :receipts, dependent: :destroy

  # Validaciones
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name,  presence: true, length: { maximum: 50 }
  validates :email,      presence: true,
                         uniqueness: { case_sensitive: false },
                         format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password,   length: { minimum: 6 },
                         if: :password_required?

  # Normalizar email antes de guardar
  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def password_required?
    new_record? || password.present?
  end
end
