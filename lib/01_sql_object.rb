require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.
​
class SQLObject
  def self.columns
    return @column if @column 
   col = DBConnection.execute2(<<-SQL)
  SELECT
    *
  FROM
    #{table_name}
  SQL
    @column = col.first.map(&:to_sym) #{ |c| c.to_sym }
  end
​
  def self.finalize!
    columns.each do |column|
      define_method("#{column}".to_sym) do 
        attributes[column] 
      end
​
      define_method("#{column}=".to_sym) do |new_value|
        attributes[column] = new_value
      end
    end
​
  end
​
  def self.table_name=(table_name)
    @table_name = table_name
  end
​
  def self.table_name #intance variable
    @table_name = self.to_s.downcase + 's'
  end
​
  def self.all
    # ...
  end
​
  def self.parse_all(results)
    # ...
  end
​
  def self.find(id)
    # ...
  end
​
  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
​
      if self.class.columns.include?(attr_name)
        send("#{attr_name}=", value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
​
    end
  end
​
  def attributes
    @attributes ||= {}
  end
​
  def attribute_values
    # ...
  end
​
  def insert
    # ...
  end
​
  def update
    # ...
  end
​
  def save
    # ...
  end
end