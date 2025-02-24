# Get necessary records
Canvass.with_deleted.each do |canvass|
  canvass.really_destroy!
end
gat = Company.find_by(code: "GAT")

supplier_ncs = Supplier.find_by(code: "NCS")
supplier_fsc = Supplier.find_by(code: "FSC")
supplier_asi = Supplier.find_by(code: "ASI")
supplier_span = Supplier.find_by(code: "SPAN")
supplier_lsc = Supplier.find_by(code: "LSC")

user = User.find_by(email: "purchasing@goldenchain.com.ph")
manager = User.find_by(email: "manager@goldenchain.com.ph")

# Find projects by their PO numbers
anchor_winch_project = Project.find_by(po_number: "ASI-PO-2024-0123")
# engine_overhaul_project = Project.find_by(po_number: "ASI-PO-2024-0123")
engine_overhaul_project = Project.find_by(po_number: "SPAN-2024-0456")
propulsion_project = Project.find_by(po_number: "LSC-MNT-2024-0789")
cooling_system_project = Project.find_by(po_number: "SPAN-MNT-2024-0789")
deck_equipment_project = Project.find_by(po_number: "LSC-DCK-2024-0234")
automation_project = Project.find_by(po_number: "FSC-AUT-2024-0567")
water_management_project = Project.find_by(po_number: "SPAN-WMS-2024-0890")
auxiliary_systems_project = Project.find_by(po_number: "ASI-AUX-2024-0345")
navigation_safety_project = Project.find_by(po_number: "FSC-NAV-2024-0678")
safety_equipment_project = Project.find_by(po_number: "SPAN-2024-0473")

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
  project: engine_overhaul_project,
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
  project: engine_overhaul_project,
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
  company: gat,
  project: engine_overhaul_project,
  user: user,
  description: "SUPPLY OF TURBOCHARGER REPAIR KIT",
  quantity: 2,
  unit: "sets",
  item_name: "Turbocharger Repair Kit",
  suppliers_data: [
    { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["164000.0", "ABB VTR-354", "45 days", "", false] },
    { "ASTRO SHIPMANAGEMENT INC." => ["165000.0", "ABB VTR-354", "40 days", "", true] },
    { "LORENZO SHIPPING CORPORATION" => ["166000.0", "ABB VTR-354", "50 days", "", false] }
  ],
  manager: manager
)

create_canvass(
  company: gat,
  project: navigation_safety_project,
  user: user,
  description: "MAIN ENGINE CYLINDER HEAD OVERHAUL",
  quantity: 6,
  unit: "sets",
  item_name: "Cylinder Head",
  suppliers_data: [
    { "ASTRO SHIPMANAGEMENT INC." => ["120000.0", "MAN B&W 6S50MC", "30 days", "", false] },
    { "FRABELLE SHIPYARD CORPORATION" => ["125000.0", "MAN B&W 6S50MC", "35 days", "", true] },
    { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["128000.0", "MAN B&W 6S50MC", "40 days", "", false] }
  ],
  manager: manager
)

