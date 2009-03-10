require 'rubygems'

class Logs
  def initialize
    @logs = []
  end
  
  
  # add_logs support file globs
  def add_logs(path, name=nil, pidfile=nil)
    files = Dir.glob( path )
    if files.length == 1
      @logs << { :path => files.first, :name => name, :pidfile => pidfile }
    else
      files.each{ |file| add_logs(file) }
    end
    
  end
  
  
  def find_log_by_index(index)
    # Logs.select{ |log| log[:id] == id }
    @logs[index]
  end
end