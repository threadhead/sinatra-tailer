require 'rubygems'
require 'yaml'
require 'erb'
require 'sinatra/base'
require 'sinatra'
require 'pp'
require 'lib/logs2'

# class RackLogs < Sinatra::Base
  
  get '/' do
    @logs = $logs
    @id = -1
    erb :index
  end
  
  get '/log/:id' do
    @logs = $logs
    @id = params[:id].to_i
    @log = $logs[@id]
    @log_text = get_some_log( @log.path )
    erb :log
  end
  
  
  def get_some_log(path, lines=25)
    result = `tail -n #{lines} #{path}`
    "<p>" + result.gsub("\n", "</p><p>") + "</p>"
  end
  
  
  def read_logs_config
    puts "GETTING LOGS"
    host_file = File.join(File.dirname(__FILE__), 'config', 'logs.yml')
    
    File.open host_file do |yf|
      YAML.each_document( yf ) do |ydoc|
        return ydoc.map{ |rec| rec[1] }
      end
    end    
  end
  
  configure do
    $logs = []
    read_logs_config.each{ |log| $logs += Logs2.add_logs(log)}
  end
# end
