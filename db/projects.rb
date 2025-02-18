# Get company and client records
gat = Company.find_by(code: "GAT")
gcmes = Company.find_by(code: "GCMES")

client_asi = Client.find_by(code: "ASI")
client_span = Client.find_by(code: "SPAN")
client_lsc = Client.find_by(code: "LSC")

user = User.find_by(email: "purchasing@goldenchain.ph")
manager = User.find_by(email: "manager@goldenchain.ph")


# Helper method to calculate total amount from quotations
def calculate_project_amount(quotations)
  quotations.sum(&:total)
end

def set_approval_details(quotation, created_at, manager)
  quotation.update_columns(
    approved_at: created_at + 3.hours,
    approver_id: manager.id
  )
end

# First Project - Engine Overhaul Project
quotations1 = Quotation.where(subject: ["SUPPLY OF LABOR AND MATERIALS TO FABRICATE ANCHOR WINCH SPUR AND PINION GEAR"])
quotations1.each do |quotation|
  created_at = quotation.created_at
  set_approval_details(quotation, created_at, manager)
  quotation.update(status: "approved")
end
project1 = Project.create!(
  company: gat,
  client: client_asi,
  user: user,
  status: "ongoing",
  payment: "50% downpayment",
  po_number: "ASI-PO-2024-0123",
  supervisor: "MICHAEL DUEÑAS",
  technical_team: ["JOSELITO ONG", "JUSTIN BRIAN MANGUBAT", "MARLON MARLOS"],
  quotations: quotations1,
  amount: calculate_project_amount(quotations1)
)

# First Project - Engine Overhaul Project
quotations2 = Quotation.where(subject: ["SUPPLY OF ENGINE SPARE PARTS", "MAIN ENGINE CYLINDER HEAD OVERHAUL"])
quotations2.each do |quotation|
  created_at = quotation.created_at
  set_approval_details(quotation, created_at, manager)
  quotation.update(status: "approved")
end
project2 = Project.create!(
  company: gat,
  # client: client_span,
  user: user,
  status: "ongoing",
  payment: "50% downpayment",
  po_number: "SPAN-2024-0456",
  supervisor: "DANIEL GARCIA",
  technical_team: ["JOSELITO ONG", "JUSTIN BRIAN MANGUBAT", "MARLON MARLOS"],
  quotations: quotations2,
  amount: calculate_project_amount(quotations2)
)

# Second Project - Navigation and Safety Equipment Upgrade
quotations3 = Quotation.where(subject: ["NAVIGATION EQUIPMENT UPGRADE", "SUPPLY OF SAFETY EQUIPMENT"])
quotations3.each do |quotation|
  created_at = quotation.created_at
  set_approval_details(quotation, created_at, manager)
  quotation.update(status: "approved")
end
project3 = Project.create!(
  company: gcmes,
  # client: client_span,
  user: user,
  status: "ongoing",
  payment: "30 days",
  po_number: "SPAN-2024-0473",
  supervisor: "ROBERTO SANTOS",
  technical_team: ["MARK ANTHONY CRUZ", "RICHARD TAN", "JOSEPH LIM"],
  quotations: quotations3,
  amount: calculate_project_amount(quotations3)
)

# Third Project - Propulsion System Maintenance
quotations4 = Quotation.where(subject: ["PROPELLER REPAIR AND BALANCING", "STEERING GEAR SYSTEM OVERHAUL"])
quotations4.each do |quotation|
  created_at = quotation.created_at
  set_approval_details(quotation, created_at, manager)
  quotation.update(status: "approved")
end
project4 = Project.create!(
  company: gat,
  # client: client_lsc,
  user: user,
  status: "ongoing",
  payment: "50% downpayment",
  po_number: "LSC-MNT-2024-0789",
  supervisor: "EDUARDO GARCIA",
  technical_team: ["CARLO MENDOZA", "RYAN REYES", "BENJAMIN TAN"],
  quotations: quotations4,
  amount: calculate_project_amount(quotations4)
)
