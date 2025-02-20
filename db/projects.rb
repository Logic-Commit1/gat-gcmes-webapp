Project.with_deleted.each do |project|
  project.really_destroy!
end
# Get company and client records
gat = Company.find_by(code: "GAT")


client_asi = Client.find_by(code: "ASI")
client_span = Client.find_by(code: "SPAN")
client_lsc = Client.find_by(code: "LSC")
client_fsc = Client.find_by(code: "FSC")

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

def random_date_within_last_1_month
  end_date = Time.current
  start_date = 1.month.ago
  rand(start_date..end_date)
end

# First Project - FABRICATE ANCHOR WINCH SPUR AND PINION GEAR
quotations1 = Quotation.where(subject: ["SUPPLY OF LABOR AND MATERIALS TO FABRICATE ANCHOR WINCH SPUR AND PINION GEAR"])
quotations1.each do |quotation|
  created_at = quotation.created_at
  set_approval_details(quotation, created_at, manager)
  quotation.update(status: "approved")
end
created_at = random_date_within_last_1_month
project1 = Project.create!(
  company: gat,
  client: quotations1.first.client,
  user: user,
  status: "served",
  sales_invoice: "ASI-INV-2024-0123",
  payment: "50% downpayment",
  po_number: "ASI-PO-2024-0123",
  supervisor: "MICHAEL DUEÑAS",
  technical_team: ["JOSELITO ONG", "JUSTIN BRIAN MANGUBAT", "MARLON MARLOS"],
  quotations: quotations1,
  amount: calculate_project_amount(quotations1),
  created_at: created_at,
  updated_at: created_at
)

# Second Project - Engine Overhaul Project
quotations2 = Quotation.where(subject: ["SUPPLY OF ENGINE SPARE PARTS", "MAIN ENGINE CYLINDER HEAD OVERHAUL"])
quotations2.each do |quotation|
  created_at = quotation.created_at
  set_approval_details(quotation, created_at, manager)
  quotation.update(status: "approved")
end
created_at = random_date_within_last_1_month
project2 = Project.create!(
  company: gat,
  client: quotations2.first.client,
  user: user,
  status: "ongoing",
  payment: "50% downpayment",
  po_number: "SPAN-2024-0456",
  supervisor: "DANIEL GARCIA",
  technical_team: ["JOSELITO ONG", "JUSTIN BRIAN MANGUBAT", "MARLON MARLOS"],
  quotations: quotations2,
  amount: calculate_project_amount(quotations2),
  created_at: created_at,
  updated_at: created_at
)

# Third Project - Navigation and Safety Equipment Upgrade
quotations3 = Quotation.where(subject: ["SUPPLY OF SAFETY EQUIPMENT"])
quotations3.each do |quotation|
  created_at = quotation.created_at
  set_approval_details(quotation, created_at, manager)
  quotation.update(status: "approved")
end
created_at = random_date_within_last_1_month
project3 = Project.create!(
  company: gat,
  client: quotations3.first.client,
  user: user,
  status: "ongoing",
  payment: "30 days",
  po_number: "SPAN-2024-0473",
  supervisor: "ROBERTO SANTOS",
  technical_team: ["MARK ANTHONY CRUZ", "RICHARD TAN", "JOSEPH LIM"],
  quotations: quotations3,
  amount: calculate_project_amount(quotations3),
  created_at: created_at,
  updated_at: created_at
)

# Fourth Project - Propulsion System Maintenance
quotations4 = Quotation.where(subject: ["PROPELLER REPAIR AND BALANCING", "FUEL SYSTEM COMPONENTS REPLACEMENT"])
quotations4.each do |quotation|
  created_at = quotation.created_at
  set_approval_details(quotation, created_at, manager)
  quotation.update(status: "approved")
end
created_at = random_date_within_last_1_month
project4 = Project.create!(
  company: gat,
  client: quotations4.first.client,
  user: user,
  status: "ongoing",
  payment: "50% downpayment",
  po_number: "SPAN-MNT-2024-0789",
  supervisor: "EDUARDO GARCIA",
  technical_team: ["CARLO MENDOZA", "RYAN REYES", "BENJAMIN TAN"],
  quotations: quotations4,
  amount: calculate_project_amount(quotations4),
  created_at: created_at,
  updated_at: created_at
)