create_canvass(
  company: gat,
  project: safety_equipment_project,
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
  company: gat,
  project: safety_equipment_project,
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

# Fifth Project Canvasses - Main Engine Cooling and Fuel System
create_canvass(
  company: gat,
  project: cooling_system_project,
  user: user,
  description: "FRESH WATER COOLER RECONDITIONING",
  quantity: 2,
  unit: "units",
  item_name: "Fresh Water Cooler",
  suppliers_data: [
    { "FRABELLE SHIPYARD CORPORATION" => ["172000.0", "Shell and Tube Type, 25m²", "15 days", "", false] },
    { "LORENZO SHIPPING CORPORATION" => ["175000.0", "Shell and Tube Type, 25m²", "12 days", "", true] },
    { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["178000.0", "Shell and Tube Type, 25m²", "14 days", "", false] }
  ],
  manager: manager
)

create_canvass(
  company: gat,
  project: cooling_system_project,
  user: user,
  description: "SUPPLY OF FUEL INJECTION PUMP",
  quantity: 6,
  unit: "sets",
  item_name: "Fuel Injection Pump",
  suppliers_data: [
    { "ASTRO SHIPMANAGEMENT INC." => ["280000.0", "MAN B&W, High Pressure", "45 days", "", false] },
    { "NARRA CREWING AND SHIP MANAGEMENT CORPORATION" => ["285000.0", "MAN B&W, High Pressure", "40 days", "", true] },
    { "LORENZO SHIPPING CORPORATION" => ["288000.0", "MAN B&W, High Pressure", "42 days", "", false] }
  ],
  manager: manager
)

# Sixth Project Canvasses - Deck Equipment
create_canvass(
  company: gat,
  project: deck_equipment_project,
  user: user,
  description: "DECK CRANE OVERHAUL",
  quantity: 2,
  unit: "units",
  item_name: "Deck Crane Overhaul",
  suppliers_data: [
    { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["445000.0", "25 Tons Capacity, Complete Overhaul", "25 days", "", false] },
    { "LORENZO SHIPPING CORPORATION" => ["450000.0", "25 Tons Capacity, Complete Overhaul", "22 days", "", true] },
    { "FRABELLE SHIPYARD CORPORATION" => ["455000.0", "25 Tons Capacity, Complete Overhaul", "24 days", "", false] }
  ],
  manager: manager
)

create_canvass(
  company: gat,
  project: deck_equipment_project,
  user: user,
  description: "WINDLASS OVERHAUL",
  quantity: 2,
  unit: "sets",
  item_name: "Windlass Overhaul",
  suppliers_data: [
    { "LORENZO SHIPPING CORPORATION" => ["270000.0", "20 Ton Capacity, Complete Service", "20 days", "", false] },
    { "ASTRO SHIPMANAGEMENT INC." => ["275000.0", "20 Ton Capacity, Complete Service", "18 days", "", true] },
    { "NARRA CREWING AND SHIP MANAGEMENT CORPORATION" => ["278000.0", "20 Ton Capacity, Complete Service", "22 days", "", false] }
  ],
  manager: manager
)

# Seventh Project Canvasses - Engine Room Automation
create_canvass(
  company: gat,
  project: automation_project,
  user: user,
  description: "SUPPLY AND INSTALLATION OF ENGINE MONITORING SYSTEM",
  quantity: 1,
  unit: "set",
  item_name: "Engine Monitoring System",
  suppliers_data: [
    { "NARRA CREWING AND SHIP MANAGEMENT CORPORATION" => ["745000.0", "Complete System with Sensors", "30 days", "", false] },
    { "FRABELLE SHIPYARD CORPORATION" => ["750000.0", "Complete System with Sensors", "28 days", "", true] },
    { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["755000.0", "Complete System with Sensors", "32 days", "", false] }
  ],
  manager: manager
)

create_canvass(
  company: gat,
  project: automation_project,
  user: user,
  description: "SUPPLY OF ALARM MONITORING SYSTEM",
  quantity: 1,
  unit: "set",
  item_name: "Alarm Monitoring System",
  suppliers_data: [
    { "ASTRO SHIPMANAGEMENT INC." => ["345000.0", "22-inch Touch Screen, 256 Digital Points", "25 days", "", false] },
    { "LORENZO SHIPPING CORPORATION" => ["350000.0", "22-inch Touch Screen, 256 Digital Points", "22 days", "", true] },
    { "FRABELLE SHIPYARD CORPORATION" => ["355000.0", "22-inch Touch Screen, 256 Digital Points", "24 days", "", false] }
  ],
  manager: manager
)

# Eighth Project Canvasses - Water Management Systems
create_canvass(
  company: gat,
  project: water_management_project,
  user: user,
  description: "BALLAST PUMP OVERHAUL",
  quantity: 2,
  unit: "sets",
  item_name: "Ballast Pump",
  suppliers_data: [
    { "FRABELLE SHIPYARD CORPORATION" => ["180000.0", "750 m³/hr Capacity", "18 days", "", false] },
    { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["185000.0", "750 m³/hr Capacity", "15 days", "", true] },
    { "LORENZO SHIPPING CORPORATION" => ["188000.0", "750 m³/hr Capacity", "20 days", "", false] }
  ],
  manager: manager
)

create_canvass(
  company: gat,
  project: water_management_project,
  user: user,
  description: "SUPPLY AND INSTALLATION OF SEWAGE TREATMENT PLANT",
  quantity: 1,
  unit: "set",
  item_name: "Sewage Treatment Plant",
  suppliers_data: [
    { "LORENZO SHIPPING CORPORATION" => ["645000.0", "5.0 m³/day, MEPC.227(64)", "25 days", "", false] },
    { "ASTRO SHIPMANAGEMENT INC." => ["650000.0", "5.0 m³/day, MEPC.227(64)", "22 days", "", true] },
    { "NARRA CREWING AND SHIP MANAGEMENT CORPORATION" => ["655000.0", "5.0 m³/day, MEPC.227(64)", "24 days", "", false] }
  ],
  manager: manager
)

# Ninth Project Canvasses - Auxiliary Systems
create_canvass(
  company: gat,
  project: auxiliary_systems_project,
  user: user,
  description: "SUPPLY OF BOILER FEED PUMP",
  quantity: 2,
  unit: "sets",
  item_name: "Boiler Feed Pump",
  suppliers_data: [
    { "PHILIPPINE SPAN ASIA CARRIER CORP." => ["162000.0", "Multistage Centrifugal, 5 m³/hr", "30 days", "", false] },
    { "LORENZO SHIPPING CORPORATION" => ["165000.0", "Multistage Centrifugal, 5 m³/hr", "28 days", "", true] },
    { "FRABELLE SHIPYARD CORPORATION" => ["168000.0", "Multistage Centrifugal, 5 m³/hr", "32 days", "", false] }
  ],
  manager: manager
)

create_canvass(
  company: gat,
  project: auxiliary_systems_project,
  user: user,
  description: "SUPPLY OF BOILER CONTROL PANEL",
  quantity: 1,
  unit: "set",
  item_name: "Boiler Control Panel",
  suppliers_data: [
    { "ASTRO SHIPMANAGEMENT INC." => ["280000.0", "Complete Control System", "25 days", "", false] },
    { "NARRA CREWING AND SHIP MANAGEMENT CORPORATION" => ["285000.0", "Complete Control System", "22 days", "", true] },
    { "LORENZO SHIPPING CORPORATION" => ["288000.0", "Complete Control System", "24 days", "", false] }
  ],
  manager: manager
)
