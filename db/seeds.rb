Spec.with_deleted.each do |spec|
  spec.really_destroy!
end
Scope.with_deleted.each do |scope|
  scope.really_destroy!
end
Product.with_deleted.each do |product|
  product.really_destroy!
end
Particular.with_deleted.each do |particular|
  particular.really_destroy!
end
RequestForm.with_deleted.each do |request_form|
  request_form.really_destroy!
end
Quotation.with_deleted.each do |quotation|
  quotation.really_destroy!
end
PurchaseOrder.with_deleted.each do |purchase_order|
  purchase_order.really_destroy!
end
Canvass.with_deleted.each do |canvass|
  canvass.really_destroy!
end
Project.with_deleted.each do |project|
  project.really_destroy!
end
Contact.destroy_all
Client.destroy_all
Supplier.destroy_all
Company.destroy_all
Employee.destroy_all
User.where.not(id: User.first&.id).destroy_all

# Create companies
gat = Company.create!(name: "Golden Arrow Trading", code: "GAT", address: "17 San Lorenzo Sc. San Vicente, Maysilo, Malabon City, Philippines, 1477", contact_numbers: ["09123456789"], emails: ["sales@gat.com"])
gcmes = Company.create!(name: "Golden Chain Marine Engineering Services", code: "GCMES", address: "17 San Lorenzo Sc. San Vicente, Maysilo, Malabon City, Philippines, 1477", contact_numbers: ["09123456789"], emails: ["sales@gcmes.com"])

# Create client contacts
client_a_contact = Contact.create(name: "NCSMC Contact", emails: ["sales@ncsmc.com"], contact_numbers: ["09123456789"])
client_b_contact = Contact.create(name: "FSC Contact", emails: ["sales@fsc.com"], contact_numbers: ["09123456789"])
client_c_contact = Contact.create(name: "ASI Contact", emails: ["sales@asi.com"], contact_numbers: ["09123456789"])
client_d_contact = Contact.create(name: "SPAN Contact", emails: ["sales@span.com"], contact_numbers: ["09123456789"])
client_e_contact = Contact.create(name: "LSC Contact", emails: ["sales@lsc.com"], contact_numbers: ["09123456789"])

# Create supplier contacts
supplier_a_contact = Contact.create(name: "NCSMC Contact", emails: ["sales@ncsmc.com"], contact_numbers: ["09123456789"])
supplier_b_contact = Contact.create(name: "FSC Contact", emails: ["sales@fsc.com"], contact_numbers: ["09123456789"])
supplier_c_contact = Contact.create(name: "ASI Contact", emails: ["sales@asi.com"], contact_numbers: ["09123456789"])
supplier_d_contact = Contact.create(name: "SPAN Contact", emails: ["sales@span.com"], contact_numbers: ["09123456789"])
supplier_e_contact = Contact.create(name: "LSC Contact", emails: ["sales@lsc.com"], contact_numbers: ["09123456789"])

# Create clients and associate with companies
# GAT clients
gat.clients.create!(name: "NARRA CREWING AND SHIP MANAGEMENT CORPORATION", code: "NCSMC", address: "3rd Flr. VIP BLDG. 1140 ROXAS BLVD Cor., NUESTRA SRA. DE GULA, Brgt. 667 Zone 072, ERMITA MANILA. MM", contacts: [client_a_contact])
gat.clients.create!(name: "FRABELLE SHIPYARD CORPORATION", code: "FSC", address: "456 Shaw Boulevard, Mandaluyong City, Metro Manila", contacts: [client_b_contact])
gat.clients.create!(name: "ASTRO SHIPMANAGEMENT INC.", code: "ASI", address: "789 Ayala Avenue, Makati City, Metro Manila", contacts: [client_c_contact])

# GCMES clients  
gcmes.clients.create!(name: "PHILIPPINE SPAN ASIA CARRIER CORP.", code: "SPAN", address: "321 EDSA, Pasay City, Metro Manila", contacts: [client_d_contact])
gcmes.clients.create!(name: "LORENZO SHIPPING CORPORATION", code: "LSC", address: "987 Taft Avenue, Manila City, Metro Manila", contacts: [client_e_contact])

# GAT suppliers
gat.suppliers.create!(name: "NARRA CREWING AND SHIP MANAGEMENT CORPORATION", code: "NCSMC", address: "246 Ortigas Avenue, San Juan City, Metro Manila", contacts: [supplier_a_contact])
gat.suppliers.create!(name: "FRABELLE SHIPYARD CORPORATION", code: "FSC", address: "135 C5 Road, Taguig City, Metro Manila", contacts: [supplier_b_contact])
gat.suppliers.create!(name: "ASTRO SHIPMANAGEMENT INC.", code: "ASI", address: "864 Commonwealth Avenue, Quezon City, Metro Manila", contacts: [supplier_c_contact])

# GCMES suppliers
gcmes.suppliers.create!(name: "PHILIPPINE SPAN ASIA CARRIER CORP.", code: "SPAN", address: "753 Roxas Boulevard, Pasay City, Metro Manila", contacts: [supplier_d_contact])
gcmes.suppliers.create!(name: "LORENZO SHIPPING CORPORATION", code: "LSC", address: "159 España Boulevard, Manila City, Metro Manila", contacts: [supplier_e_contact])

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
