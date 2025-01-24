Contact.destroy_all
Client.destroy_all
Supplier.destroy_all
Company.destroy_all

# Create companies
gat = Company.create!(name: "Golden Arrow Trading", code: "GAT", address: "17 San Lorenzo Sc. San Vicente, Maysilo, Malabon City, Philippines, 1477", contact_numbers: ["09123456789"], emails: ["sales@gat.com"])
gcmes = Company.create!(name: "Golden Chain Marine Engineering Services", code: "GCMES", address: "17 San Lorenzo Sc. San Vicente, Maysilo, Malabon City, Philippines, 1477", contact_numbers: ["09123456789"], emails: ["sales@gcmes.com"])

# Create client contacts
client_a_contact = Contact.create(name: "CA Contact", emails: ["sales@ca.com"], contact_numbers: ["09123456789"])
client_b_contact = Contact.create(name: "CB Contact", emails: ["sales@cb.com"], contact_numbers: ["09123456789"])
client_c_contact = Contact.create(name: "CC Contact", emails: ["sales@cc.com"], contact_numbers: ["09123456789"])
client_d_contact = Contact.create(name: "CD Contact", emails: ["sales@cd.com"], contact_numbers: ["09123456789"])
client_e_contact = Contact.create(name: "CE Contact", emails: ["sales@ce.com"], contact_numbers: ["09123456789"])

# Create supplier contacts
supplier_a_contact = Contact.create(name: "SA Contact", emails: ["sales@sa.com"], contact_numbers: ["09123456789"])
supplier_b_contact = Contact.create(name: "SB Contact", emails: ["sales@sb.com"], contact_numbers: ["09123456789"])
supplier_c_contact = Contact.create(name: "SC Contact", emails: ["sales@sc.com"], contact_numbers: ["09123456789"])
supplier_d_contact = Contact.create(name: "SD Contact", emails: ["sales@sd.com"], contact_numbers: ["09123456789"])
supplier_e_contact = Contact.create(name: "SE Contact", emails: ["sales@se.com"], contact_numbers: ["09123456789"])

# Create clients and associate with companies
# GAT clients
gat.clients.create!(name: "Client A", code: "CA", address: "123 Katipunan Avenue, Quezon City, Metro Manila", contacts: [client_a_contact])
gat.clients.create!(name: "Client B", code: "CB", address: "456 Shaw Boulevard, Mandaluyong City, Metro Manila", contacts: [client_b_contact])
gat.clients.create!(name: "Client C", code: "CC", address: "789 Ayala Avenue, Makati City, Metro Manila", contacts: [client_c_contact])

# GCMES clients  
gcmes.clients.create!(name: "Client D", code: "CD", address: "321 EDSA, Pasay City, Metro Manila", contacts: [client_d_contact])
gcmes.clients.create!(name: "Client E", code: "CE", address: "987 Taft Avenue, Manila City, Metro Manila", contacts: [client_e_contact])

# GAT suppliers
gat.suppliers.create!(name: "Supplier A", code: "SA", address: "246 Ortigas Avenue, San Juan City, Metro Manila", contacts: [supplier_a_contact])
gat.suppliers.create!(name: "Supplier B", code: "SB", address: "135 C5 Road, Taguig City, Metro Manila", contacts: [supplier_b_contact])
gat.suppliers.create!(name: "Supplier C", code: "SC", address: "864 Commonwealth Avenue, Quezon City, Metro Manila", contacts: [supplier_c_contact])

# GCMES suppliers
gcmes.suppliers.create!(name: "Supplier D", code: "SD", address: "753 Roxas Boulevard, Pasay City, Metro Manila", contacts: [supplier_d_contact])
gcmes.suppliers.create!(name: "Supplier E", code: "SE", address: "159 España Boulevard, Manila City, Metro Manila", contacts: [supplier_e_contact])