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
PurchaseOrder.with_deleted.each do |purchase_order|
  purchase_order.really_destroy!
end
RequestForm.with_deleted.each do |request_form|
  request_form.really_destroy!
end
Quotation.with_deleted.each do |quotation|
  quotation.really_destroy!
end
Canvass.with_deleted.each do |canvass|
  canvass.really_destroy!
end
Project.destroy_all

gat = Company.find_by(code: "GAT")
# gcmes = Company.find_by(code: "GCMES")

client_asi = Client.find_by(code: "ASI")
client_span = Client.find_by(code: "SPAN")
client_lsc = Client.find_by(code: "LSC")
client_fsc = Client.find_by(code: "FSC")
client_ncs = Client.find_by(code: "NCS")

supplier_nsc = Supplier.find_by(code: "NCS")
supplier_span = Supplier.find_by(code: "SPAN")
supplier_lsc = Supplier.find_by(code: "LSC")
supplier_fsc = Supplier.find_by(code: "FSC")
supplier_asi = Supplier.find_by(code: "ASI")

user = User.find_by(email: "purchasing@goldenchain.com.ph")
manager = User.find_by(email: "manager@goldenchain.com.ph")

# First product with scopes
product1 = Product.create(
  name: "SUPPLY OF LABOR AND MATERIALS TO FABRICATE ANCHOR WINCH SPUR GEAR",
  quantity: 2,
  unit: "unit",
  price: 350000
)

["PULL OUT EXISTING SPUR GEAR",
 "PROVIDE MATERIALS NEEDED FOR FARBICATION",
 "MACHINING OF EACH MATERIALS BASED ON EXISTING SAMPLE",
 "WELDING WORKS / ASSEMBLING",
 "GEAR TEETH HARDENING",
 "PAINTING",
 "DELIVERY ON BOARD"].each do |scope_name|
  Scope.create(name: scope_name, product: product1)
end

# Second product with scopes
product2 = Product.create(
  name: "SUPPLY OF LABOR AND MATERIALS TO FABRICATE ANCHOR WINCH PINION GEAR",
  quantity: 2,
  unit: "unit",
  price: 95000
)

["PULL OUT EXISTING PINION GEAR",
 "PROVIDE MATERIALS NEEDED FOR FARBICATION",
 "MACHINING OF EACH MATERIALS BASED ON EXISTING SAMPLE",
 "WELDING WORKS / ASSEMBLING",
 "GEAR TEETH HARDENING",
 "PAINTING",
 "DELIVERY ON BOARD"].each do |scope_name|
  Scope.create(name: scope_name, product: product2)
end

# Third product with specs
product3 = Product.create(
  name: "SUPPLY OF ROLLER BEARING",
  quantity: 2,
  unit: "unit",
  price: 17000
)

Spec.create(
  name: "SUJ",
  value: "22308C",
  product: product3
)

# Helper method to generate random dates within the last 3 months
def random_date_within_last_1_month
  end_date = Time.current
  start_date = 1.month.ago
  rand(start_date..end_date)
end

# Helper method to set approval details
def set_approval_details(quotation, created_at, manager)
  quotation.update_columns(
    approved_at: created_at + 3.hours,
    approver_id: manager.id
  )
end

# First quotation
created_at = random_date_within_last_1_month
quotation = Quotation.create(
  company: gat,
  client: client_asi,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Ms. Linny Alcuizar",
  vessel: "MV SL ROSE",
  subject: "SUPPLY OF LABOR AND MATERIALS TO FABRICATE ANCHOR WINCH SPUR AND PINION GEAR",
  payment: "30 days",
  duration: "FIFTEEN (15) TO TWENTY (20) WORKING DAYS AFTER RECEIPT OF P.O.",
  discount_rate: 5,
  products: [product1, product2, product3],
  created_at: created_at,
  updated_at: created_at
)
set_approval_details(quotation, created_at, manager)

# Second Quotation - Products with both specs and scopes
product4 = Product.create(
  name: "SUPPLY OF LABOR AND MATERIALS FOR MAIN ENGINE CRANKSHAFT",
  quantity: 1,
  unit: "unit",
  price: 850000
)

["PULL OUT EXISTING CRANKSHAFT",
 "PROVIDE MATERIALS NEEDED FOR REPAIR",
 "MACHINING OF JOURNALS AND PINS",
 "GRINDING AND POLISHING",
 "DYNAMIC BALANCING",
 "INSTALLATION AND ALIGNMENT",
 "TESTING AND COMMISSIONING"].each do |scope_name|
  Scope.create(name: scope_name, product: product4)
end

Spec.create(name: "Material", value: "Forged Steel", product: product4)
Spec.create(name: "Hardness", value: "30-35 HRC", product: product4)

product5 = Product.create(
  name: "SUPPLY OF MAIN BEARING SET",
  quantity: 12,
  unit: "sets",
  price: 45000
)

Spec.create(name: "Size", value: "280mm", product: product5)
Spec.create(name: "Material", value: "White Metal", product: product5)
Spec.create(name: "Standard", value: "ISO 9001", product: product5)

