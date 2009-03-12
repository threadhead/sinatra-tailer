require 'rubygems'
require 'yaml'
require 'erb'
require 'sinatra/base'
require 'sinatra'
require 'pp'
require 'lib/logs'

# class RackLogs < Sinatra::Base
  
  get '/' do
    redirect '/log/0'
  end
  
  get '/log/:id' do
    @logs = $logs
    @id = params[:id].to_i
    @log = $logs[@id]
    @log_text = get_some_log( @log.path )
    erb :log
  end
  
  get '/log/:id/log_text' do
    @log = $logs[params[:id].to_i]
    get_some_log( @log.path )
  end
  
  
  def get_some_log(path, lines=25)
    result = `tail -n #{lines} #{path}`
    "<p>" + result.gsub("\n", "</p><p>") + "</p>"
  end

  
  configure do
    $logs = []
    logs_config = Logs.load_config_file
    logs_config.each{ |log| $logs += Logs.add_logs(log)}
  end
# end
