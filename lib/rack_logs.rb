require 'rubygems'
require 'yaml'
require 'erb'
require 'sinatra/base'
require 'sinatra'
require 'pp'

# class RackLogs < Sinatra::Base
  
  get '/' do
    @logs = get_logs
    erb :index
  end
  
  get '/log/:id' do
    @logs = get_logs
    
    @log = @logs.select{ |log| log[:id] == params[:id].to_i }
    @log_text = get_some_log( @log[0][:path] )
    erb :log
  end
  
  def get_logs
    host_file = File.join(File.dirname(__FILE__),'config', 'logs.yml')
    
    File.open host_file do |yf|
      YAML.each_document( yf ) do |ydoc|
        return ydoc.map{ |rec| rec[1] }
      end
    end    
  end
  
  def get_some_log(path, lines=25)
    result = `tail -n #{lines} #{path}`
    "<p>" + result.gsub!("\n", "</p><p>") + "</p>"
  end
  
  configure do
    @logs = get_logs
  end
# end
