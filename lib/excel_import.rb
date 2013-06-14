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
		l.first_name = ex.cell(line, 'A')
		l.last_name = ex.cell(line, 'B')
		l.email = ex.cell(line, 'C')
		l.phone = ex.cell(line, 'D')
		l.source = ex.cell(line, 'E')
		l.status = ex.cell(line, 'F')
		l.save
	}
  end
end