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
            when /^[l|L]anguages/i
              messenger.deliver(msg.from, "Valid Languages are: #{Language.find(:all).map{ |language| language.uv_name }.join(", ")}")
            when /^[h|H]elp/i
              messenger.deliver(msg.from, "Valid commands are:\n\tpaste:language_code text_of_you_paste ....   => for post your paste on paste-mabishu\n\tlist? => for listing all your pastes on the system\n\tlanguages => list all the the available languages for paste")  
            when /^paste:/i
              matches = msg.body.scan(/^paste:([a-z_\.-]*) (.*)/mi).flatten
              puts "Matches: "+matches[0]+"----"+matches[1] if ENV["DEBUG"]==true

              paste_content = matches[1]
              language = Language.find_by_uv_name(matches[0]).id
              @p = Paste.create( :content=> paste_content, :language_id => language) if language
              #p = true # ñapa temporal
              response = if (@p and matches.size==2)
                "Thanks #{msg.from.node+"@"+msg.from.domain}, your paste has been upload, if you want to see go to http://paste.mabishu.com/pastes/#{@p.id}"
              else
                "For an unknown reason the paste haven't been upload to your profile, please try again or contact using the contact from http://paste.mabishu.com/contact"
              end
              messenger.deliver(msg.from, response)  
              
            when /^[l|L]ist\?/i
              messenger.deliver(msg.from, "This functionality is not yet implemented, the purpouse of this is list all the pastes from the user that is requesting.")  
            else
              messenger.deliver(msg.from, "Sorry , I didn't understand that. Message me with 'help' for a list of commands")  
            end
          else
            messenger.deliver(msg.from, "Sorry, but we've not got this account registered on our system. Sign-up or update your details at http://www.mysite.com/")  
          end
         
          rescue Exception => e
            messenger.deliver(msg.from, "Something is technically wrong at the ") 
            puts e.inspect
            #logger.warn e.inspect
          end 
        end
    end
end