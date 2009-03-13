require 'rubygems'
require 'erb'
require 'sinatra/base'
require 'sinatra'
require 'pp'
require 'lib/logs'

# class RackLogs < Sinatra::Base
  enable :sessions
  
  before do
    @logs = $logs
  end
  
  get '/' do
    redirect '/log/0'
  end
  
  get '/log/:id' do
    @id = params[:id].to_i
    @log = @logs[@id]
    @lines = 15
    @log_text = @log.get_some_log( @lines )
    erb :log
  end
  
  post '/log_text' do
    @id = params['id'].to_i
    @lines = params['lines'].to_i
    @log = @logs[@id]
    
    @log_text = @log.get_some_log( @lines )
    erb :log_text
  end
  
    
  post '/info_bar' do
    @id = params['id'].to_i
    @lines = params['lines'].to_i    
    @log = @logs[@id]
    
    erb :info_bar
  end

  
  configure do
    $logs = []
    logs_config = Logs.load_config_file
    logs_config.each{ |log| $logs += Logs.add_logs(log)}
  end
# end
