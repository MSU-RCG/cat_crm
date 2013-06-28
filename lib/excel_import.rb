class ExcelImport

require 'roo'
require 'spreadsheet'
require 'fileutils'

  def self.parse(filename)
	ex = Roo::Excelx.new(filename) 
	ex.default_sheet = ex.sheets.first
	header = ex.first_row
	footer = ex.last_row
	
	2.upto(footer) {|line|
		l = Lead.new()
		a = Address.create()
		l.first_name = ex.cell(line, 'A')
		l.last_name = ex.cell(line, 'B')
		l.email = ex.cell(line, 'C')
		l.phone = ex.cell(line, 'D')
		l.source = ex.cell(line, 'E').downcase
		l.status = ex.cell(line, 'F').downcase
		l.cf_academic_year = ex.cell(line, 'G').to_s
		a.street1 = ex.cell(line, 'H').to_s
		a.street2 = ex.cell(line, 'I').to_s
		a.city = ex.cell(line, 'J').to_s
		a.state = ex.cell(line, 'K').to_s
		a.zipcode = ex.cell(line, 'L').to_i.to_s
		a.country = ex.cell(line, 'M').to_s
		a.address_type = "Business"
		a.save
		l.business_address = a
		l.save
	}
  end
end