# Second quotation
created_at = random_date_within_last_1_month
quotation2 = Quotation.create(
  company: gat,
  client: client_span,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. James Rodriguez",
  vessel: "MV SPAN ASIA",
  subject: "SUPPLY OF LABOR AND MATERIALS FOR MAIN ENGINE CRANKSHAFT REPAIR",
  payment: "50% downpayment",
  duration: "45 WORKING DAYS",
  discount_rate: 0,
  products: [product4, product5],
  created_at: created_at,
  updated_at: created_at
)
set_approval_details(quotation2, created_at, manager)

# Third Quotation - Products with only scopes
product6 = Product.create(
  name: "FABRICATION OF STERN TUBE ASSEMBLY",
  quantity: 1,
  unit: "set",
  price: 275000
)

["MEASUREMENT AND TEMPLATING",
 "MATERIAL PREPARATION AND CUTTING",
 "MACHINING OF COMPONENTS",
 "WELDING AND ASSEMBLY",
 "PRESSURE TESTING",
 "PAINTING AND COATING",
 "INSTALLATION"].each do |scope_name|
  Scope.create(name: scope_name, product: product6)
end

# Third quotation
created_at = random_date_within_last_1_month
quotation3 = Quotation.create(
  company: gat,
  client: client_fsc,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Ms. Maria Santos",
  vessel: "MV GOLDEN STAR",
  subject: "FABRICATION OF STERN TUBE ASSEMBLY",
  payment: "30 days",
  duration: "30 WORKING DAYS",
  discount_rate: 2,
  products: [product6],
  created_at: created_at,
  updated_at: created_at
)

# Fourth Quotation - Products with only specs
product7 = Product.create(
  name: "SUPPLY OF TURBOCHARGER REPAIR KIT",
  quantity: 2,
  unit: "sets",
  price: 185000
)

Spec.create(name: "Make", value: "ABB VTR-354", product: product7)
Spec.create(name: "Kit Contents", value: "Bearings, Seals, Gaskets", product: product7)
Spec.create(name: "Certification", value: "OEM Certified", product: product7)

product8 = Product.create(
  name: "SUPPLY OF PISTON CROWN",
  quantity: 6,
  unit: "pcs",
  price: 65000
)

Spec.create(name: "Material", value: "Chrome-Moly Steel", product: product8)
Spec.create(name: "Diameter", value: "580mm", product: product8)
Spec.create(name: "Ring Grooves", value: "4", product: product8)

product9 = Product.create(
  name: "SUPPLY OF CYLINDER LINER",
  quantity: 6,
  unit: "pcs",
  price: 78000
)

Spec.create(name: "Material", value: "Cast Iron", product: product9)
Spec.create(name: "Bore", value: "580mm", product: product9)
Spec.create(name: "Treatment", value: "Phosphated", product: product9)

# Fourth quotation
created_at = random_date_within_last_1_month
quotation4 = Quotation.create(
  company: gat,
  client: client_span,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. Robert Lim",
  vessel: "MV ASTRO MARINER",
  subject: "SUPPLY OF ENGINE SPARE PARTS",
  payment: "30 days",
  duration: "60-75 DAYS",
  discount_rate: 3,
  products: [product7, product8, product9],
  created_at: created_at,
  updated_at: created_at
)
set_approval_details(quotation4, created_at, manager)

# Fifth Quotation - Main Engine Overhaul
product10 = Product.create(
  name: "MAIN ENGINE CYLINDER HEAD OVERHAUL",
  quantity: 6,
  unit: "sets",
  price: 125000
)

["DISMANTLING OF CYLINDER HEAD",
 "CLEANING AND INSPECTION",
 "VALVE SEAT RECONDITIONING",
 "VALVE GUIDE REPLACEMENT",
 "PRESSURE TESTING",
 "ASSEMBLY AND TESTING",
 "INSTALLATION"].each do |scope_name|
  Scope.create(name: scope_name, product: product10)
end

Spec.create(name: "Engine Type", value: "MAN B&W 6S50MC", product: product10)
Spec.create(name: "Year", value: "2010", product: product10)

# Fifth quotation
created_at = random_date_within_last_1_month
quotation5 = Quotation.create(
  company: gat,
  client: client_span,
  user: user,
  status: "approved",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. William Chen",
  vessel: "MV FORTUNE STAR",
  subject: "MAIN ENGINE CYLINDER HEAD OVERHAUL",
  payment: "50% downpayment",
  duration: "30 WORKING DAYS",
  discount_rate: 0,
  products: [product10],
  created_at: created_at,
  updated_at: created_at
)
set_approval_details(quotation5, created_at, manager)

# Sixth Quotation - Propeller Repair
product11 = Product.create(
  name: "PROPELLER BLADE REPAIR AND BALANCING",
  quantity: 1,
  unit: "set",
  price: 450000
)

["INSPECTION AND MEASUREMENT",
 "CRACK DETECTION",
 "BLADE STRAIGHTENING",
 "EDGE REBUILDING",
 "SURFACE FINISHING",
 "STATIC BALANCING",
 "DYNAMIC BALANCING"].each do |scope_name|
  Scope.create(name: scope_name, product: product11)
