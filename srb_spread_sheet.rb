require 'yaml'
require 'spreadsheet'

class SrbSpreadSheet

  def self.sport
    @sport ||= refs['reference']['sport']
  end

  def self.refs
    @refs ||= open('reference.yml') {|f| YAML.load(f) }
  end

  def self.get_full_xls_file_name
    xls_file_name = get_xls_file_path + get_xls_file_name
  end

  def self.get_workbook
    workbook = Spreadsheet.open(get_full_xls_file_name)
  end

  private

  def self.get_xls_file_path
    path = refs['reference']['xls_file_path']
    if(!path.nil? && path[-1,1]!='/')
      path+='/'
    end
  end

  def self.get_xls_file_name
    name = refs['reference']['xls_file_name']
  end
end