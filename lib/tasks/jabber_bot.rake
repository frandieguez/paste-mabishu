require 'rubygems'  
require 'xmpp4r-simple'
task :jabber_bot => :environment do
    BOT_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/xmpp-bot.yml")[RAILS_ENV]
    messenger = Jabber::Simple.new(BOT_CONFIG["xmpp_username"], BOT_CONFIG["xmpp_password"])
    puts "Server escuchando conversaciones..."
    while true
       messenger.received_messages do |msg|
         begin
          user = true#User.find_by_im_name(msg.from)
          puts "Send from "+ msg.from.node+"@"+msg.from.domain + "\n \"#{msg.body}\"" if ENV["DEBUG"] == true
          if user
            case msg.body
            when /^help/i
              messenger.deliver(msg.from, "Valid commands are:\n\tpaste ....   => for post your paste on paste-mabishu\n\tlist? => for listing all your pastes on the system")  
            when /^paste /i
              paste_content = msg.body.gsub(/^paste /i, "")

              @p = Paste.create( :content=> paste_content)
              #p = true # ñapa temporal
              response = if @p
                "Thanks #{msg.from}, your paste has been upload, if you want to see go to http://paste.mabishu.com/pastes/#{@p.id}"
              else
                "For an unknown reason the paste haven't been upload to your profile, please try again or contact using the contact from http://paste.mabishu.com/contact"
              end
              messenger.deliver(msg.from, response)  
            when /^list\?/i
              messenger.deliver(msg.from, "This functionality is not yet implemented, the purpouse of this is list all the pastes from the user that is requesting.")  
            else
              messenger.deliver(msg.from, "Sorry , I didn't understand that. Message me with 'help' for a list of commands")  
            end
          else
            messenger.deliver(msg.from, "Sorry, but we've not got this account registered on our system. Sign-up or update your details at http://www.mysite.com/")  
          end
         
          rescue Exception => e
            messenger.deliver(msg.from, "Something is technically wrong at the ") 
            logger.warn e.inspect
          end 
        end
    end
end