end

# Sixth quotation
created_at = random_date_within_last_1_month
quotation6 = Quotation.create(
  company: gat,
  client: client_span,
  user: user,
  status: "approved",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Ms. Patricia Cruz",
  vessel: "MV ASIA PEARL",
  subject: "PROPELLER REPAIR AND BALANCING",
  payment: "30 days",
  duration: "25 WORKING DAYS",
  discount_rate: 2,
  products: [product11],
  created_at: created_at,
  updated_at: created_at
)
set_approval_details(quotation6, created_at, manager)

# Seventh Quotation - Auxiliary Engine Parts
product12 = Product.create(
  name: "SUPPLY OF CONNECTING ROD BEARING",
  quantity: 12,
  unit: "sets",
  price: 28000
)

Spec.create(name: "Make", value: "Daihatsu 6DK-20", product: product12)
Spec.create(name: "Material", value: "Tri-metal", product: product12)
Spec.create(name: "Standard Size", value: "STD", product: product12)

product13 = Product.create(
  name: "SUPPLY OF PISTON RINGS",
  quantity: 24,
  unit: "sets",
  price: 15000
)

Spec.create(name: "Ring Type", value: "Chrome-Ceramic", product: product13)
Spec.create(name: "Compression Rings", value: "3 per set", product: product13)
Spec.create(name: "Oil Rings", value: "1 per set", product: product13)

# Seventh quotation
created_at = random_date_within_last_1_month
quotation7 = Quotation.create(
  company: gat,
  client: client_fsc,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. Henry Santos",
  vessel: "MV GOLDEN HORIZON",
  subject: "SUPPLY OF AUXILIARY ENGINE SPARE PARTS",
  payment: "30 days",
  duration: "45-60 DAYS",
  discount_rate: 5,
  products: [product12, product13],
  created_at: created_at,
  updated_at: created_at
)

# Eighth Quotation - Boiler Repair
product14 = Product.create(
  name: "AUXILIARY BOILER REPAIR",
  quantity: 1,
  unit: "lot",
  price: 385000
)

["INSPECTION AND ASSESSMENT",
 "TUBE NEST REMOVAL",
 "TUBE REPLACEMENT",
 "REFRACTORY REPAIR",
 "BURNER SYSTEM OVERHAUL",
 "CONTROL SYSTEM CALIBRATION",
 "HYDROSTATIC TESTING"].each do |scope_name|
  Scope.create(name: scope_name, product: product14)
end

Spec.create(name: "Boiler Type", value: "Aalborg Mission OL", product: product14)
Spec.create(name: "Capacity", value: "2.5 ton/hr", product: product14)

# Eighth quotation
created_at = random_date_within_last_1_month
quotation8 = Quotation.create(
  company: gat,
  client: client_asi,
  user: user,
  status: "rejected",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. David Lee",
  vessel: "MV ASTRO VOYAGER",
  subject: "AUXILIARY BOILER REPAIR AND MAINTENANCE",
  payment: "50% downpayment",
  duration: "20 WORKING DAYS",
  discount_rate: 0,
  products: [product14],
  created_at: created_at,
  updated_at: created_at
)

# Ninth Quotation - Steering Gear
product15 = Product.create(
  name: "STEERING GEAR SYSTEM OVERHAUL",
  quantity: 1,
  unit: "set",
  price: 275000
)

["DISMANTLING AND INSPECTION",
 "HYDRAULIC RAM RECONDITIONING",
 "TILLER ARM BEARING REPLACEMENT",
 "RUDDER STOCK INSPECTION",
 "HYDRAULIC SYSTEM FLUSHING",
 "CONTROL SYSTEM TESTING",
 "REASSEMBLY AND COMMISSIONING"].each do |scope_name|
  Scope.create(name: scope_name, product: product15)
end

# Ninth quotation
created_at = random_date_within_last_1_month
quotation9 = Quotation.create(
  company: gat,
  client: client_lsc,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Ms. Angela Torres",
  vessel: "MV EASTERN STAR",
  subject: "STEERING GEAR SYSTEM OVERHAUL",
  payment: "30 days",
  duration: "15 WORKING DAYS",
  discount_rate: 3,
  products: [product15],
  created_at: created_at,
  updated_at: created_at
)

# Tenth Quotation - Air Compressor
product16 = Product.create(
  name: "MAIN AIR COMPRESSOR OVERHAUL",
  quantity: 2,
  unit: "units",
  price: 165000
)

["DISMANTLING AND INSPECTION",
 "CYLINDER HEAD OVERHAUL",
 "PISTON AND RING REPLACEMENT",
 "CRANKSHAFT INSPECTION",
 "VALVE PLATE RECONDITIONING",
 "AIR COOLER CLEANING",
 "ASSEMBLY AND TESTING"].each do |scope_name|
  Scope.create(name: scope_name, product: product16)
end

Spec.create(name: "Make", value: "Sperre HV2/200", product: product16)
Spec.create(name: "Capacity", value: "30 m³/hr", product: product16)

