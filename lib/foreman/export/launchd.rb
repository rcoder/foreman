require "erb"
require "foreman/export"

class Foreman::Export::Launchd < Foreman::Export::Base
  DEFAULT_PLIST_DIR = '/Library/LaunchDaemons'

  def export(location=nil, options={})
    location ||= DEFAULT_PLIST_DIR
    app = options[:app] || File.basename(engine.directory)
    user = options[:user] || app
    log_root = options[:log] || "/var/log/#{app}"

    concurrency = Foreman::Utils.parse_concurrency(options[:concurrency])

    process_template = export_template("launchd/process.plist.erb")

    engine.processes.values.each do |process|
      1.upto(concurrency[process.name]) do |num|
        port = engine.port_for(process, num, options[:port])
        process_config = ERB.new(process_template).result(binding)
        plist_path = "#{location}/#{app}.#{process.name}.#{num}.plist"
        write_file(plist_path, process_config)
      end
    end
  end
end