# Fifth Project - Main Engine Cooling and Fuel System Upgrade
quotations5 = Quotation.where(subject: ["MAIN ENGINE COOLING SYSTEM MAINTENANCE"])
quotations5.each do |quotation|
  created_at = quotation.created_at
  set_approval_details(quotation, created_at, manager)
  quotation.update(status: "approved")
end
created_at = random_date_within_last_1_month
project5 = Project.create!(
  company: gat,
  client: quotations5.first.client,
  user: user,
  status: "ongoing",
  payment: "50% downpayment",
  po_number: "ASI-PO-2024-0789",
  supervisor: "ALEXANDER CRUZ",
  technical_team: ["RAYMOND SANTOS", "ERIC TAN", "MICHAEL REYES"],
  quotations: quotations5,
  amount: calculate_project_amount(quotations5),
  created_at: created_at,
  updated_at: created_at
)

# Sixth Project - Deck Equipment Overhaul
quotations6 = Quotation.where(subject: ["DECK CRANE MAINTENANCE", "STEERING GEAR SYSTEM OVERHAUL"])
quotations6.each do |quotation|
  created_at = quotation.created_at
  set_approval_details(quotation, created_at, manager)
  quotation.update(status: "approved")
end
created_at = random_date_within_last_1_month
project6 = Project.create!(
  company: gat,
  client: quotations6.first.client,
  user: user,
  status: "ongoing",
  payment: "30 days",
  po_number: "LSC-DCK-2024-0234",
  supervisor: "RICARDO MARTINEZ",
  technical_team: ["JASON WONG", "PETER LIM", "ANDREW SANTOS"],
  quotations: quotations6,
  amount: calculate_project_amount(quotations6),
  created_at: created_at,
  updated_at: created_at
)

# Seventh Project - Engine Room Automation and Monitoring
quotations7 = Quotation.where(subject: ["ENGINE ROOM AUTOMATION UPGRADE", "ELECTRICAL SYSTEM MAINTENANCE AND UPGRADE"])
quotations7.each do |quotation|
  created_at = quotation.created_at
  set_approval_details(quotation, created_at, manager)
  quotation.update(status: "approved")
end
created_at = random_date_within_last_1_month
project7 = Project.create!(
  company: gat,
  client: quotations7.first.client,
  user: user,
  status: "ongoing",
  payment: "50% downpayment",
  po_number: "FSC-AUT-2024-0567",
  supervisor: "CHRISTOPHER LIM",
  technical_team: ["DAVID CHEN", "ROBERT WONG", "MARK SANTOS"],
  quotations: quotations7,
  amount: calculate_project_amount(quotations7),
  created_at: created_at,
  updated_at: created_at
)

# Eighth Project - Water Management Systems
quotations8 = Quotation.where(subject: ["BALLAST SYSTEM MAINTENANCE", "SEWAGE TREATMENT PLANT REPLACEMENT"])
quotations8.each do |quotation|
  created_at = quotation.created_at
  set_approval_details(quotation, created_at, manager)
  quotation.update(status: "approved")
end
created_at = random_date_within_last_1_month
project8 = Project.create!(
  company: gat,
  client: quotations8.first.client,
  user: user,
  status: "ongoing",
  payment: "50% downpayment",
  po_number: "SPAN-WMS-2024-0890",
  supervisor: "JONATHAN TAN",
  technical_team: ["WILLIAM CRUZ", "HENRY PARK", "STEVEN LEE"],
  quotations: quotations8,
  amount: calculate_project_amount(quotations8),
  created_at: created_at,
  updated_at: created_at
)

# Ninth Project - Auxiliary Systems Upgrade
quotations9 = Quotation.where(subject: ["AUXILIARY BOILER COMPONENTS UPGRADE", "ANCHOR AND WINDLASS SYSTEM MAINTENANCE"])
quotations9.each do |quotation|
  created_at = quotation.created_at
  set_approval_details(quotation, created_at, manager)
  quotation.update(status: "approved")
end
created_at = random_date_within_last_1_month
project9 = Project.create!(
  company: gat,
  client: quotations9.first.client,
  user: user,
  status: "ongoing",
  payment: "30 days",
  po_number: "ASI-AUX-2024-0345",
  supervisor: "KENNETH WONG",
  technical_team: ["THOMAS LEE", "GARY SANTOS", "BRIAN CHEN"],
  quotations: quotations9,
  amount: calculate_project_amount(quotations9),
  created_at: created_at,
  updated_at: created_at
)

