# Clean up existing records
PurchaseOrder.with_deleted.each do |purchase_order|
  purchase_order.really_destroy!
end

# Get necessary records
gat = Company.find_by(code: "GAT")
gcmes = Company.find_by(code: "GCMES")

supplier_ncs = Supplier.find_by(code: "NCS")
supplier_fsc = Supplier.find_by(code: "FSC")
supplier_asi = Supplier.find_by(code: "ASI")
supplier_span = Supplier.find_by(code: "SPAN")
supplier_lsc = Supplier.find_by(code: "LSC")

user = User.find_by(email: "purchasing@goldenchain.com.ph")
manager = User.find_by(email: "manager@goldenchain.com.ph")

def set_approval_details(purchase_order, created_at, manager)
  purchase_order.update_columns(
    approved_at: created_at + 3.hours,
    approver_id: manager.id
  )
end

def generate_uid(prefix)
  timestamp = Time.current.strftime("%y%m")
  sequence = format('%04d', PurchaseOrder.count + 1)
  "#{prefix}-#{timestamp}-#{sequence}"
end

# First Project - Anchor Winch Spur and Pinion Gear
request_form1 = RequestForm.find_by(remarks: "Urgent requirement for MV SL ROSE anchor winch repair")
if request_form1.present?
  created_at = request_form1.created_at + 1.day
  purchase_order1 = PurchaseOrder.create!(
    company: request_form1.company,
    supplier: supplier_lsc,
    project: request_form1.project,
    user: user,
    terms: "50% downpayment",
    remarks: "Please ensure proper packaging and material certifications",
    request_form: request_form1,
    products: request_form1.products,
    total: request_form1.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(purchase_order1, created_at, manager)
end

# Second Project - Engine Overhaul
request_form2 = RequestForm.find_by(remarks: "Required for MV SPAN ASIA navigation system upgrade")
if request_form2.present?
  created_at = request_form2.created_at + 1.day
  purchase_order2 = PurchaseOrder.create!(
    company: request_form2.company,
    supplier: supplier_span,
    project: request_form2.project,
    user: user,
    terms: "50% downpayment",
    remarks: "Include installation, commissioning, and OEM certificates",
    request_form: request_form2,
    products: request_form2.products,
    total: request_form2.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(purchase_order2, created_at, manager)
end

# Third Project - Safety Equipment
request_form3 = RequestForm.find_by(remarks: "Critical maintenance for MV ASTRO WARRIOR main engine cooling system")
if request_form3.present?
  created_at = request_form3.created_at + 1.day
  purchase_order3 = PurchaseOrder.create!(
    company: request_form3.company,
    supplier: supplier_span,
    project: request_form3.project,
    user: user,
    terms: "30 days",
    remarks: "Include certificates of conformity and manuals",
    request_form: request_form3,
    products: request_form3.products,
    total: request_form3.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(purchase_order3, created_at, manager)
end

# Fourth Project - Propulsion System
request_form4 = RequestForm.find_by(remarks: "Scheduled maintenance for MV EASTERN QUEEN deck cranes")
if request_form4.present?
  created_at = request_form4.created_at + 1.day
  purchase_order4 = PurchaseOrder.create!(
    company: request_form4.company,
    supplier: supplier_span,
    project: request_form4.project,
    user: user,
    terms: "50% downpayment",
    remarks: "Include balancing reports and material certificates",
    request_form: request_form4,
    products: request_form4.products,
    total: request_form4.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(purchase_order4, created_at, manager)
end

# Fifth Project - Engine Cooling System
request_form5 = RequestForm.find_by(remarks: "System upgrade for MV GOLDEN EAGLE engine room automation")
if request_form5.present?
  created_at = request_form5.created_at + 1.day
  purchase_order5 = PurchaseOrder.create!(
    company: request_form5.company,
    supplier: supplier_asi,
    user: user,
    project: request_form5.project,
    terms: "50% downpayment",
    remarks: "Include pressure testing and commissioning reports",
    request_form: request_form5,
    products: request_form5.products,
    total: request_form5.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(purchase_order5, created_at, manager)
end

# Sixth Project - Deck Equipment
request_form6 = RequestForm.find_by(remarks: "Required maintenance for MV SPAN TRADER ballast system")
if request_form6.present?
  created_at = request_form6.created_at + 1.day
  purchase_order6 = PurchaseOrder.create!(
    company: request_form6.company,
    supplier: supplier_lsc,
    user: user,
    project: request_form6.project,
    terms: "30 days",
    remarks: "Include load test certificates and inspection reports",
    request_form: request_form6,
    products: request_form6.products,
    total: request_form6.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(purchase_order6, created_at, manager)
end

# Seventh Project - Engine Room Automation
request_form7 = RequestForm.find_by(remarks: "Replacement for MV ASTRO LEADER auxiliary boiler system")
if request_form7.present?
  created_at = request_form7.created_at + 1.day
  purchase_order7 = PurchaseOrder.create!(
    company: request_form7.company,
    supplier: supplier_fsc,
    user: user,
    project: request_form7.project,
    terms: "50% downpayment",
    remarks: "Include software licenses and system documentation",
    request_form: request_form7,
    products: request_form7.products,
    total: request_form7.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(purchase_order7, created_at, manager)
end

# Eighth Project - Water Management Systems
request_form8 = RequestForm.find_by(remarks: "Required upgrade for MV GOLDEN HORIZON navigation system compliance")
if request_form8.present?
  created_at = request_form8.created_at + 1.day
  purchase_order8 = PurchaseOrder.create!(
    company: request_form8.company,
    supplier: supplier_fsc,
    user: user,
    project: request_form8.project,
    terms: "50% downpayment",
    remarks: "Include commissioning and crew familiarization",
    request_form: request_form8,
    products: request_form8.products,
    total: request_form8.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(purchase_order8, created_at, manager)
end

# Ninth Project - Auxiliary Systems
request_form9 = RequestForm.find_by(remarks: "Enhancement of MV GOLDEN EAGLE engine room monitoring capabilities")
if request_form9.present?
  created_at = request_form9.created_at + 1.day
  purchase_order9 = PurchaseOrder.create!(
    company: request_form9.company,
    supplier: supplier_asi,
    user: user,
    project: request_form9.project,
    terms: "30 days",
    remarks: "Include material certificates and testing procedures",
    request_form: request_form9,
    products: request_form9.products,
    total: request_form9.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(purchase_order9, created_at, manager)
end

# Tenth Project - Navigation Systems
request_form10 = RequestForm.find_by(remarks: "Environmental compliance upgrade for MV SPAN VOYAGER")
if request_form10.present?
  created_at = request_form10.created_at + 1.day
  purchase_order10 = PurchaseOrder.create!(
    company: request_form10.company,
    supplier: supplier_fsc,
    user: user,
    project: request_form10.project,
    terms: "50% downpayment",
    remarks: "Include type approval certificates and training",
    request_form: request_form10,
    products: request_form10.products,
    total: request_form10.total,
    created_at: created_at,
    updated_at: created_at
  )
  set_approval_details(purchase_order10, created_at, manager)
end
