require "spec_helper"
require "foreman/engine"
require "foreman/export/launchd"
require "tmpdir"

describe Foreman::Export::Launchd do
  let(:procfile) { FileUtils.mkdir_p("/tmp/app"); write_procfile("/tmp/app/Procfile") }
  let(:engine) { Foreman::Engine.new(procfile) }
  let(:launchd) { Foreman::Export::Launchd.new(engine) }

  before(:each) { load_export_templates_into_fakefs("launchd") }
  before(:each) { stub(launchd).say }

  it "exports to the filesystem" do
    launchd.export("/tmp/launchd")

    File.read("/tmp/launchd/app.alpha.1.plist").should == example_export_file("launchd/app.alpha.1.plist")
    File.read("/tmp/launchd/app.alpha.2.plist").should == example_export_file("launchd/app.alpha.2.plist")
    File.read("/tmp/launchd/app.bravo.1.plist").should == example_export_file("launchd/app.bravo.1.plist")
  end
end
