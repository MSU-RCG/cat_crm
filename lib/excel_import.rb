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
      l = Lead.where(:last_name=>ex.cell(line, 'B').to_s, 
                     :first_name=>ex.cell(line, 'C').to_s
                     ).first_or_create
      a = Address.create(:street1=>ex.cell(line, 'E').to_s, :city=> ex.cell(line, 'F').to_s, :state=>ex.cell(line, 'G').to_s, :zipcode=>ex.cell(line, 'H').to_i.to_s,:address_type => "Business")
      Lead.update(l.id, :email => ex.cell(line, 'K').to_s)
      Lead.update(l.id, :phone => ex.cell(line, 'I').to_s + ex.cell(line, 'J').to_s)
      Lead.update(l.id, :source => ex.cell(line, 'M').to_s.downcase.gsub(' ','_'))
      year = ex.cell(line, 'L').to_s.strip[0..3]
      end_year = year.to_i + 1
      Lead.update(l.id, :cf_academic_year => year + "-" + end_year.to_s)
      # l.cf_starting_year = year + "-" + end_year.to_s
      Lead.update(l.id, :business_address => a)
      #l.save(:validate=>false)
    }
  end
end