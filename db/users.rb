# Create employees

[
  { department: :operation, position: "Operation Officer", email: "operation@goldenchain.com.ph" },
  { department: :accounting, position: "Auditor", email: "accounting@goldenchain.com.ph" },
  { department: :purchasing, position: "Purchasing Officer", email: "purchasing@goldenchain.com.ph" },
  { department: :sales, position: "Sales Officer", email: "sales@goldenchain.com.ph" },
  { department: :warehouse, position: "Warehouse Officer", email: "warehouse@goldenchain.com.ph" },
  { department: :operation, position: "General Manager", email: "manager@goldenchain.com.ph" }
].each do |employee_data|
  Employee.create!(employee_data)
end

# Create users

Employee.all.each do |employee|
  User.create!(
    first_name: "Mr.",
    last_name: employee.position,
    email: employee.email,
    mobile_number: "09123456789",
    password: "123123",
    password_confirmation: "123123",
  )
end

manager = User.find_by(email: "manager@goldenchain.com.ph")
manager.manager!

purchasing = User.find_by(email: "purchasing@goldenchain.com.ph")

# Attach signature to manager
manager.signature.attach(io: File.open(Rails.root.join("app/assets/images/sign-one.png")), filename: "sign-one.png", content_type: "image/png")
purchasing.signature.attach(io: File.open(Rails.root.join("app/assets/images/sign-two.png")), filename: "sign-two.png", content_type: "image/png")
