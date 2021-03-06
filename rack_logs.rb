require 'rubygems'
require 'erb'
require 'sinatra'
require 'pp'
require 'lib/logs'

# set :logging, false
enable :sessions


before do
  @logs = $logs    
  session['lines'] ||= "15"
  session['refresh'] ||= "3"
  
  session['lines'] = params['lines'] if params['lines']
  session['refresh'] = params['refresh'] if params['refresh']
end

get '/' do
  redirect '/log/0'
end


get '/log/:id' do
  @log = @logs[params['id'].to_i]
  @log_text = @log.get_some_log( session['lines'] )
  erb :log
end


post '/log_text' do
  @log = @logs[params['id'].to_i]
  @log_text = @log.get_some_log( session['lines'] )
  erb :log_text
end

  
post '/info_bar' do
  @log = @logs[params['id'].to_i]
  erb :path_info
end


configure do
  $logs = []
  logs_config = Logs.load_config_file
  logs_config.each{ |log| $logs += Logs.add_logs(log)}
  $logs.sort!{ |a,b| a.name <=> b.name }
end