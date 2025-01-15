class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :signature

  enum role: { regular: 0, head: 1, manager: 2, admin: 3 }
  # enum department: { operation: 0, accounting: 1, purchasing: 2, sales: 3, warehouse: 4 }
  enum :department, [ :operation, :accounting, :purchasing, :sales, :warehouse ]

  belongs_to :employee, optional: true
  
  has_many :quotations
  has_many :canvasses
  has_many :request_forms
  has_many :purchase_orders
  has_many :projects

  after_initialize :set_default_role, if: :new_record?
  before_validation :format_mobile_number

  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :mobile_number, presence: true,
                          format: { 
                            with: /\A09\d{9}\z|\A09\d{2}\s\d{3}\s\d{4}\z/,
                            message: "must be valid (e.g., 09123456789 or 0912 345 6789)" 
                          }
  validate :email_must_be_whitelisted, on: :create
  validates :department, presence: true, on: :create
  validate :acceptable_signature, on: :update
  def promote!
    case role
    when 'regular'
      head!
    when 'head'
      manager!
    when 'manager'
      admin!
    end
  end

  def demote!
    case role
    when 'admin'
      manager!
    when 'manager'
      head!
    when 'head'
      regular!
    end
  end

  def acceptable_signature
    return unless signature.attached?

    errors.add(:signature, 'is too big') unless signature.byte_size <= 1.megabyte

    return if ['image/jpeg', 'image/png'].include?(signature.content_type)

    errors.add(:signature, 'must be a JPEG or PNG')
  end

  def full_name
    "#{first_name.titleize} #{last_name.titleize}"
  end

  private

  def set_default_role
    self.role ||= :regular
  end

  def format_mobile_number
    self.mobile_number = mobile_number.gsub(/\s+/, '') if mobile_number.present?
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