# Tenth quotation
created_at = random_date_within_last_1_month
quotation10 = Quotation.create(
  company: gat,
  client: client_span,
  user: user,
  status: "approved",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. Richard Tan",
  vessel: "MV SPAN NAVIGATOR",
  subject: "MAIN AIR COMPRESSOR OVERHAUL",
  payment: "Paid",
  duration: "10 WORKING DAYS",
  discount_rate: 0,
  products: [product16],
  created_at: created_at,
  updated_at: created_at
)
set_approval_details(quotation10, created_at, manager)

# Eleventh Quotation - Purifier
product17 = Product.create(
  name: "FUEL OIL PURIFIER OVERHAUL",
  quantity: 2,
  unit: "units",
  price: 195000
)

["DISMANTLING AND INSPECTION",
 "BOWL CLEANING AND BALANCING",
 "SHAFT AND BEARING REPLACEMENT",
 "GEAR SET INSPECTION",
 "ASSEMBLY AND TESTING"].each do |scope_name|
  Scope.create(name: scope_name, product: product17)
end

Spec.create(name: "Make", value: "Alfa Laval FOPX-613", product: product17)
Spec.create(name: "Bowl Size", value: "613mm", product: product17)

# Eleventh quotation
created_at = random_date_within_last_1_month
quotation11 = Quotation.create(
  company: gat,
  client: client_asi,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. Michael Wong",
  vessel: "MV ASTRO PIONEER",
  subject: "FUEL OIL PURIFIER OVERHAUL",
  payment: "30 days",
  duration: "12 WORKING DAYS",
  discount_rate: 2,
  products: [product17],
  created_at: created_at,
  updated_at: created_at
)

# Twelfth Quotation - Generator Parts
product18 = Product.create(
  name: "SUPPLY OF GENERATOR SPARE PARTS",
  quantity: 1,
  unit: "lot",
  price: 450000
)

Spec.create(name: "Generator", value: "Daihatsu 6DK-20", product: product18)
Spec.create(name: "Power Rating", value: "750 KVA", product: product18)
Spec.create(name: "Operating Hours", value: "15000 hrs", product: product18)

product19 = Product.create(
  name: "SUPPLY OF AVR",
  quantity: 1,
  unit: "pc",
  price: 85000
)

Spec.create(name: "Type", value: "Digital", product: product19)
Spec.create(name: "Input", value: "95-264VAC", product: product19)
Spec.create(name: "Model", value: "DECS-150", product: product19)

# Twelfth quotation
created_at = random_date_within_last_1_month
quotation12 = Quotation.create(
  company: gat,
  client: client_fsc,
  user: user,
  status: "approved",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Ms. Sarah Kim",
  vessel: "MV GOLDEN CARRIER",
  subject: "SUPPLY OF GENERATOR SPARE PARTS",
  payment: "50% downpayment",
  duration: "60-75 DAYS",
  discount_rate: 0,
  products: [product18, product19],
  created_at: created_at,
  updated_at: created_at
)
set_approval_details(quotation12, created_at, manager)

# Thirteenth Quotation - Pump Repair
product20 = Product.create(
  name: "CARGO PUMP OVERHAUL",
  quantity: 2,
  unit: "sets",
  price: 235000
)

["DISMANTLING AND INSPECTION",
 "SHAFT ALIGNMENT CHECK",
 "BEARING REPLACEMENT",
 "MECHANICAL SEAL REPLACEMENT",
 "IMPELLER BALANCING",
 "ASSEMBLY AND TESTING"].each do |scope_name|
  Scope.create(name: scope_name, product: product20)
end

Spec.create(name: "Type", value: "Centrifugal", product: product20)
Spec.create(name: "Capacity", value: "500 m³/hr", product: product20)

# Thirteenth quotation
created_at = random_date_within_last_1_month
quotation13 = Quotation.create(
  company: gat,
  client: client_span,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. Peter Chang",
  vessel: "MV ASIA GLORY",
  subject: "CARGO PUMP OVERHAUL",
  payment: "30 days",
  duration: "20 WORKING DAYS",
  discount_rate: 5,
  products: [product20],
  created_at: created_at,
  updated_at: created_at
)

# Fourteenth Quotation - Heat Exchanger
product21 = Product.create(
  name: "PLATE HEAT EXCHANGER CLEANING",
  quantity: 3,
  unit: "units",
  price: 85000
)

["DISMANTLING",
 "CHEMICAL CLEANING",
 "PLATE INSPECTION",
 "GASKET REPLACEMENT",
 "ASSEMBLY AND TESTING"].each do |scope_name|
  Scope.create(name: scope_name, product: product21)
end

Spec.create(name: "Make", value: "Alfa Laval M15", product: product21)
Spec.create(name: "No. of Plates", value: "125", product: product21)

# Fourteenth quotation
created_at = random_date_within_last_1_month
quotation14 = Quotation.create(
  company: gat,
  client: client_lsc,
  user: user,
  status: "approved",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. Andrew Lim",
  vessel: "MV EASTERN VOYAGER",
  subject: "PLATE HEAT EXCHANGER MAINTENANCE",
  payment: "Paid",
  duration: "7 WORKING DAYS",
  discount_rate: 0,
  products: [product21],
  created_at: created_at,
  updated_at: created_at
)
set_approval_details(quotation14, created_at, manager)

