# Get necessary records
gat = Company.find_by(code: "GAT")
gcmes = Company.find_by(code: "GCMES")

supplier_ncs = Supplier.find_by(code: "NCS")
supplier_fsc = Supplier.find_by(code: "FSC")
supplier_asi = Supplier.find_by(code: "ASI")
supplier_span = Supplier.find_by(code: "SPAN")
supplier_lsc = Supplier.find_by(code: "LSC")

user = User.find_by(email: "purchasing@goldenchain.ph")

# Find projects by their PO numbers
engine_project = Project.find_by(po_number: "ASI-PO-2024-0123")
navigation_project = Project.find_by(po_number: "SPAN-2024-0456")

# First Project Canvasses - Engine Spare Parts
# Roller Bearing Canvass
Canvass.create!(
  company: gat,
  project: engine_project,
  user: user,
  status: "pending",
  description: "SUPPLY OF ROLLER BEARING",
  quantity: 2,
  unit: "unit",
  skip_suppliers_callback: true,
  suppliers: [{
    "Roller Bearing" => [
      { "FRABELLE SHIPYARD CORPORATION" => ["16500.0", "SUJ 22308C", "3-5 days", "", false] },
      { "NARRA CREWING AND SHIP MANAGEMENT CORPORATION" => ["17000.0", "SUJ 22308C", "7 days", "", false] },
      { "LORENZO SHIPPING CORPORATION" => ["17500.0", "SUJ 22308C", "5 days", "", false] }
    ]
  }]
)

# Piston Crown Canvass
Canvass.create!(
  company: gat,
  project: engine_project,
  user: user,
  status: "pending",
  description: "SUPPLY OF PISTON CROWN",
  quantity: 6,
  unit: "pcs",
  skip_suppliers_callback: true,
  suppliers: [{
    "Piston Crown" => [
      { "FRABELLE SHIPYARD CORPORATION" => ["63000.0", "Chrome-Moly Steel, 580mm", "14 days", "", false] },
      { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["65000.0", "Chrome-Moly Steel, 580mm", "10 days", "", false] },
      { "ASTRO SHIPMANAGEMENT INC." => ["67000.0", "Chrome-Moly Steel, 580mm", "12 days", "", false] }
    ]
  }]
)

# Cylinder Liner Canvass
Canvass.create!(
  company: gat,
  project: engine_project,
  user: user,
  status: "pending",
  description: "SUPPLY OF CYLINDER LINER",
  quantity: 6,
  unit: "pcs",
  skip_suppliers_callback: true,
  suppliers: [{
    "Cylinder Liner" => [
      { "LORENZO SHIPPING CORPORATION" => ["76000.0", "Cast Iron, 580mm bore", "14 days", "", false] },
      { "FRABELLE SHIPYARD CORPORATION" => ["78000.0", "Cast Iron, 580mm bore", "10 days", "", false] },
      { "NARRA CREWING AND SHIP MANAGEMENT CORPORATION" => ["79500.0", "Cast Iron, 580mm bore", "12 days", "", false] }
    ]
  }]
)

# Second Project Canvasses - Navigation Equipment
# Radar System Canvass
Canvass.create!(
  company: gcmes,
  project: navigation_project,
  user: user,
  status: "pending",
  description: "SUPPLY OF RADAR SYSTEM",
  quantity: 1,
  unit: "set",
  skip_suppliers_callback: true,
  suppliers: [{
    "Radar System" => [
      { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["645000.0", "Furuno FAR-2228, X-Band", "45 days", "", false] },
      { "ASTRO SHIPMANAGEMENT INC." => ["650000.0", "Furuno FAR-2228, X-Band", "40 days", "", false] },
      { "LORENZO SHIPPING CORPORATION" => ["655000.0", "Furuno FAR-2228, X-Band", "50 days", "", false] }
    ]
  }]
)

# Gyro Compass Canvass
Canvass.create!(
  company: gcmes,
  project: navigation_project,
  user: user,
  status: "pending",
  description: "SUPPLY OF GYRO COMPASS",
  quantity: 1,
  unit: "set",
  skip_suppliers_callback: true,
  suppliers: [{
    "Gyro Compass" => [
      { "ASTRO SHIPMANAGEMENT INC." => ["420000.0", "Sperry Marine NavigatTM X MK1", "30 days", "", false] },
      { "FRABELLE SHIPYARD CORPORATION" => ["425000.0", "Sperry Marine NavigatTM X MK1", "35 days", "", false] },
      { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["428000.0", "Sperry Marine NavigatTM X MK1", "40 days", "", false] }
    ]
  }]
)

# Breathing Apparatus Canvass
Canvass.create!(
  company: gcmes,
  project: navigation_project,
  user: user,
  status: "pending",
  description: "SUPPLY OF BREATHING APPARATUS",
  quantity: 4,
  unit: "sets",
  skip_suppliers_callback: true,
  suppliers: [{
    "Breathing Apparatus" => [
      { "LORENZO SHIPPING CORPORATION" => ["82000.0", "Dräger PSS 3000, 6.8L/300bar", "21 days", "", false] },
      { "NARRA CREWING AND SHIP MANAGEMENT CORPORATION" => ["85000.0", "Dräger PSS 3000, 6.8L/300bar", "14 days", "", false] },
      { "FRABELLE SHIPYARD CORPORATION" => ["87000.0", "Dräger PSS 3000, 6.8L/300bar", "18 days", "", false] }
    ]
  }]
)

# Fire Fighting Equipment Canvass
Canvass.create!(
  company: gcmes,
  project: navigation_project,
  user: user,
  status: "pending",
  description: "SUPPLY OF FIRE FIGHTING EQUIPMENT",
  quantity: 1,
  unit: "lot",
  skip_suppliers_callback: true,
  suppliers: [{
    "Fire Fighting Equipment" => [
      { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["230000.0", "SOLAS Compliant, BV Approved", "30 days", "", false] },
      { "ASTRO SHIPMANAGEMENT INC." => ["235000.0", "SOLAS Compliant, BV Approved", "25 days", "", false] },
      { "LORENZO SHIPPING CORPORATION" => ["238000.0", "SOLAS Compliant, BV Approved", "28 days", "", false] }
    ]
  }]
)
