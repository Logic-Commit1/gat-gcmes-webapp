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