# Fifteenth Quotation - Electrical System
product22 = Product.create(
  name: "MAIN SWITCHBOARD MAINTENANCE",
  quantity: 1,
  unit: "lot",
  price: 175000
)

["VISUAL INSPECTION",
 "THERMAL IMAGING",
 "CONTACT CLEANING",
 "PROTECTION RELAY TESTING",
 "INSULATION TESTING"].each do |scope_name|
  Scope.create(name: scope_name, product: product22)
end

product23 = Product.create(
  name: "SUPPLY OF ACB",
  quantity: 2,
  unit: "sets",
  price: 285000
)

Spec.create(name: "Rating", value: "3200A", product: product23)
Spec.create(name: "Breaking Capacity", value: "65kA", product: product23)
Spec.create(name: "Make", value: "Schneider Masterpact", product: product23)

# Fifteenth quotation
created_at = random_date_within_last_1_month
quotation15 = Quotation.create(
  company: gat,
  client: client_fsc,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Ms. Christine Reyes",
  vessel: "MV GOLDEN PRINCESS",
  subject: "ELECTRICAL SYSTEM MAINTENANCE AND UPGRADE",
  payment: "50% downpayment",
  duration: "15 WORKING DAYS",
  discount_rate: 3,
  products: [product22, product23],
  created_at: created_at,
  updated_at: created_at
)

# Sixteenth Quotation - Deck Machinery
product24 = Product.create(
  name: "MOORING WINCH OVERHAUL",
  quantity: 4,
  unit: "units",
  price: 145000
)

["DISMANTLING",
 "BRAKE SYSTEM OVERHAUL",
 "HYDRAULIC MOTOR INSPECTION",
 "BEARING REPLACEMENT",
 "ASSEMBLY AND TESTING"].each do |scope_name|
  Scope.create(name: scope_name, product: product24)
end

Spec.create(name: "Capacity", value: "15 Ton", product: product24)
Spec.create(name: "Type", value: "Hydraulic", product: product24)

# Sixteenth quotation
created_at = random_date_within_last_1_month
quotation16 = Quotation.create(
  company: gat,
  client: client_asi,
  user: user,
  status: "rejected",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. Thomas Wu",
  vessel: "MV ASTRO CHALLENGER",
  subject: "MOORING WINCH OVERHAUL",
  payment: "30 days",
  duration: "25 WORKING DAYS",
  discount_rate: 0,
  products: [product24],
  created_at: created_at,
  updated_at: created_at
)

# Seventeenth Quotation - Navigation Equipment
product25 = Product.create(
  name: "RADAR SYSTEM UPGRADE",
  quantity: 1,
  unit: "set",
  price: 650000
)

["REMOVAL OF OLD SYSTEM",
 "INSTALLATION OF NEW SYSTEM",
 "CABLE ROUTING",
 "SYSTEM INTEGRATION",
 "TESTING AND COMMISSIONING"].each do |scope_name|
  Scope.create(name: scope_name, product: product25)
end

Spec.create(name: "Make", value: "Furuno FAR-2228", product: product25)
Spec.create(name: "Band", value: "X-Band", product: product25)
Spec.create(name: "Display", value: "23.1 inch LCD", product: product25)

product26 = Product.create(
  name: "SUPPLY OF GYRO COMPASS",
  quantity: 1,
  unit: "set",
  price: 425000
)

Spec.create(name: "Make", value: "Sperry Marine", product: product26)
Spec.create(name: "Model", value: "NavigatTM X MK1", product: product26)
Spec.create(name: "Accuracy", value: "0.1 degree", product: product26)

# Eighteenth Quotation - Safety Equipment
product27 = Product.create(
  name: "SUPPLY OF BREATHING APPARATUS",
  quantity: 4,
  unit: "sets",
  price: 85000
)

Spec.create(name: "Make", value: "Dräger", product: product27)
Spec.create(name: "Model", value: "PSS 3000", product: product27)
Spec.create(name: "Cylinder Capacity", value: "6.8L/300bar", product: product27)

product28 = Product.create(
  name: "SUPPLY OF FIRE FIGHTING EQUIPMENT",
  quantity: 1,
  unit: "lot",
  price: 235000
)

Spec.create(name: "Standard", value: "SOLAS", product: product28)
Spec.create(name: "Type", value: "Complete Set", product: product28)
Spec.create(name: "Certification", value: "BV Approved", product: product28)

# Eighteenth quotation
created_at = random_date_within_last_1_month
quotation18 = Quotation.create(
  company: gat,
  client: client_span,
  user: user,
  status: "approved",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Ms. Jennifer Tan",
  vessel: "MV SPAN EXPLORER",
  subject: "SUPPLY OF SAFETY EQUIPMENT",
  payment: "30 days",
  duration: "45-60 DAYS",
  discount_rate: 0,
  products: [product27, product28],
  created_at: created_at,
  updated_at: created_at
)
set_approval_details(quotation18, created_at, manager)

