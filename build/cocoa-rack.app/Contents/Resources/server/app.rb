
# Load in Gems.
Dir.glob(File.join(File.dirname(__FILE__), "vendor", "gems", "*","lib")).each do |lib| 
  $LOAD_PATH.unshift File.expand_path(lib) 
end

# Other Libs.
Dir.glob('./lib/**/*.rb') do |file|
  require file
end

# Requires
require "rack"

# Globals
ORG_STRING       = "com.foo.rack-cocoa.org"
PORT             = ENV['PORT'] || 9999

# Builder
builder = Rack::Builder.new do

  use Rack::Static, 
    :urls => ["/images", "/js", "/css"],
    :root => "public",
    :index => 'index.html'

  # Lots of maps.
  map '/' do
    run Rack::File.new("public")
  end

  map '/say' do 
    run Proc.new {|env|
      req = Rack::Request.new(env)
      return unless req.post?
      text  = req.params["text"].empty? ? "I have nothing to say right now." : req.params["text"]
      voice = req.params["voice"] == "Choose a voice" ? "Agnes" : req.params["voice"]
      puts voice
      `say -v #{voice} "#{text}"`
      [200, {'Content-Type' => 'text/plain'}, ["ok"] ]
    }
  end

  # Dont remove the following routes. These are how we speak to our Cocoa App.
  map '/version' do
    run Proc.new {|env| [200, {'Content-Type' => 'text/plain'}, [CocoaRackRunner.running_version.to_s] ] }
  end

  map '/kill' do
    run lambda { |env| exit! }
  end

  map '/ping' do
    run Proc.new {|env| [200, {'Content-Type' => 'text/plain'}, ["pong"] ] }
  end
end

CocoaRackRunner.run do 
  # Run it.
  Rack::Handler::WEBrick.run builder, :Port => PORT
end