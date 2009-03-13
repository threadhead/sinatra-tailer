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
    # session['lines'] ||= 15
    # session['refresh'] ||= 3
    # pp params
    # @id = params['id'].to_i if params['id']
    # set_session_data
  end
  
  get '/' do
    redirect '/log/0'
  end
  
  
  get '/log/:id' do
    set_session_data
    @log = @logs[@id]
    puts "session: #{session.inspect}"
    puts "params: #{params.inspect}"
    
    @log_text = @log.get_some_log( session['lines'] )
    erb :log
  end
  
  
  post '/log_text' do
    set_session_data
    @log = @logs[@id]
    puts "session: #{session.inspect}"
    puts "params: #{params.inspect}"
    
    
    @log_text = @log.get_some_log( session['lines'] )
    erb :log_text
  end
  
    
  post '/info_bar' do
    set_session_data
    @log = @logs[@id]
    puts "session: #{session.inspect}"
    puts "params: #{params.inspect}"
    
    
    erb :path_info
  end


  def set_session_data
    # puts "session: #{session.inspect}"
    # puts "params: #{params.inspect}"
    @id = params['id'].to_i if params['id']
    session['lines'] = params['lines'] if params['lines']
    session['refresh'] = params['refresh'] if params['refresh']
    # puts "session: #{session.inspect}"
    
  end
  
  configure do
    $logs = []
    logs_config = Logs.load_config_file
    logs_config.each{ |log| $logs += Logs.add_logs(log)}
  end
# end
