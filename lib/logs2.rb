require 'rubygems'

class Logs2
  attr_reader :path, :name, :pidfile, :start_stop
  
  def initialize(options={})
    raise ArgumentError, "must supply a path (:path => '/path/to/logs')" unless options.has_key?(:path)
    
    @path = options[:path] || nil
    @name = options[:name] || nil
    @pidfile = options[:pidfile] || nil
    @start_stop = options[:start_stop] || nil
  end
  
  
  # add_logs support file globs
  def self.add_logs(options={})
    logs = []
    files = Dir.glob( options[:path] )
    
    if files.length == 1
      logs << Logs2.new( {:path => files.first}.merge options )
    else
      files.each{ |file| logs += Logs2.add_logs( :path => file ) }
    end
    
    logs
  end
end