# Clean up existing records
RequestForm.with_deleted.each do |request_form|
  request_form.really_destroy!
end

# Get necessary records
gat = Company.find_by(code: "GAT")

user = User.find_by(email: "purchasing@goldenchain.com.ph")
manager = User.find_by(email: "manager@goldenchain.com.ph")
checker = User.find_by(email: "checker@goldenchain.com.ph")
procurer = User.find_by(email: "procurer@goldenchain.com.ph")

def set_approval_details(request_form, created_at, manager)
  request_form.update_columns(
    approved_at: created_at + 3.hours,
    approver_id: manager.id
  )
end

def random_date_within_last_month
  end_date = Time.current
  start_date = 1.month.ago
  rand(start_date..end_date)
end

def get_chosen_supplier(canvass)
  canvass.each do |category|
    category.each_value do |companies|
      companies.each do |company|
        company.each_value do |details|
          return details if details.last == true
        end
      end
    end
  end
  nil
end

# First Project - Roller Bearing
canvass1 = Canvass.find_by(description: "SUPPLY OF ROLLER BEARING")
if canvass1 && get_chosen_supplier(canvass1.suppliers).present?
  chosen_supplier = get_chosen_supplier(canvass1.suppliers)

  product1 = Product.create!(
    name: canvass1.suppliers[0].keys.first,
    quantity: canvass1.quantity,
    unit: canvass1.unit,
    price: chosen_supplier.first.to_f
  )

  created_at = random_date_within_last_month
  request_form1 = RequestForm.create!(
    company: gat,
    user: user,
    request_type: "Order",
    status: "approved",
    remarks: "Urgent requirement for MV SL ROSE anchor winch repair",
    requester: user,
    checker: checker,
    procurer: procurer,
    approver: manager,
    canvass: canvass1,
    project: canvass1.project,
    products: [product1],
    total: product1.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(request_form1, created_at, manager)
end

# Second Project - Radar System
canvass2 = Canvass.find_by(description: "SUPPLY OF RADAR SYSTEM")
if canvass2 && get_chosen_supplier(canvass2.suppliers).present?
  chosen_supplier = get_chosen_supplier(canvass2.suppliers)

  product2 = Product.create!(
    name: canvass2.suppliers[0].keys.first,
    quantity: canvass2.quantity,
    unit: canvass2.unit,
    price: chosen_supplier.first.to_f
  )

  created_at = random_date_within_last_month
  request_form2 = RequestForm.create!(
    company: gat,
    user: user,
    request_type: "Order",
    status: "approved",
    remarks: "Required for MV SPAN ASIA navigation system upgrade",
    requester: user,
    checker: checker,
    procurer: procurer,
    approver: manager,
    canvass: canvass2,
    project: canvass2.project,
    products: [product2],
    total: product2.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(request_form2, created_at, manager)
end

# Fresh Water Cooler
canvass3 = Canvass.find_by(description: "FRESH WATER COOLER RECONDITIONING")
if canvass3 && get_chosen_supplier(canvass3.suppliers).present?
  chosen_supplier = get_chosen_supplier(canvass3.suppliers)

  product3 = Product.create!(
    name: canvass3.suppliers[0].keys.first,
    quantity: canvass3.quantity,
    unit: canvass3.unit,
    price: chosen_supplier.first.to_f
  )

  created_at = random_date_within_last_month
  request_form3 = RequestForm.create!(
    company: gat,
    user: user,
    request_type: "Order",
    status: "approved",
    remarks: "Critical maintenance for MV ASTRO WARRIOR main engine cooling system",
    requester: user,
    checker: checker,
    procurer: procurer,
    approver: manager,
    canvass: canvass3,
    project: canvass3.project,
    products: [product3],
    total: product3.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(request_form3, created_at, manager)
end

# Deck Crane Overhaul
canvass4 = Canvass.find_by(description: "DECK CRANE OVERHAUL")
if canvass4 && get_chosen_supplier(canvass4.suppliers).present?
  chosen_supplier = get_chosen_supplier(canvass4.suppliers)

  product4 = Product.create!(
    name: canvass4.suppliers[0].keys.first,
    quantity: canvass4.quantity,
    unit: canvass4.unit,
    price: chosen_supplier.first.to_f
  )

  created_at = random_date_within_last_month
  request_form4 = RequestForm.create!(
    company: gat,
    user: user,
    request_type: "Order",
    status: "approved",
    remarks: "Scheduled maintenance for MV EASTERN QUEEN deck cranes",
    requester: user,
    checker: checker,
    procurer: procurer,
    approver: manager,
    canvass: canvass4,
    project: canvass4.project,
    products: [product4],
    total: product4.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(request_form4, created_at, manager)
end

# Engine Monitoring System
canvass5 = Canvass.find_by(description: "SUPPLY AND INSTALLATION OF ENGINE MONITORING SYSTEM")
if canvass5 && get_chosen_supplier(canvass5.suppliers).present?
  chosen_supplier = get_chosen_supplier(canvass5.suppliers)

  product5 = Product.create!(
    name: canvass5.suppliers[0].keys.first,
    quantity: canvass5.quantity,
    unit: canvass5.unit,
    price: chosen_supplier.first.to_f
  )

  created_at = random_date_within_last_month
  request_form5 = RequestForm.create!(
    company: gat,
    user: user,
    request_type: "Order",
    status: "approved",
    remarks: "System upgrade for MV GOLDEN EAGLE engine room automation",
    requester: user,
    checker: checker,
    procurer: procurer,
    approver: manager,
    canvass: canvass5,
    project: canvass5.project,
    products: [product5],
    total: product5.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(request_form5, created_at, manager)
end

# Ballast Pump
canvass6 = Canvass.find_by(description: "BALLAST PUMP OVERHAUL")
if canvass6 && get_chosen_supplier(canvass6.suppliers).present?
  chosen_supplier = get_chosen_supplier(canvass6.suppliers)

  product6 = Product.create!(
    name: canvass6.suppliers[0].keys.first,
    quantity: canvass6.quantity,
    unit: canvass6.unit,
    price: chosen_supplier.first.to_f
  )

  created_at = random_date_within_last_month
  request_form6 = RequestForm.create!(
    company: gat,
    user: user,
    request_type: "Order",
    status: "approved",
    remarks: "Required maintenance for MV SPAN TRADER ballast system",
    requester: user,
    checker: checker,
    procurer: procurer,
    approver: manager,
    canvass: canvass6,
    project: canvass6.project,
    products: [product6],
    total: product6.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(request_form6, created_at, manager)
end

# Boiler Feed Pump
canvass7 = Canvass.find_by(description: "SUPPLY OF BOILER FEED PUMP")
if canvass7 && get_chosen_supplier(canvass7.suppliers).present?
  chosen_supplier = get_chosen_supplier(canvass7.suppliers)

  product7 = Product.create!(
    name: canvass7.suppliers[0].keys.first,
    quantity: canvass7.quantity,
    unit: canvass7.unit,
    price: chosen_supplier.first.to_f
  )

  created_at = random_date_within_last_month
  request_form7 = RequestForm.create!(
    company: gat,
    user: user,
    request_type: "Order",
    status: "approved",
    remarks: "Replacement for MV ASTRO LEADER auxiliary boiler system",
    requester: user,
    checker: checker,
    procurer: procurer,
    approver: manager,
    canvass: canvass7,
    project: canvass7.project,
    products: [product7],
    total: product7.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(request_form7, created_at, manager)
end

# ECDIS System
canvass8 = Canvass.find_by(description: "SUPPLY OF ECDIS SYSTEM")
if canvass8 && get_chosen_supplier(canvass8.suppliers).present?
  chosen_supplier = get_chosen_supplier(canvass8.suppliers)

  product8 = Product.create!(
    name: canvass8.suppliers[0].keys.first,
    quantity: canvass8.quantity,
    unit: canvass8.unit,
    price: chosen_supplier.first.to_f
  )

  created_at = random_date_within_last_month
  request_form8 = RequestForm.create!(
    company: gat,
    user: user,
    request_type: "Order",
    status: "approved",
    remarks: "Required upgrade for MV GOLDEN HORIZON navigation system compliance",
    requester: user,
    checker: checker,
    procurer: procurer,
    approver: manager,
    canvass: canvass8,
    project: canvass8.project,
    products: [product8],
    total: product8.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(request_form8, created_at, manager)
end

# Alarm Monitoring System
canvass9 = Canvass.find_by(description: "SUPPLY OF ALARM MONITORING SYSTEM")
if canvass9 && get_chosen_supplier(canvass9.suppliers).present?
  chosen_supplier = get_chosen_supplier(canvass9.suppliers)

  product9 = Product.create!(
    name: canvass9.suppliers[0].keys.first,
    quantity: canvass9.quantity,
    unit: canvass9.unit,
    price: chosen_supplier.first.to_f
  )

  created_at = random_date_within_last_month
  request_form9 = RequestForm.create!(
    company: gat,
    user: user,
    request_type: "Order",
    status: "approved",
    remarks: "Enhancement of MV GOLDEN EAGLE engine room monitoring capabilities",
    requester: user,
    checker: checker,
    procurer: procurer,
    approver: manager,
    canvass: canvass9,
    project: canvass9.project,
    products: [product9],
    total: product9.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(request_form9, created_at, manager)
end

# Sewage Treatment Plant
canvass10 = Canvass.find_by(description: "SUPPLY AND INSTALLATION OF SEWAGE TREATMENT PLANT")
if canvass10 && get_chosen_supplier(canvass10.suppliers).present?
  chosen_supplier = get_chosen_supplier(canvass10.suppliers)

  product10 = Product.create!(
    name: canvass10.suppliers[0].keys.first,
    quantity: canvass10.quantity,
    unit: canvass10.unit,
    price: chosen_supplier.first.to_f
  )

  created_at = random_date_within_last_month
  request_form10 = RequestForm.create!(
    company: gat,
    user: user,
    request_type: "Order",
    status: "approved",
    requester: user,
    checker: checker,
    procurer: procurer,
    approver: manager,
    canvass: canvass10,
    project: canvass10.project,
    products: [product10],
    total: product10.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(request_form10, created_at, manager)
end

