class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :signature, dependent: :destroy

  enum :role, [ :regular, :head, :manager, :admin, :developer ]
  enum :department, [ :operation, :accounting, :purchasing, :sales, :warehouse, :information_technology ]

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
  validates :position, presence: true, on: :create
  scope :search_by_term, ->(query) {
    return all unless query.present?
    
    query = query.downcase
    department_matches = departments.keys.select { |k| k.include?(query) }
    role_matches = roles.keys.select { |k| k.include?(query) }

    where(
      "LOWER(first_name) ILIKE :query OR 
       LOWER(last_name) ILIKE :query OR 
       LOWER(email) ILIKE :query OR 
       department IN (:department_values) OR 
       role IN (:role_values)", 
      query: "%#{query}%",
      department_values: department_matches.map { |k| departments[k] },
      role_values: role_matches.map { |k| roles[k] }
    ).where.not(department: nil)
  }

  scope :created_on_date, ->(date) {
    return all unless date.present?
    where("DATE(created_at) = ?", Date.parse(date))
  }

  def promote!
    case role
    when 'regular'
      head!
    end
  end

  def demote!
    case role
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
    if email == "dev@goldenchain.ph"
      self.department = :information_technology
      self.position = "Developer"
    else
      employee = Employee.find_by(email: email)
      if employee.nil?
        errors.add(:email, "is not authorized to register")
      else
        self.department = employee.department
        self.position = employee.position
      end
    end
  end
end
