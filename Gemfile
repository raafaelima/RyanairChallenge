source "https://rubygems.org"

gem "fastlane", "~>2.19"
gem "xcov", "1.5.0"
gem "badge", "~>0"
gem "synx", "~>0.2"
gem "xcode-install", "~>2.2"

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval(File.read(plugins_path), binding) if File.exist?(plugins_path)
