# Load the Rails application.
require File.expand_path('../application', __FILE__)

Mime::Type.register "text/plist", :plist

# Initialize the Rails application.
Shipmate::Application.initialize!

