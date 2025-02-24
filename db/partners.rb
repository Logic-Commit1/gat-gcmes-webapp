gat = Company.find_by(code: "GAT")
gcmes = Company.find_by(code: "GCMES")

# Create client contacts
client_a_contact = Contact.create(name: "NCSMC Contact", emails: ["sales@ncsmc.com"], contact_numbers: ["09123456789"])
client_b_contact = Contact.create(name: "FSC Contact", emails: ["sales@fsc.com"], contact_numbers: ["09123456789"])
client_c_contact = Contact.create(name: "ASI Contact", emails: ["sales@asi.com"], contact_numbers: ["09123456789"])
client_d_contact = Contact.create(name: "SPAN Contact", emails: ["sales@span.com"], contact_numbers: ["09123456789"])
client_e_contact = Contact.create(name: "LSC Contact", emails: ["sales@lsc.com"], contact_numbers: ["09123456789"])

# Create supplier contacts
supplier_a_contact = Contact.create(name: "NCSMC Contact", emails: ["sales@ncsmc.com"], contact_numbers: ["09123456789"])
supplier_b_contact = Contact.create(name: "FSC Contact", emails: ["sales@fsc.com"], contact_numbers: ["09123456789"])
supplier_c_contact = Contact.create(name: "ASI Contact", emails: ["sales@asi.com"], contact_numbers: ["09123456789"])
supplier_d_contact = Contact.create(name: "SPAN Contact", emails: ["sales@span.com"], contact_numbers: ["09123456789"])
supplier_e_contact = Contact.create(name: "LSC Contact", emails: ["sales@lsc.com"], contact_numbers: ["09123456789"])

# Create clients and associate with companies
# GAT clients
gat.clients.create!(name: "NARRA CREWING AND SHIP MANAGEMENT CORPORATION", code: "NCSMC", address: "3rd Flr. VIP BLDG. 1140 ROXAS BLVD Cor., NUESTRA SRA. DE GULA, Brgt. 667 Zone 072, ERMITA MANILA. MM", contacts: [client_a_contact])
gat.clients.create!(name: "FRABELLE SHIPYARD CORPORATION", code: "FSC", address: "456 Shaw Boulevard, Mandaluyong City, Metro Manila", contacts: [client_b_contact])
gat.clients.create!(name: "ASTRO SHIPMANAGEMENT INC.", code: "ASI", address: "789 Ayala Avenue, Makati City, Metro Manila", contacts: [client_c_contact])

# GCMES clients  
gcmes.clients.create!(name: "PHILIPPINE SPAN ASIA CARRIER CORP.", code: "SPAN", address: "321 EDSA, Pasay City, Metro Manila", contacts: [client_d_contact])
gcmes.clients.create!(name: "LORENZO SHIPPING CORPORATION", code: "LSC", address: "987 Taft Avenue, Manila City, Metro Manila", contacts: [client_e_contact])

# GAT suppliers
gat.suppliers.create!(name: "NARRA CREWING AND SHIP MANAGEMENT CORPORATION", code: "NCSMC", address: "246 Ortigas Avenue, San Juan City, Metro Manila", contacts: [supplier_a_contact])
gat.suppliers.create!(name: "FRABELLE SHIPYARD CORPORATION", code: "FSC", address: "135 C5 Road, Taguig City, Metro Manila", contacts: [supplier_b_contact])
gat.suppliers.create!(name: "ASTRO SHIPMANAGEMENT INC.", code: "ASI", address: "864 Commonwealth Avenue, Quezon City, Metro Manila", contacts: [supplier_c_contact])

# GCMES suppliers
gcmes.suppliers.create!(name: "PHILIPPINE SPAN ASIA CARRIER CORP.", code: "SPAN", address: "753 Roxas Boulevard, Pasay City, Metro Manila", contacts: [supplier_d_contact])
gcmes.suppliers.create!(name: "LORENZO SHIPPING CORPORATION", code: "LSC", address: "159 España Boulevard, Manila City, Metro Manila", contacts: [supplier_e_contact])
