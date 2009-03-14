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
    # $logs.each{ |log| puts log.name }
    #     puts 'sorting...'
    #     # $logs.sort_by{ |log| 
    #     #       puts "log: #{log.name}"
    #     #       log.name }
    #     #       
    #     $logs.sort{ |a,b|
    #       puts "a: #{a.name}(#{a.name.class})"
    #       puts "b: #{b.name}(#{b.name.class})"
    #       puts a.name <=> b.name
    #       a.name <=> b.name
    #       }
    #     $logs.each{ |log| puts log.name }
    
  end
# end
