# Get company and client records
gat = Company.find_by(code: "GAT")
gcmes = Company.find_by(code: "GCMES")

client_asi = Client.find_by(code: "ASI")
client_span = Client.find_by(code: "SPAN")
client_lsc = Client.find_by(code: "LSC")

user = User.find_by(email: "purchasing@goldenchain.ph")

# Helper method to calculate total amount from quotations
def calculate_project_amount(quotations)
  quotations.sum(&:total)
end

# First Project - Engine Overhaul Project
quotations1 = Quotation.where(subject: ["SUPPLY OF ENGINE SPARE PARTS", "MAIN ENGINE CYLINDER HEAD OVERHAUL"])
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

# Second Project - Navigation and Safety Equipment Upgrade
quotations2 = Quotation.where(subject: ["NAVIGATION EQUIPMENT UPGRADE", "SUPPLY OF SAFETY EQUIPMENT"])
project2 = Project.create!(
  company: gcmes,
  client: client_span,
  user: user,
  status: "ongoing",
  payment: "30 days",
  po_number: "SPAN-2024-0456",
  supervisor: "ROBERTO SANTOS",
  technical_team: ["MARK ANTHONY CRUZ", "RICHARD TAN", "JOSEPH LIM"],
  quotations: quotations2,
  amount: calculate_project_amount(quotations2)
)

# Third Project - Propulsion System Maintenance
quotations3 = Quotation.where(subject: ["PROPELLER REPAIR AND BALANCING", "STEERING GEAR SYSTEM OVERHAUL"])
project3 = Project.create!(
  company: gat,
  client: client_lsc,
  user: user,
  status: "ongoing",
  payment: "50% downpayment",
  po_number: "LSC-MNT-2024-0789",
  supervisor: "EDUARDO GARCIA",
  technical_team: ["CARLO MENDOZA", "RYAN REYES", "BENJAMIN TAN"],
  quotations: quotations3,
  amount: calculate_project_amount(quotations3)
)