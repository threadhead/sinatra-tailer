require 'test/test_helper'
require 'tempfile'
require 'tmpdir'
require 'fileutils'

class TestLogs < Test::Unit::TestCase
  def setup
    @logs = Logs.new
    @temp_dir = File.join(Dir.tmpdir, 'test_logs_tmp')
    Dir.mkdir @temp_dir
  end
  
  def teardown
    FileUtils.rm_r @temp_dir
  end
  
  
  def test_create_logs_class
    assert_instance_of(Logs, @logs)
  end
  
  
  def test_add_one_log_file
    file = FileUtils.touch(File.join( @temp_dir, 'test_1.log')).to_s
    @logs.add_logs( file )
    assert_equal(file, @logs.logs[0][:path])
  end


  def test_add_one_log_file_with_params
    file = FileUtils.touch(File.join( @temp_dir, 'test_1.log')).to_s
    @logs.add_logs( file, "File Name", "/var/pidfile.pid" )
    assert_equal(file, @logs.logs[0][:path])
    assert_equal("File Name", @logs.logs[0][:name])
    assert_equal("/var/pidfile.pid", @logs.logs[0][:pidfile])
  end
  
  
  def test_find_log_by_index
    files = []
    (1..3).each do |r|
      files << FileUtils.touch( File.join( @temp_dir, "test_#{r}.log") ).to_s
    end
    @logs.add_logs( File.join( @temp_dir, "*.log") )
    
    assert_equal(files[0], @logs.find_log_by_index(0)[:path])
  end
  

  def test_add_multiple_log_files
    files = []
    (1..3).each do |r|
      files << FileUtils.touch( File.join( @temp_dir, "test_#{r}.log") ).to_s
    end
    
    @logs.add_logs( File.join( @temp_dir, "*.log") )
    assert_equal(3, files.size)
    (1..3).each do |r|
      assert_equal("test_#{r}.log", File.basename( @logs.logs[r-1][:path] ) )
    end
    
  end
end