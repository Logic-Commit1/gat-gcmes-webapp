class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { user: 0, moderator: 1, admin: 2 }
  # enum department: { operation: 0, accounting: 1, purchasing: 2, sales: 3, warehouse: 4 }
  enum :department, [ :operation, :accounting, :purchasing, :sales, :warehouse ]


  belongs_to :employee, optional: true
  
  after_initialize :set_default_role, if: :new_record?

  validates :email, presence: true
  validate :email_must_be_whitelisted
  validates :department, presence: true
  
  private

  def set_default_role
    self.role ||= :user
  end

  def email_must_be_whitelisted
    employee = Employee.find_by(email: email)
    if employee.nil?
      errors.add(:email, "is not authorized to register")
    else
      self.department = employee.department
    end
  end
end
