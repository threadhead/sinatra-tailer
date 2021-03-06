require 'rubygems'
require 'fileutils'
require 'yaml'

class LogsError < StandardError; end
  
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
  
  def path_update
    file_update( @path )
  end
  
  def pidfile_update
     file_update( @pidfile )
  end
  
  def pidfile_exists?
    @pidfile ? File.exists?( @pidfile ) : false
  end
  
  def get_some_log(lines=25)
    result = `tail -n #{lines} #{@path}`
    result.split(/\n/)
  end
  
  
  # add_logs support file globs
  def self.add_logs(options={})
    logs = []
    files = Dir.glob( options[:path] )
    
    if files.nil? || files.empty?
      raise LogsError.new("the path '#{options[:path]}' resulted in no files being found") 
    else
    
      if files.length == 1
        logs << Logs.new( {:path => files.first}.merge(options) )
      else
        files.each{ |file| logs += Logs.add_logs( :path => file ) }
      end
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
      raise LogsError.new("the file 'config/logs.yml' does not exist, please copy logs.example.yml and edit")
    end
  end
  
  private
  def file_update(path)
    if File.exists?(path )
      return File.mtime( path )
    end
  end
end