# Nineteenth Quotation - Engine Room Equipment
product29 = Product.create(
  name: "SUPPLY AND INSTALLATION OF OILY WATER SEPARATOR",
  quantity: 1,
  unit: "set",
  price: 550000
)

["REMOVAL OF OLD UNIT",
 "FOUNDATION MODIFICATION",
 "INSTALLATION OF NEW UNIT",
 "PIPING MODIFICATION",
 "ELECTRICAL INSTALLATION",
 "TESTING AND COMMISSIONING",
 "CLASS CERTIFICATION"].each do |scope_name|
  Scope.create(name: scope_name, product: product29)
end

Spec.create(name: "Make", value: "RWO", product: product29)
Spec.create(name: "Capacity", value: "1.0 m³/hr", product: product29)
Spec.create(name: "Oil Content", value: "< 15 ppm", product: product29)

# Nineteenth quotation
created_at = random_date_within_last_1_month
quotation19 = Quotation.create(
  company: gat,
  client: client_fsc,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. Daniel Reyes",
  vessel: "MV GOLDEN FORTUNE",
  subject: "OILY WATER SEPARATOR REPLACEMENT",
  payment: "50% downpayment",
  duration: "20 WORKING DAYS",
  discount_rate: 5,
  products: [product29],
  created_at: created_at,
  updated_at: created_at
)

# Twentieth Quotation - Main Engine Cooling System
product30 = Product.create(
  name: "FRESH WATER COOLER RECONDITIONING",
  quantity: 2,
  unit: "units",
  price: 175000
)

["DISMANTLING AND INSPECTION",
 "TUBE BUNDLE CLEANING",
 "PRESSURE TESTING",
 "ZINC ANODE REPLACEMENT",
 "END COVER RECONDITIONING",
 "ASSEMBLY AND TESTING"].each do |scope_name|
  Scope.create(name: scope_name, product: product30)
end

Spec.create(name: "Type", value: "Shell and Tube", product: product30)
Spec.create(name: "Heat Transfer Area", value: "25 m²", product: product30)

# Twentieth quotation
created_at = random_date_within_last_1_month
quotation20 = Quotation.create(
  company: gat,
  client: client_asi,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. Jason Lee",
  vessel: "MV ASTRO WARRIOR",
  subject: "MAIN ENGINE COOLING SYSTEM MAINTENANCE",
  payment: "30 days",
  duration: "15 WORKING DAYS",
  discount_rate: 2,
  products: [product30],
  created_at: created_at,
  updated_at: created_at
)

# Twenty-First Quotation - Fuel System Components
product31 = Product.create(
  name: "SUPPLY OF FUEL INJECTION PUMP",
  quantity: 6,
  unit: "sets",
  price: 285000
)

Spec.create(name: "Make", value: "MAN B&W", product: product31)
Spec.create(name: "Type", value: "High Pressure", product: product31)
Spec.create(name: "Operating Pressure", value: "1000 bar", product: product31)

product32 = Product.create(
  name: "SUPPLY OF FUEL INJECTOR NOZZLES",
  quantity: 12,
  unit: "pcs",
  price: 45000
)

Spec.create(name: "Nozzle Type", value: "Multi-hole", product: product32)
Spec.create(name: "Hole Size", value: "0.35mm", product: product32)
Spec.create(name: "Spray Pattern", value: "8 holes", product: product32)

# Twenty-First quotation
created_at = random_date_within_last_1_month
quotation21 = Quotation.create(
  company: gat,
  client: client_span,
  user: user,
  status: "approved",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Ms. Emily Wong",
  vessel: "MV SPAN PIONEER",
  subject: "FUEL SYSTEM COMPONENTS REPLACEMENT",
  payment: "50% downpayment",
  duration: "45-60 DAYS",
  discount_rate: 3,
  products: [product31, product32],
  created_at: created_at,
  updated_at: created_at
)
set_approval_details(quotation21, created_at, manager)

# Twenty-Second Quotation - Deck Crane
product33 = Product.create(
  name: "DECK CRANE OVERHAUL",
  quantity: 2,
  unit: "units",
  price: 450000
)

["INSPECTION AND ASSESSMENT",
 "WIRE ROPE REPLACEMENT",
 "HYDRAULIC SYSTEM OVERHAUL",
 "SLEWING BEARING INSPECTION",
 "LIMIT SWITCH CALIBRATION",
 "LOAD TESTING",
 "CERTIFICATION"].each do |scope_name|
  Scope.create(name: scope_name, product: product33)
end

Spec.create(name: "Capacity", value: "25 Tons", product: product33)
Spec.create(name: "Reach", value: "22 meters", product: product33)

# Twenty-Second quotation
created_at = random_date_within_last_1_month
quotation22 = Quotation.create(
  company: gat,
  client: client_lsc,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. Kevin Tan",
  vessel: "MV EASTERN QUEEN",
  subject: "DECK CRANE MAINTENANCE",
  payment: "30 days",
  duration: "25 WORKING DAYS",
  discount_rate: 0,
  products: [product33],
  created_at: created_at,
  updated_at: created_at
)

