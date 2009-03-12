require 'rubygems'
require 'fileutils'
require 'yaml'

class Logs
  attr_reader :path, :pidfile, :start_stop
  
  def initialize(options={})
    raise ArgumentError, "must supply a path (:path => '/path/to/logs')" unless options.has_key?(:path)
    
    @path = options[:path] || nil
    @name = options[:name] || nil
    @pidfile = options[:pidfile] || nil
    @start_stop = options[:start_stop] || nil
  end
  
  def name
    if @name
      @name
    else
      File.basename( @path )
    end
  end
  
  
  # add_logs support file globs
  def self.add_logs(options={})
    logs = []
    files = Dir.glob( options[:path] )
    
    if files.length == 1
      logs << Logs.new( {:path => files.first}.merge options )
    else
      files.each{ |file| logs += Logs.add_logs( :path => file ) }
    end
    
    logs
  end
  
  def self.load_config_file
    host_file = File.join(File.dirname(__FILE__), '..', 'config', 'logs.yml')
    
    if File.exists?( host_file )
      File.open host_file do |yf|
        YAML.each_document( yf ) do |ydoc|
          return ydoc.map{ |rec| rec[1] }
        end
      end
      
    else
      raise Error, "the file 'config/logs.yml' does not exist, please copy logs.example.yml and edit"
    end
  end
end