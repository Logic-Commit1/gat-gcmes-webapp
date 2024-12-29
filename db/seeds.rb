# Clean up existing records in the correct order
puts "Cleaning up existing records..."
RequestForm.destroy_all
PurchaseOrder.destroy_all
Quotation.destroy_all
Canvass.destroy_all
Product.destroy_all

# Create sample companies if none exist
unless Company.exists?
  puts "Creating companies..."
  3.times do |i|
    Company.create!(
      name: "Company #{i + 1}",
      code: "COM#{i + 1}",
      address: "123 Business St, City #{i + 1}",
      tin: 123456789 + i,
      contact_numbers: ["+1234567890", "+0987654321"],
      emails: ["info@company#{i+1}.com", "contact@company#{i+1}.com"]
    )
  end
end

# Create sample clients if none exist
unless Client.exists?
  puts "Creating clients..."
  5.times do |i|
    Client.create!(
      name: "Client #{i + 1}",
      code: "CLT#{i + 1}",
      address: "456 Client Ave, City #{i + 1}",
      partner: "John Partner #{i + 1}",
      tin: 987654321 + i,
      company: Company.all.sample
    )
  end
end

# Create sample suppliers if none exist
unless Supplier.exists?
  puts "Creating suppliers..."
  5.times do |i|
    Supplier.create!(
      name: "Supplier #{i + 1}",
      code: "SUP#{i + 1}",
      address: "789 Supplier St, City #{i + 1}",
      tin: "123-456-789-00#{i}",
      company: Company.all.sample
    )
  end
end

# Create sample projects if none exist
unless Project.exists?
  puts "Creating projects..."
  10.times do |i|
    Project.create!(
      client: Client.all.sample,
      company: Company.all.sample,
      status: Project.statuses.keys.sample,
      amount: rand(10000..100000),
      payment: rand(0..2),
      po_number: "PO-#{Time.current.year}-#{(i + 1).to_s.rjust(4, '0')}"
    )
  end
end

puts "Creating quotations..."
# Create Quotations
15.times do |i|
  project = Project.all.sample
  quotation = Quotation.create!(
    client: project.client,
    company: project.company,
    project: project,
    attention: "Attn: Manager #{i + 1}",
    vessel: ["Vessel A", "Vessel B", "Vessel C"].sample,
    subject: "Equipment Supply #{i + 1}",
    remarks: "Priority delivery required",
    payment: Quotation.payments.keys.sample,
    lead_time: "#{rand(1..4)} weeks",
    warranty: "#{rand(6..24)} months standard warranty",
    discount_rate: rand(0..10),
    status: Quotation.statuses.keys.sample,
    preparer: "John Preparer",
    approver: "Jane Approver"
  )

  # Add products to quotation
  rand(2..5).times do |j|
    product = quotation.products.create!(
      name: "Product #{j + 1} for Quotation #{i + 1}",
      quantity: rand(1..10),
      unit: ["pcs", "sets", "units"].sample,
      price: rand(1000..5000),
      brand: ["Brand A", "Brand B", "Brand C"].sample,
      description: "High quality product",
      terms: "Standard terms apply",
      remarks: "Quality guaranteed"
    )

    # Add specs to product
    product.specs.create!([
      { name: "Size", value: "#{rand(10..100)}cm" },
      { name: "Weight", value: "#{rand(1..50)}kg" }
    ])
  end
end

puts "Creating canvasses..."
# Create Canvasses
12.times do |i|
  project = Project.all.sample
  canvass = Canvass.create!(
    company: project.company,
    project: project,
    description: "Equipment Canvass #{i + 1}",
    quantity: rand(1..20),
    unit: ["pcs", "sets", "units"].sample,
    status: Canvass.statuses.keys.sample,
    suppliers: Supplier.all.sample(3).map { |s| { id: s.id, name: s.name } }
  )

  # Add products to canvass
  rand(2..4).times do |j|
    product = canvass.products.create!(
      name: "Product #{j + 1} for Canvass #{i + 1}",
      quantity: rand(1..10),
      unit: ["pcs", "sets", "units"].sample,
      price: rand(1000..5000),
      brand: ["Brand X", "Brand Y", "Brand Z"].sample,
      description: "Standard quality product"
    )

    # Add specs to product
    product.specs.create!([
      { name: "Color", value: ["Red", "Blue", "Green"].sample },
      { name: "Material", value: ["Steel", "Aluminum", "Plastic"].sample }
    ])
  end