# Twenty-Third Quotation - Engine Room Automation
product34 = Product.create(
  name: "SUPPLY AND INSTALLATION OF ENGINE MONITORING SYSTEM",
  quantity: 1,
  unit: "set",
  price: 750000
)

["REMOVAL OF OLD SYSTEM",
 "INSTALLATION OF NEW SENSORS",
 "CABLE ROUTING AND TERMINATION",
 "SOFTWARE CONFIGURATION",
 "SYSTEM INTEGRATION",
 "TESTING AND COMMISSIONING"].each do |scope_name|
  Scope.create(name: scope_name, product: product34)
end

product35 = Product.create(
  name: "SUPPLY OF ALARM MONITORING SYSTEM",
  quantity: 1,
  unit: "set",
  price: 350000
)

Spec.create(name: "Display", value: "22-inch Touch Screen", product: product35)
Spec.create(name: "Input Points", value: "256 Digital, 64 Analog", product: product35)
Spec.create(name: "Communication", value: "Modbus TCP/IP", product: product35)

product36 = Product.create(
  name: "SUPPLY OF REMOTE SENSORS",
  quantity: 25,
  unit: "pcs",
  price: 12000
)

Spec.create(name: "Type", value: "Temperature & Pressure", product: product36)
Spec.create(name: "Range", value: "-50 to 200°C, 0-16 bar", product: product36)
Spec.create(name: "Output", value: "4-20mA", product: product36)

# Twenty-Third quotation
created_at = random_date_within_last_1_month
quotation23 = Quotation.create(
  company: gat,
  client: client_fsc,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. Raymond Chen",
  vessel: "MV GOLDEN EAGLE",
  subject: "ENGINE ROOM AUTOMATION UPGRADE",
  payment: "50% downpayment",
  duration: "30 WORKING DAYS",
  discount_rate: 5,
  products: [product34, product35, product36],
  created_at: created_at,
  updated_at: created_at
)

# Twenty-Fourth Quotation - Ballast System
product37 = Product.create(
  name: "BALLAST PUMP OVERHAUL",
  quantity: 2,
  unit: "sets",
  price: 185000
)

["DISMANTLING AND INSPECTION",
 "SHAFT ALIGNMENT CHECK",
 "BEARING REPLACEMENT",
 "MECHANICAL SEAL REPLACEMENT",
 "IMPELLER BALANCING",
 "ASSEMBLY AND TESTING"].each do |scope_name|
  Scope.create(name: scope_name, product: product37)
end

Spec.create(name: "Capacity", value: "750 m³/hr", product: product37)
Spec.create(name: "Head", value: "25 meters", product: product37)

# Twenty-Fourth quotation
created_at = random_date_within_last_1_month
quotation24 = Quotation.create(
  company: gat,
  client: client_span,
  user: user,
  status: "approved",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Ms. Rachel Santos",
  vessel: "MV SPAN TRADER",
  subject: "BALLAST SYSTEM MAINTENANCE",
  payment: "30 days",
  duration: "18 WORKING DAYS",
  discount_rate: 2,
  products: [product37],
  created_at: created_at,
  updated_at: created_at
)
set_approval_details(quotation24, created_at, manager)

# Twenty-Fifth Quotation - Auxiliary Boiler Components
product38 = Product.create(
  name: "SUPPLY OF BOILER FEED PUMP",
  quantity: 2,
  unit: "sets",
  price: 165000
)

Spec.create(name: "Type", value: "Multistage Centrifugal", product: product38)
Spec.create(name: "Capacity", value: "5 m³/hr", product: product38)
Spec.create(name: "Head", value: "120 meters", product: product38)

product39 = Product.create(
  name: "SUPPLY OF BOILER CONTROL PANEL",
  quantity: 1,
  unit: "set",
  price: 285000
)

["REMOVAL OF OLD PANEL",
 "INSTALLATION OF NEW PANEL",
 "CABLE TERMINATION",
 "PARAMETER SETTING",
 "TESTING AND COMMISSIONING"].each do |scope_name|
  Scope.create(name: scope_name, product: product39)
end

# Twenty-Fifth quotation
created_at = random_date_within_last_1_month
quotation25 = Quotation.create(
  company: gat,
  client: client_asi,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. William Park",
  vessel: "MV ASTRO LEADER",
  subject: "AUXILIARY BOILER COMPONENTS UPGRADE",
  payment: "50% downpayment",
  duration: "25 WORKING DAYS",
  discount_rate: 3,
  products: [product38, product39],
  created_at: created_at,
  updated_at: created_at
)

# Twenty-Sixth Quotation - Main Engine Components
product40 = Product.create(
  name: "CYLINDER LINER HONING",
  quantity: 6,
  unit: "pcs",
  price: 85000
)

["REMOVAL AND INSPECTION",
 "SURFACE PREPARATION",
 "HONING PROCESS",
 "MEASUREMENT AND INSPECTION",
 "PRESERVATION"].each do |scope_name|
  Scope.create(name: scope_name, product: product40)
end

product41 = Product.create(
  name: "SUPPLY OF CYLINDER HEAD VALVES",
  quantity: 24,
  unit: "sets",
  price: 45000
)

