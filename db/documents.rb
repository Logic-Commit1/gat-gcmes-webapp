# Clean up existing records first
Spec.with_deleted.each { |spec| spec.really_destroy! }
Scope.with_deleted.each { |scope| scope.really_destroy! }
Product.with_deleted.each { |product| product.really_destroy! }
Particular.with_deleted.each { |particular| particular.really_destroy! }
PurchaseOrder.with_deleted.each { |purchase_order| purchase_order.really_destroy! }
RequestForm.with_deleted.each { |request_form| request_form.really_destroy! }
Quotation.with_deleted.each { |quotation| quotation.really_destroy! }
Canvass.with_deleted.each { |canvass| canvass.really_destroy! }
Project.destroy_all

puts "\nStarting documents seeding process..."

# Load all document-related seed files in order
begin
  puts "\nStep 1: Loading quotations..."
  load File.join(Rails.root, "db", "quotations.rb")
  puts "✓ Quotations loaded successfully"
rescue => e
  puts "✗ Error loading quotations: #{e.message}"
  raise e
end

begin
  puts "\nStep 2: Loading projects..."
  load File.join(Rails.root, "db", "projects.rb")
  puts "✓ Projects loaded successfully"
rescue => e
  puts "✗ Error loading projects: #{e.message}"
  raise e
end

begin
  puts "\nStep 3: Loading canvasses..."
  load File.join(Rails.root, "db", "canvasses.rb")
  puts "✓ Canvasses loaded successfully"
rescue => e
  puts "✗ Error loading canvasses: #{e.message}"
  raise e
end

begin
  puts "\nStep 4: Loading request forms..."
  load File.join(Rails.root, "db", "request_forms.rb")
  puts "✓ Request forms loaded successfully"
rescue => e
  puts "✗ Error loading request forms: #{e.message}"
  raise e
end

begin
  puts "\nStep 5: Loading purchase orders..."
  load File.join(Rails.root, "db", "purchase_orders.rb")
  puts "✓ Purchase orders loaded successfully"
rescue => e
  puts "✗ Error loading purchase orders: #{e.message}"
  raise e
end

puts "\nDocument seeding completed successfully!"

# Display summary of created records
puts "\nSummary of created documents:"
puts "-------------------------"
puts "Quotations: #{Quotation.count}"
puts "Projects: #{Project.count}"
puts "Canvasses: #{Canvass.count}"
puts "Request Forms: #{RequestForm.count}"
puts "Purchase Orders: #{PurchaseOrder.count}"
puts "Products: #{Product.count}"
puts "Scopes: #{Scope.count}"
puts "Specs: #{Spec.count}"
puts "-------------------------"

# Verify data integrity
puts "\nVerifying data integrity..."
puts "-------------------------"
puts "Quotations with products: #{Quotation.joins(:products).distinct.count}/#{Quotation.count}"
puts "Projects with quotations: #{Project.joins(:quotations).distinct.count}/#{Project.count}"
puts "Canvasses with suppliers: #{Canvass.where.not(suppliers: nil).count}/#{Canvass.count}"
puts "Request forms with products: #{RequestForm.joins(:products).distinct.count}/#{RequestForm.count}"
puts "Purchase orders with products: #{PurchaseOrder.joins(:products).distinct.count}/#{PurchaseOrder.count}"
puts "-------------------------" 