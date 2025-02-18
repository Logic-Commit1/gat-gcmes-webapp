# Get necessary records
gat = Company.find_by(code: "GAT")
gcmes = Company.find_by(code: "GCMES")

supplier_ncs = Supplier.find_by(code: "NCS")
supplier_fsc = Supplier.find_by(code: "FSC")
supplier_asi = Supplier.find_by(code: "ASI")
supplier_span = Supplier.find_by(code: "SPAN")
supplier_lsc = Supplier.find_by(code: "LSC")

user = User.find_by(email: "purchasing@goldenchain.ph")
manager = User.find_by(email: "manager@goldenchain.ph")

# Find projects by their PO numbers
anchor_winch_project = Project.find_by(po_number: "ASI-PO-2024-0123")
navigation_project = Project.find_by(po_number: "SPAN-2024-0456")
propulsion_project = Project.find_by(po_number: "LSC-MNT-2024-0789")

def set_approval_details(canvass, created_at, manager)
  canvass.update_columns(
    approved_at: created_at + 3.hours,
    approver_id: manager.id
  )
end

def create_canvass(company:, project:, user:, description:, quantity:, unit:, item_name:, suppliers_data:, manager:)
  canvass = Canvass.create!(
    company: company,
    project: project,
    user: user,
    status: "approved",
    description: description,
    quantity: quantity,
    unit: unit,
    skip_suppliers_callback: true,
    suppliers: [{
      item_name => suppliers_data
    }]
  )
  set_approval_details(canvass, Time.current, manager)
  canvass
end

# First Project Canvasses - Engine Spare Parts
create_canvass(
  company: gat,
  project: anchor_winch_project,
  user: user,
  description: "SUPPLY OF ROLLER BEARING",
  quantity: 2,
  unit: "unit",
  item_name: "Roller Bearing",
  suppliers_data: [
    { "FRABELLE SHIPYARD CORPORATION" => ["16500.0", "SUJ 22308C", "3-5 days", "", false] },
    { "NARRA CREWING AND SHIP MANAGEMENT CORPORATION" => ["17000.0", "SUJ 22308C", "7 days", "", false] },
    { "LORENZO SHIPPING CORPORATION" => ["17500.0", "SUJ 22308C", "5 days", "", true] }
  ],
  manager: manager
)

create_canvass(
  company: gat,
  project: navigation_project,
  user: user,
  description: "SUPPLY OF PISTON CROWN",
  quantity: 6,
  unit: "pcs",
  item_name: "Piston Crown",
  suppliers_data: [
    { "FRABELLE SHIPYARD CORPORATION" => ["63000.0", "Chrome-Moly Steel, 580mm", "14 days", "", false] },
    { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["65000.0", "Chrome-Moly Steel, 580mm", "10 days", "", true] },
    { "ASTRO SHIPMANAGEMENT INC." => ["67000.0", "Chrome-Moly Steel, 580mm", "12 days", "", false] }
  ],
  manager: manager
)

create_canvass(
  company: gat,
  project: navigation_project,
  user: user,
  description: "SUPPLY OF CYLINDER LINER",
  quantity: 6,
  unit: "pcs",
  item_name: "Cylinder Liner",
  suppliers_data: [
    { "LORENZO SHIPPING CORPORATION" => ["76000.0", "Cast Iron, 580mm bore", "14 days", "", false] },
    { "FRABELLE SHIPYARD CORPORATION" => ["78000.0", "Cast Iron, 580mm bore", "10 days", "", true] },
    { "NARRA CREWING AND SHIP MANAGEMENT CORPORATION" => ["79500.0", "Cast Iron, 580mm bore", "12 days", "", false] }
  ],
  manager: manager
)

# Second Project Canvasses - Navigation Equipment
create_canvass(
  company: gcmes,
  project: navigation_project,
  user: user,
  description: "SUPPLY OF RADAR SYSTEM",
  quantity: 1,
  unit: "set",
  item_name: "Radar System",
  suppliers_data: [
    { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["645000.0", "Furuno FAR-2228, X-Band", "45 days", "", false] },
    { "ASTRO SHIPMANAGEMENT INC." => ["650000.0", "Furuno FAR-2228, X-Band", "40 days", "", true] },
    { "LORENZO SHIPPING CORPORATION" => ["655000.0", "Furuno FAR-2228, X-Band", "50 days", "", false] }
  ],
  manager: manager
)

