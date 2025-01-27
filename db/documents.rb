Particular.destroy_all
Product.destroy_all
RequestForm.destroy_all
PurchaseOrder.destroy_all
Quotation.destroy_all
Canvass.destroy_all
Project.destroy_all

gat = Company.find_by(code: "GAT")
gcmes = Company.find_by(code: "GCMES")

client_a = Client.find_by(name: "Client A")
client_b = Client.find_by(name: "Client B")
client_c = Client.find_by(name: "Client C")
client_d = Client.find_by(name: "Client D")
client_e = Client.find_by(name: "Client E")

supplier_a = Supplier.find_by(name: "Supplier A")
supplier_b = Supplier.find_by(name: "Supplier B")
supplier_c = Supplier.find_by(name: "Supplier C")
supplier_d = Supplier.find_by(name: "Supplier D")
supplier_e = Supplier.find_by(name: "Supplier E")

user = User.first

# Create Projects first
project_a = Project.create(client: client_a, po_number: "123456", amount: 10000, payment: '50% downpayment', company_id: gat.id, user_id: user.id)
project_b = Project.create(client: client_b, po_number: "123457", amount: 20000, payment: 'Paid', company_id: gat.id, user_id: user.id)
project_c = Project.create(client: client_c, po_number: "123458", amount: 30000, payment: '30 days', company_id: gat.id, user_id: user.id)
project_d = Project.create(client: client_d, po_number: "123459", amount: 40000, payment: '50% downpayment', company_id: gcmes.id, user_id: user.id)
project_e = Project.create(client: client_e, po_number: "123460", amount: 50000, payment: '30 days', company_id: gcmes.id, user_id: user.id)

# Create Specs
engine_bearing_specs = [
  Spec.create(name: "Size", value: "80mm"),
  Spec.create(name: "Material", value: "Steel")
]

oil_filter_specs = [
  Spec.create(name: "Type", value: "Spin-on"),
  Spec.create(name: "Micron", value: "10")
]

tool_set_specs = [
  Spec.create(name: "Pieces", value: "150"),
  Spec.create(name: "Case", value: "Metal box")
]

# Create Products and associate with quotations
product_a = Product.create(
  name: "Engine Bearing",
  quantity: 4,
  unit: "pcs",
  price: 1500.00,
  brand: "SKF",
  description: "Heavy duty engine bearing",
  specs: engine_bearing_specs,
  terms: "30 days warranty",
  remarks: "Original parts",
  # quotation: quotation_a,
  supplier: supplier_a,
  total: 6000.00
)

product_b = Product.create(
  name: "Oil Filter",
  quantity: 10,
  unit: "pcs",
  price: 250.00,
  brand: "Fleetguard",
  description: "High efficiency oil filter",
  specs: oil_filter_specs,
  terms: "Replacement warranty",
  # quotation: quotation_a,
  supplier: supplier_a,
  total: 2500.00
)

product_c = Product.create(
  name: "Tool Set",
  quantity: 2,
  unit: "pcs",
  price: 3500.00,
  brand: "Stanley",
  description: "Complete mechanical tool set",
  specs: tool_set_specs,
  # quotation: quotation_b,
  supplier: supplier_c,
  total: 7000.00
)

# Create Quotations before Products
quotation_a = Quotation.create(
  client: client_a,
  company: gat,
  quotation_type: 'supply',
  project: project_a,
  attention: "Mr. John Smith",
  vessel: "MV Pacific",
  subject: "Engine Parts Supply",
  remarks: "Urgent delivery needed",
  payment: 0,
  lead_time: "2-3 weeks",
  warranty: "1 year standard warranty",
  vat: 1200.00,
  additional_conditions: "Subject to availability",
  preparer: "Jane Doe",
  user: user,
  products: [product_a, product_b]
)

quotation_b = Quotation.create(
  client: client_b,
  company: gcmes,
  quotation_type: 'supply',
  project: project_b,
  attention: "Ms. Sarah Johnson",
  vessel: "MV Atlantic",
  subject: "Maintenance Tools",
  payment: 1,
  lead_time: "1 week",
  warranty: "6 months warranty",
  vat: 800.00,
  user: user,
  products: [product_c]
)

quotation_c = Quotation.create(
  client: client_c,
  company: gat,
  quotation_type: 'service_and_supply',
  project: project_c,
  attention: "Mr. John Smith",
  vessel: "MV Pacific",
  subject: "Engine Parts Supply",
  remarks: "Urgent delivery needed",
  payment: 0,
  lead_time: "2-3 weeks",
  warranty: "1 year standard warranty",
  vat: 1200.00,
  user: user,
  products: [product_a, product_b]
)
quotation_d = Quotation.create(
  client: client_d,
  company: gat,
  quotation_type: 'supply',
  project: project_d,
  user: user,
  products: [product_a, product_b]
)

# Create Canvasses
canvass_a = Canvass.create(
  company: gat,
  project: project_a,
  description: "Engine parts",
  quantity: 10,
  unit: "pcs",
  user: user,
  skip_suppliers_callback: true,
  suppliers: [
    {
      "Engine parts" => [
        { "Supplier A" => ["20000.0", "SKF", "2 days", "Original parts with warranty"] },
        { "Supplier B" => ["25000.0", "FleetGuard", "5 days", "Includes free installation"] },
        { "Supplier C" => ["30000.0", "Donaldson", "7 days", "Bulk order discount available"] },
        { "Supplier D" => ["28000.0", "Timken", "4 days", "Extended warranty available"] },
        { "Supplier E" => ["22000.0", "FAG", "3 days", "Fast delivery guaranteed"] }
      ]
    }
  ]
)

canvass_b = Canvass.create(
  company: gcmes,
  project: project_b,
  description: "Tool sets", 
  quantity: 5,
  unit: "boxes",
  user: user,
  skip_suppliers_callback: true,
  suppliers: [
    {
      "Tool sets" => [
        { "Supplier C" => ["15000.0", "Stanley", "3 days", "High quality tools"] },
        { "Supplier D" => ["17000.0", "DeWalt", "4 days", "Premium grade"] },
        { "Supplier E" => ["13000.0", "Bosch", "5 days", "Standard quality"] },
        { "Supplier F" => ["14500.0", "Makita", "3 days", "Includes carrying case"] },
        { "Supplier G" => ["16000.0", "Milwaukee", "4 days", "Professional grade tools"] }
      ]
    }
  ]
)

# Create Particulars
particular_a = Particular.create(
  name: "Transportation",
  allowance: 1000.00,
  remarks: "Local delivery"
)

particular_b = Particular.create(
  name: "Installation",
  allowance: 2500.00,
  remarks: "Including basic setup"
)

RequestForm.create(
  company: project_a.company,
  project: project_a,
  user: user,
  request_type: 'Allowance',
  particulars: [particular_a, particular_b],
  start_travel_date: Date.today,
  end_travel_date: Date.today + 1,
  destination: "Manila",
  vehicle: "Hilux",
)

RequestForm.create(
  company: project_a.company,
  project: project_a,
  user: user,
  request_type: 'Order',
  canvass: canvass_a,
  quotation: quotation_a,
  products: [product_a, product_b]
)

PurchaseOrder.create(
  company: project_a.company,
  project: project_a,
  user: user,
  supplier: supplier_a,
  products: [product_a, product_b],
  terms: '30 days',
)