end

puts "Creating request forms..."
# Create Request Forms
15.times do |i|
  project = Project.all.sample
  request_type = RequestForm.request_types.keys.sample
  
  request_form = RequestForm.create!(
    company: project.company,
    project: project,
    request_type: request_type,
    vehicle: request_type == 'Allowance' ? "Vehicle #{i + 1}" : nil,
    destination: request_type == 'Allowance' ? "Location #{i + 1}" : nil,
    remarks: "Standard request #{i + 1}",
    fuel_gauge: request_type == 'Allowance' ? "#{rand(1..100)}%" : nil,
    easy_trip_balance: request_type == 'Allowance' ? rand(100..1000) : nil,
    sweep_balance: request_type == 'Allowance' ? rand(100..1000) : nil,
    requester: "John Requester",
    checker: "Jane Checker",
    procurer: "Bob Procurer",
    pre_approver: "Alice Pre-approver",
    approver: "Dave Approver",
    quotation: request_type == 'Order' ? Quotation.all.sample : nil,
    canvass: request_type == 'Order' ? Canvass.all.sample : nil,
    status: RequestForm.statuses.keys.sample,
    start_travel_date: request_type == 'Allowance' ? Time.current + rand(1..10).days : nil,
    end_travel_date: request_type == 'Allowance' ? Time.current + rand(11..20).days : nil
  )

  if request_type == 'Allowance'
    rand(1..3).times do |j|
      request_form.particulars.create!(
        name: "Allowance Item #{j + 1}",
        allowance: rand(100..1000),
        remarks: "Standard allowance remarks"
      )
    end
  else
    rand(2..4).times do |j|
      product = request_form.products.create!(
        name: "Product #{j + 1} for RF #{i + 1}",
        quantity: rand(1..10),
        unit: ["pcs", "sets", "units"].sample,
        price: rand(1000..5000),
        brand: ["Brand P", "Brand Q", "Brand R"].sample,
        description: "Quality product"
      )

      # Add specs to product
      product.specs.create!([
        { name: "Feature", value: "Feature #{j + 1}" },
        { name: "Rating", value: "#{rand(1..5)} stars" }
      ])
    end
  end
end

puts "Creating purchase orders..."
# Create Purchase Orders
10.times do |i|
  project = Project.all.sample
  request_form = RequestForm.where(request_type: 'Order').sample
  
  purchase_order = PurchaseOrder.create!(
    company: project.company,
    project: project,
    supplier: Supplier.all.sample,
    request_form: request_form,
    terms: PurchaseOrder.terms.keys.sample,
    discount: rand(0..10),
    preparer: "John Preparer",
    requester: "Jane Requester",
    checker: "Bob Checker",
    pre_approver: "Alice Pre-approver",
    approver: "Dave Approver",
    status: PurchaseOrder.statuses.keys.sample
  )

  # Add products to purchase order
  rand(2..4).times do |j|
    product = purchase_order.products.create!(
      name: "Product #{j + 1} for PO #{i + 1}",
      quantity: rand(1..10),
      unit: ["pcs", "sets", "units"].sample,
      price: rand(1000..5000),
      brand: ["Brand M", "Brand N", "Brand O"].sample,
      description: "Standard product"
    )

    # Add specs to product
    product.specs.create!([
      { name: "Dimension", value: "#{rand(10..100)}x#{rand(10..100)}cm" },
      { name: "Warranty", value: "#{rand(6..24)} months" }
    ])
  end
end

puts "Seed data created successfully!"
puts "Created:"
puts "- #{Quotation.count} Quotations"
puts "- #{Canvass.count} Canvasses"
puts "- #{RequestForm.count} Request Forms"
puts "- #{PurchaseOrder.count} Purchase Orders"