create_canvass(
  company: gcmes,
  project: navigation_project,
  user: user,
  description: "SUPPLY OF GYRO COMPASS",
  quantity: 1,
  unit: "set",
  item_name: "Gyro Compass",
  suppliers_data: [
    { "ASTRO SHIPMANAGEMENT INC." => ["420000.0", "Sperry Marine NavigatTM X MK1", "30 days", "", false] },
    { "FRABELLE SHIPYARD CORPORATION" => ["425000.0", "Sperry Marine NavigatTM X MK1", "35 days", "", true] },
    { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["428000.0", "Sperry Marine NavigatTM X MK1", "40 days", "", false] }
  ],
  manager: manager
)

create_canvass(
  company: gcmes,
  project: navigation_project,
  user: user,
  description: "SUPPLY OF BREATHING APPARATUS",
  quantity: 4,
  unit: "sets",
  item_name: "Breathing Apparatus",
  suppliers_data: [
    { "LORENZO SHIPPING CORPORATION" => ["82000.0", "Dräger PSS 3000, 6.8L/300bar", "21 days", "", false] },
    { "NARRA CREWING AND SHIP MANAGEMENT CORPORATION" => ["85000.0", "Dräger PSS 3000, 6.8L/300bar", "14 days", "", true] },
    { "FRABELLE SHIPYARD CORPORATION" => ["87000.0", "Dräger PSS 3000, 6.8L/300bar", "18 days", "", false] }
  ],
  manager: manager
)

create_canvass(
  company: gcmes,
  project: navigation_project,
  user: user,
  description: "SUPPLY OF FIRE FIGHTING EQUIPMENT",
  quantity: 1,
  unit: "lot",
  item_name: "Fire Fighting Equipment",
  suppliers_data: [
    { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["230000.0", "SOLAS Compliant, BV Approved", "30 days", "", true] },
    { "ASTRO SHIPMANAGEMENT INC." => ["235000.0", "SOLAS Compliant, BV Approved", "25 days", "", false] },
    { "LORENZO SHIPPING CORPORATION" => ["238000.0", "SOLAS Compliant, BV Approved", "28 days", "", false] }
  ],
  manager: manager
)

# Third Project Canvasses - Propulsion System
create_canvass(
  company: gat,
  project: propulsion_project,
  user: user,
  description: "PROPELLER BLADE REPAIR AND BALANCING",
  quantity: 1,
  unit: "set",
  item_name: "Propeller Repair",
  suppliers_data: [
    { "LORENZO SHIPPING CORPORATION" => ["445000.0", "Complete Repair & Balancing", "25 days", "", false] },
    { "FRABELLE SHIPYARD CORPORATION" => ["450000.0", "Complete Repair & Balancing", "28 days", "", false] },
    { "NARRA CREWING AND SHIP MANAGEMENT CORPORATION" => ["455000.0", "Complete Repair & Balancing", "30 days", "", true] }
  ],
  manager: manager
)

create_canvass(
  company: gat,
  project: propulsion_project,
  user: user,
  description: "STEERING GEAR SYSTEM OVERHAUL",
  quantity: 1,
  unit: "lot",
  item_name: "Steering Gear Overhaul",
  suppliers_data: [
    { "ASTRO SHIPMANAGEMENT INC." => ["380000.0", "Complete System Overhaul", "20 days", "", true] },
    { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["385000.0", "Complete System Overhaul", "18 days", "", false] },
    { "FRABELLE SHIPYARD CORPORATION" => ["390000.0", "Complete System Overhaul", "22 days", "", false] }
  ],
  manager: manager
)

create_canvass(
  company: gat,
  project: propulsion_project,
  user: user,
  description: "HYDRAULIC SYSTEM MAINTENANCE",
  quantity: 1,
  unit: "lot",
  item_name: "Hydraulic System",
  suppliers_data: [
    { "NARRA CREWING AND SHIP MANAGEMENT CORPORATION" => ["175000.0", "Complete System Check", "10 days", "", false] },
    { "LORENZO SHIPPING CORPORATION" => ["180000.0", "Complete System Check", "12 days", "", true] },
    { "ASTRO SHIPMANAGEMENT INC." => ["185000.0", "Complete System Check", "14 days", "", false] }
  ],
  manager: manager
)