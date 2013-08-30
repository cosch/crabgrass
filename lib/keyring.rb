require 'tempfile'
require 'fileutils'

##
## A thin wrapper to help make generating GPG keyrings easier
##

class Keyring
  attr_accessor :path

  def initialize(path)
    @path = path
  end

  def self.create(public_key_data, path)
    key_file = Tempfile.new('crabgrass_public_key')
    key_file.write(public_key_data)
    key_file.close

    FileUtils.mkdir_p(File.dirname(path)) unless File.exists?(File.dirname(path))
    File.rm(path) if File.exists?(path)
    
    keyring = Keyring.new(path)
    status, output = keyring.cmd('--import', key_file.path)
    return keyring if status
  ensure
    key_file.unlink
  end

  # extract information from a keyring that has one key in it.
  # the information includes: fingerprint, email
  def extract_info
    fingerprint = nil
    email = nil

    status, output = cmd('--fingerprint', '--with-colons')
    if status
      fingerprint  = output.grep(/^fpr/).first.sub(/^.*:([A-F0-9]{40}):.*$/m, '\1') rescue Exception
      email        = output.grep(/^pub/).first.split(':')[9] rescue Exception
      #on freebsd and with some keys it was in uid field
      if email==""
        email        = output.grep(/^uid/).first.split(':')[9] rescue Exception
      end
    end
    {:fingerprint => fingerprint, :email => email}
  end

  def encrypt_to(fingerprint, data)
    data_file = Tempfile.new('crabgrass_tmp')
    data_file.write(data)
    data_file.close
    f = ""
    begin
      output_path = random_temp_filename(fingerprint)
      cmd('--encrypt', '--armor', '--recipient', fingerprint, '--trust-model', 'always', '--output', output_path, data_file.path)
      f=File.read(output_path)
    rescue Exception=>e
      #logger.fatal("deleting file failed - due to #{e}")
    end
    f
  ensure
    begin
      data_file.unlink    
      File.unlink(output_path)
    rescue Exception=>e
      #logger.fatal("deleting file failed - due to #{e}")
    end
  end

  def encrypt_to_new(fingerprint, data)
    data_file = Tempfile.new('crabgrass_tmp')
    data_file.write(data)
    data_file.close

    recipents = []
    if fingerprint.is_a? String;
      recipents.push '--recipient'
      recipents.push fingerprint       
    elsif fingerprint.is_a? Array 
      fingerprint each do |f|
        recipents.push '--recipient'
        recipents.push fingerprint
      end
    end


    output_path = fingerprint.is_a?(String) ? random_temp_filename(fingerprint) : random_temp_filename(fingerprint[0]) 
    r = #{recipents.collect{|arg| arg.shell_escape}.join(' ')}
    puts r
    cmd('--encrypt', '--armor', r, '--trust-model', 'always', '--output', output_path, data_file.path)
    File.read(output_path)
  ensure
    data_file.unlink
    File.unlink(output_path) 
  end

  def cmd(*args)
    cmdstr = "#{GPG_COMMAND} --no-default-keyring --keyring #{@path} " + args.collect{|arg| arg.shell_escape}.join(' ') + ' 2>&1'
    output = `#{cmdstr}`
    puts cmdstr
    puts output
    return [$?.success?, output]
  end

  def random_temp_filename(fingerprint)
    "/tmp/#{rand 100000}#{fingerprint}"
  end

end

