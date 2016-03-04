require 'cgi'
require 'json'
require 'net/http'
require 'kitchen'
require 'aws-sdk'
require 'mixlib/shellout'


# Enables `bundle exec rake do_all[ubuntu-12.04-amd64,centos-7.1-x86_64]
# http://blog.stevenocchipinti.com/2013/10/18/rake-task-with-an-arbitrary-number-of-arguments/
task :do_all do |task, args|
  args.extras.each do |a|
    # build stage
    Rake::Task['build_box'].invoke(a)
    Rake::Task['build_box'].reenable
  end

  # verification stage
  Rake::Task['test_all'].invoke
  Rake::Task['test_all'].reenable

end

desc 'Build a bento template'
task :build_box, :template do |t, args|
  sh "#{build_command(args[:template])}"
end

desc 'Test all boxes with Test Kitchen'
task :test_all do
  metadata_files.each do |metadata_file|
    puts "Processing #{metadata_file} for test."
    Rake::Task['test_box'].invoke(metadata_file)
    Rake::Task['test_box'].reenable
  end
end

desc 'Test a box with Test Kitchen'
task :test_box, :metadata_file do |f, args|
  metadata = box_metadata(args[:metadata_file])
  test_box(metadata['name'], metadata['providers'])
end

desc 'Clean the build directory'
task :clean do
  puts 'Removing builds/*.{box,json}'
  `rm -rf builds/*.{box,json}`
  puts 'Removing packer-* directories'
  `rm -rf packer-*`
  puts 'Removing .kitchen.*.yml'
  `rm -f .kitchen.*.yml`
end

def class_for_request(verb)
  Net::HTTP.const_get(verb.to_s.capitalize)
end
def build_uri(verb, path, params = {})
  if %w(delete, get).include?(verb)
    path = [path, to_query_string(params)].compact.join('?')
  end

  # Parse the URI
  uri = URI.parse(path)

  # Don't merge absolute URLs
  uri = URI.parse(File.join(endpoint, path)) unless uri.absolute?

  # Return the URI object
  uri
end

def to_query_string(hash)
  hash.map do |key, value|
    "#{CGI.escape(key)}=#{CGI.escape(value)}"
  end.join('&')[/.+/]
end

def request(verb, url, data = {}, headers = {})
  uri = build_uri(verb, url, data)

  # Build the request.
  request = class_for_request(verb).new(uri.request_uri)
  if %w(patch post put delete).include?(verb)
    if data.respond_to?(:read)
      request.content_length = data.size
      request.body_stream = data
    elsif data.is_a?(Hash)
      request.form_data = data
    else
      request.body = data
    end
  end

  # Add headers
  headers.each do |key, value|
    request.add_field(key, value)
  end

  connection = Net::HTTP.new(uri.host, uri.port)

  if uri.scheme == 'https'
    require 'net/https' unless defined?(Net::HTTPS)

    # Turn on SSL
    connection.use_ssl = true
    connection.verify_mode = OpenSSL::SSL::VERIFY_PEER
  end

  connection.start do |http|
    response = http.request(request)

    case response
      when Net::HTTPRedirection
        redirect = URI.parse(response['location'])
        request(verb, redirect, data, headers)
      else
        response
      end
  end
end


def build_command(template)
  cmd = %W[./bin/bento build #{template}]
  cmd.insert(2, "--only #{ENV['BENTO_PROVIDERS']}") if ENV['BENTO_PROVIDERS']
  cmd.insert(2, "--mirror #{ENV['PACKER_MIRROR']}") if private?(template)
  cmd.insert(2, "--version #{ENV['BENTO_VERSION']}") if ENV['BENTO_VERSION']
  cmd.join(" ")
end


def destroy_all_bento
  cmd = Mixlib::ShellOut.new("vagrant box list | grep 'bento-'")
  cmd.run_command
  boxes = cmd.stdout.split("\n")

  boxes.each do | box |
     b = box.split(" ")
     rm_cmd = Mixlib::ShellOut.new("vagrant box remove --force #{b[0]} --provider #{b[1].to_s.gsub(/(,|\()/, '')}")
     puts "Removing #{b[0]} for provider #{b[1].to_s.gsub(/(,|\()/, '')}"
     rm_cmd.run_command
  end
end

def test_box(boxname, providers)
  providers.each do |provider, provider_data|

    destroy_all_bento

    provider = 'vmware_fusion' if provider == 'vmware_desktop'

    share_disabled = /freebsd.*/ === boxname ? true : false

    puts "Testing provider #{provider} for #{boxname}"
    kitchen_cfg = {"provisioner"=>{"name"=>"chef_zero", "data_path"=>"test/fixtures"},
     "platforms"=>
      [{"name"=>"#{boxname}-#{provider}",
        "driver"=>
         {"name"=>"vagrant",
          "synced_folders"=>[[".", "/vagrant", "disabled: #{share_disabled}"]],
          "provider"=>provider,
          "box"=>"bento-#{boxname}",
          "box_url"=>"file://#{ENV['PWD']}/builds/#{provider_data['file']}"}}],
     "suites"=>[{"name"=>"default", "run_list"=>nil, "attributes"=>{}}]}

    File.open(".kitchen.#{provider}.yml", "w") {|f| f.write(kitchen_cfg.to_yaml) }

    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(project_config: "./.kitchen.#{provider}.yml")
    config = Kitchen::Config.new(loader: @loader)
    config.instances.each do |instance|
      instance.test(:always)
    end
  end
end

def upload_to_af
  #TODO: buildme
end

