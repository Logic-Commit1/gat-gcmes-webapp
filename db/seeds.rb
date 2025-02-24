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
Project.with_deleted.each do |project|
  project.really_destroy!
end
Contact.destroy_all
Client.destroy_all
Supplier.destroy_all
Company.destroy_all
Employee.destroy_all
User.where.not(id: User.first&.id).destroy_all

# Create companies
gat = Company.create!(name: "Golden Arrow Trading", code: "GAT", address: "17 San Lorenzo Sc. San Vicente, Maysilo, Malabon City, Philippines, 1477", contact_numbers: ["09123456789"], emails: ["sales@gat.com"])
gcmes = Company.create!(name: "Golden Chain Marine Engineering Services", code: "GCMES", address: "17 San Lorenzo Sc. San Vicente, Maysilo, Malabon City, Philippines, 1477", contact_numbers: ["09123456789"], emails: ["sales@gcmes.com"])

