# Client.destroy_all

Client.create!([
  {
    id: 1,
    name: "Philippine Span Asia Carrier Corporation",
    code: "PSACC",
    address: "123 test street, test brgy, Malabon City 1400",
    partner: "GAT",
    tin: 12345678912345,
    created_at: "2024-08-20 09:49:00.995574000 +0000",
    updated_at: "2024-08-21 06:43:25.004045000 +0000",
    company_id: 1
  },
  {
    id: 2,
    name: "Narra Crewing and Shipmanagement Corporation",
    code: "NCSMC",
    address: "3rd Flr. NIP BLDG. 1140 ROXAS BLVD Cor., NUESTRA S...",
    partner: "GAT",
    tin: nil,
    created_at: "2024-08-20 17:44:49.398798000 +0000",
    updated_at: "2024-08-21 06:43:30.573082000 +0000",
    company_id: 1
  },
  {
    id: 3,
    name: "Nmc Container Lines, Inc.",
    code: "NMC",
    address: "21st Floor Times Plaza Building United Nations cor...",
    partner: "GCMES",
    tin: nil,
    created_at: "2024-08-21 06:03:06.057894000 +0000",
    updated_at: "2024-12-29 08:15:24.394907000 +0000",
    company_id: 2
  },
  {
    id: 4,
    name: "Lorenzo Shipping Corporation",
    code: "LSC",
    address: "1090 Virgo Dr, Navotas, Metro Manila",
    partner: "GCMES",
    tin: nil,
    created_at: "2024-08-21 06:04:35.006357000 +0000",
    updated_at: "2024-12-29 08:16:14.509915000 +0000",
    company_id: 2
  },
  {
    id: 8,
    name: "Philippine Span Asia Carrier Corp.",
    code: "NC",
    address: "PSACC Pier 16 Office, Manila North Harbor, Tondo, ...",
    partner: nil,
    tin: 123,
    created_at: "2024-12-27 12:55:58.574879000 +0000",
    updated_at: "2024-12-28 08:14:23.230271000 +0000",
    company_id: 1
  }
])

Quotation.destroy_all

q = Quotation.new(
  company_id: Company.first.id,
  client_id: Client.second.id,
  attention: 'Ms. Christine Mahinay',
  vessel: 'SL KAMAGONG',
  subject: 'SUPPLY OF AIR COMPRESSOR',
  additional_conditions: 'Additional conditions here',
  lead_time: 'EX-WORKS,SUBJECT TO PRIOR SALES AFTER RECEIPT OF P.O.',
  warranty: 'THREE (3) MONTHS AGAINST FACTORY DEFECT',
  payment: '30 days'
)

product = q.products.build(
  name: 'AIR COMPRESSOR',
  brand: 'Vespa',
  quantity: 1,
  unit: 'Unit',
  price: 196000.00,
  description: 'Working pressure: 12kg/cm^',
  specs: 'Voltage: 220 Volts',
  remarks: 'Sample Remarks here'
)

q.save