Spec.create(name: "Material", value: "Nimonic 80A", product: product41)
Spec.create(name: "Size", value: "250mm", product: product41)
Spec.create(name: "Type", value: "Exhaust & Intake Set", product: product41)

# Twenty-Sixth quotation
created_at = random_date_within_last_1_month
quotation26 = Quotation.create(
  company: gat,
  client: client_lsc,
  user: user,
  status: "approved",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. George Wu",
  vessel: "MV EASTERN STAR",
  subject: "MAIN ENGINE MAINTENANCE",
  payment: "30 days",
  duration: "20 WORKING DAYS",
  discount_rate: 0,
  products: [product40, product41],
  created_at: created_at,
  updated_at: created_at
)
set_approval_details(quotation26, created_at, manager)

# Twenty-Seventh Quotation - Navigation Equipment
product42 = Product.create(
  name: "SUPPLY OF ECDIS SYSTEM",
  quantity: 1,
  unit: "set",
  price: 550000
)

["REMOVAL OF OLD SYSTEM",
 "INSTALLATION OF NEW SYSTEM",
 "SOFTWARE INSTALLATION",
 "CHART LOADING",
 "INTEGRATION WITH GPS",
 "TESTING AND CERTIFICATION"].each do |scope_name|
  Scope.create(name: scope_name, product: product42)
end

Spec.create(name: "Make", value: "Furuno FMD-3200", product: product42)
Spec.create(name: "Display", value: "24-inch LCD", product: product42)
Spec.create(name: "Type Approved", value: "IMO/SOLAS", product: product42)

# Twenty-Seventh quotation
created_at = random_date_within_last_1_month
quotation27 = Quotation.create(
  company: gat,
  client: client_fsc,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Ms. Linda Kim",
  vessel: "MV GOLDEN HORIZON",
  subject: "NAVIGATION EQUIPMENT UPGRADE",
  payment: "50% downpayment",
  duration: "15 WORKING DAYS",
  discount_rate: 2,
  products: [product42],
  created_at: created_at,
  updated_at: created_at
)

# Twenty-Eighth Quotation - Engine Room Equipment
product43 = Product.create(
  name: "SUPPLY AND INSTALLATION OF SEWAGE TREATMENT PLANT",
  quantity: 1,
  unit: "set",
  price: 650000
)

["REMOVAL OF OLD UNIT",
 "FOUNDATION MODIFICATION",
 "INSTALLATION OF NEW UNIT",
 "PIPING MODIFICATION",
 "ELECTRICAL INSTALLATION",
 "TESTING AND COMMISSIONING",
 "CLASS CERTIFICATION"].each do |scope_name|
  Scope.create(name: scope_name, product: product43)
end

Spec.create(name: "Capacity", value: "5.0 m³/day", product: product43)
Spec.create(name: "Type", value: "Biological Treatment", product: product43)
Spec.create(name: "Certification", value: "MEPC.227(64)", product: product43)

# Twenty-Eighth quotation
created_at = random_date_within_last_1_month
quotation28 = Quotation.create(
  company: gat,
  client: client_span,
  user: user,
  status: "pending",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. Alex Tan",
  vessel: "MV SPAN VOYAGER",
  subject: "SEWAGE TREATMENT PLANT REPLACEMENT",
  payment: "50% downpayment",
  duration: "25 WORKING DAYS",
  discount_rate: 0,
  products: [product43],
  created_at: created_at,
  updated_at: created_at
)

# Twenty-Ninth Quotation - Deck Equipment
product44 = Product.create(
  name: "WINDLASS OVERHAUL",
  quantity: 2,
  unit: "sets",
  price: 275000
)

["DISMANTLING AND INSPECTION",
 "GYPSY WHEEL RECONDITIONING",
 "BEARING REPLACEMENT",
 "BRAKE SYSTEM OVERHAUL",
 "HYDRAULIC MOTOR SERVICE",
 "ASSEMBLY AND TESTING"].each do |scope_name|
  Scope.create(name: scope_name, product: product44)
end

Spec.create(name: "Capacity", value: "20 Ton", product: product44)
Spec.create(name: "Chain Size", value: "76mm", product: product44)

product45 = Product.create(
  name: "SUPPLY OF ANCHOR CHAIN",
  quantity: 440,
  unit: "meters",
  price: 2200
)

Spec.create(name: "Grade", value: "U3", product: product45)
Spec.create(name: "Diameter", value: "76mm", product: product45)
Spec.create(name: "Standard", value: "IACS", product: product45)

# Twenty-Ninth quotation
created_at = random_date_within_last_1_month
quotation29 = Quotation.create(
  company: gat,
  client: client_asi,
  user: user,
  status: "approved",
  sub_total: 0,
  total: 0,
  vat: 0,
  attention: "Mr. David Chen",
  vessel: "MV ASTRO MARINER",
  subject: "ANCHOR AND WINDLASS SYSTEM MAINTENANCE",
  payment: "30 days",
  duration: "30 WORKING DAYS",
  discount_rate: 5,
  products: [product44, product45],
  created_at: created_at,
  updated_at: created_at
)
set_approval_details(quotation29, created_at, manager)
