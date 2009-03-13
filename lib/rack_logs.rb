require 'rubygems'
require 'erb'
require 'sinatra/base'
require 'sinatra'
require 'pp'
require 'lib/logs'

# class RackLogs < Sinatra::Base
  
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
    @log_text = get_some_log( @log.path, @lines )
    erb :log
  end
  
  post '/log/:id/log_text' do
    @log = @logs[params[:id].to_i]
    @lines = params['lines'].to_i
    pp params
    puts "lines #{@lines}"
    
    get_some_log( @log.path, @lines )
  end
  
  
  def get_some_log(path, lines=25)
    # puts "path #{path}"
    # puts "lines #{lines}"
    result = `tail -n #{lines} #{path}`
    "<p>" + result.gsub("\n", "</p><p>") + "</p>"
  end
  
  get '/log/:id/info_bar' do
    @log = @logs[params[:id].to_i]
    @lines = params['lines']
    erb :info_bar
  end

  
  configure do
    $logs = []
    logs_config = Logs.load_config_file
    logs_config.each{ |log| $logs += Logs.add_logs(log)}
  end
# end
