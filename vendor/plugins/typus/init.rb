begin

  ActionController::Base.append_view_path(File.join(File.dirname(__FILE__), 'app', 'views'))

  %w( controllers models helpers ).each do |m|
    Dependencies.load_paths << File.join(File.dirname(__FILE__), 'app', m)
  end

  if File.exists?("#{RAILS_ROOT}/config/typus.yml")
    %w( sha1 paginator typus ).each { |lib| require lib }
    Typus.enable
  else
    puts "=> Typus is not enabled because config file does not exist."
  end

rescue LoadError
  puts "=> [TYPUS] Install required plugins and gems with `rake typus:dependencies`"
end