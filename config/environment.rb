# Load the Rails application.
require File.expand_path('../application', __FILE__)

Mime::Type.register "application/x-plist", :plist

# Initialize the Rails application.
Shipmate::Application.initialize!

