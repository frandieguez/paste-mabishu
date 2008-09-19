module TypusHelper

  def header
    "<h1>#{Typus::Configuration.options[:app_name]} <small>#{link_to "View site", '/', :target => 'blank'}</small></h1>"
  end

  def login_info
    html = <<-HTML
      <ul>
        <li>Logged as #{link_to @current_user.full_name, :controller => 'typus', :model => 'typus_users', :action => 'edit', :id => @current_user.id}</li>
        <li>#{link_to "Logout", typus_logout_url}</li>
      </ul>
    HTML
    return html
  end

  ##
  # Dashboard list of applications for the dashboard
  def applications

    html = "<div id=\"list\">"

    if Typus.applications.size == 0
      return display_error("There are not defined applications in config/typus.yml")
    end

    Typus.applications.each do |module_name|

      enabled = false

      html_module = <<-HTML
        <table>
          <tr>
            <th colspan="2">#{module_name}</th>
          </tr>
      HTML

      Typus.modules(module_name).each do |model|
        if @current_user.models.include? model
          html_module << <<-HTML
            <tr class="#{cycle('even', 'odd')}">
              <td>#{link_to model.titleize.pluralize, :action => 'index', :model => model.delete(" ").tableize}<br /></td>
              <td align="right" valign="bottom"><small>#{link_to 'Add', :action => 'new', :model => model.delete(" ").tableize}</small></td>
            </tr>
          HTML
          enabled = true
        end
      end
      html_module << <<-HTML
        </table>
        <br />
        <div style="clear"></div>
      HTML
      
      html << html_module if enabled
      
    end

    html << "</div>"

  rescue Exception => error
    display_error(error)
  end

  def actions

    html = "<h2>Actions</h2>\n"

    ##
    # Add
    #
    case params[:action]
    when 'index', 'edit', 'update'
      html << "<ul>"
      html << "<li>#{link_to "Add #{@model.name.titleize.downcase}", :action => 'new'}</li>"
      html << "</ul>"
    end
    
    ##
    # Edit, update ...
    #
    case params[:action]
    when 'edit', 'update'
      html << "<ul>"
      html << "<li>#{link_to "Next", :params => params.merge(:action => 'edit', :id => @next.id)}</li>" if @next
      html << "<li>#{link_to "Previous", :params => params.merge(:action => 'edit', :id => @previous.id)}</li>" if @previous
      html << "</ul>"
    end

    ##
    # index, update, create
    case params[:action]
    when "new", "create"
      html << "<ul>"
      html << "<li>#{link_to "Back to list", :params => params.merge(:action => 'index')}</li>"
      html << "</ul>"
    else
      html << more_actions
      html << modules
      html << submodules
    end

    return html

  end

  def more_actions
    html = ""
    filter = case params[:action]
               when 'index' then 'list'
               when 'edit' then 'form'
             end
    @model.typus_actions_for(filter).each do |a|
      html << "<li>#{link_to a.titleize.capitalize, :params => params.merge(:controller => "typus/#{params[:model]}", :model => params[:model], :action => a, :id => params[:id]) }</li>"
    end
    html = "<ul>#{html}</ul>" if html
  end

  def modules
    html = ""
    Typus.parent_module(params[:model].singularize.titleize).each do |m|
      model_cleaned = m.split(" ").join("").tableize
      html << "<li>#{ link_to m, :controller => "typus", :model => model_cleaned }</li>"
    end
    unless html.empty?
      html = "<h2>Modules</h2>\n<ul>#{html}</ul>"
    else
      ""
    end
  rescue
    ""
  end

  def submodules
    html = ""
    Typus.submodules(params[:model].singularize.titleize).each do |m|
      model_cleaned = m.split(" ").join("").tableize
      html << "<li>#{ link_to m, :controller => "typus", :model => model_cleaned }</li>"
    end
    unless html.empty?
      html = "<h2>Submodules</h2>\n<ul>#{html}</ul>"
    else
      ""
    end
  end

  def search
    if Typus::Configuration.config["#{@model.name}"]["search"]
      search = <<-HTML
        <h2>Search</h2>
        <form action="" method="get">
        <p><input id="search" name="search" type="text" value="#{params[:search]}"/></p>
        </form>
      HTML
      return search
    end
  end

  def filters
    current_request = request.env['QUERY_STRING'] || []
    if @model.typus_filters.size > 0
      html = ""
      @model.typus_filters.each do |f|
        html << "<h2>#{f[0].humanize}</h2>\n"
        case f[1]
        when 'boolean'
          html << "<ul>\n"
          %w( true false ).each do |status|
            switch = (current_request.include? "#{f[0]}=#{status}") ? 'on' : 'off'
            html << "<li>#{link_to status.capitalize, { :params => params.merge(f[0] => status) }, :class => switch}</li>\n"
          end
          html << "</ul>\n"
        when 'datetime'
          html << "<ul>\n"
          %w( today past_7_days this_month this_year ).each do |timeline|
            switch = (current_request.include? "#{f[0]}=#{timeline}") ? 'on' : 'off'
            html << "<li>#{link_to timeline.titleize, { :params => params.merge(f[0] => timeline) }, :class => switch}</li>\n"
          end
          html << "</ul>\n"
        when 'integer'
          model = f[0].split("_id").first.capitalize.camelize.constantize
          if model.count > 0
            html << "<ul>\n"
            model.find(:all, :order => model.typus_order_by).each do |item|
              switch = (current_request.include? "#{f[0]}=#{item.id}") ? 'on' : 'off'
              html << "<li>#{link_to item.typus_name, { :params => params.merge(f[0] => item.id) }, :class => switch}</li>\n"
            end
            html << "</ul>\n"
          end
        when 'string'
          values = eval f[0].upcase
          html << "<ul>\n"
          values.each do |item|
            switch = (current_request.include? "#{f[0]}=#{item.last}") ? 'on' : 'off'
            html << "<li>#{link_to item.first, { :params => params.merge(f[0] => item.last) }, :class => switch }</li>\n"
          end
          html << "</ul>\n"
        end
      end
    end
    return html
  end

  def display_link_to_previous
    message = "You're adding a new #{@model.to_s.titleize} to a #{params[:btm].titleize.singularize}. "
    message << "Do you want to cancel it? <a href=\"/admin/#{params[:btm]}/#{params[:bti]}/edit\">Click Here</a>"
    "<div id=\"flash\" class=\"notice\"><p>#{message}</p></div>"
  rescue
    nil
  end

  def display_flash_message
    flash_types = [ :error, :warning, :notice ]
    flash_type = flash_types.detect{ |a| flash.keys.include?(a) } || flash.keys.first
    if flash_type
      "<div id=\"flash\" class=\"%s\"><p>%s</p></div>" % [flash_type.to_s, flash[flash_type]]
    end
  end

  def page_title
    crumbs = []
    crumbs << Typus::Configuration.options[:app_name]
    crumbs << params[:model] << params[:action]
    return crumbs.compact.map { |x| x.titleize }.join(" &rsaquo; ")
  end

  def typus_table(model = params[:model], fields = 'list', items = @items)

    @model = model.camelize.singularize.constantize
    html = "<table>"

    ##
    # Header of the table
    #
    html << "<tr>"
    @model.typus_fields_for(fields).each do |column|
      order_by = column[0]
      sort_order = (params[:sort_order] == "asc") ? "desc" : "asc"
      html << "<th>#{link_to "<div class=\"#{sort_order}\">#{column[0].titleize.capitalize}</div>", { :params => params.merge( :order_by => order_by, :sort_order => sort_order) }}</th>"
    end
    html << "<th>&nbsp;</th>\n</tr>"

    ##
    # Body of the table
    #
    items.each do |item|

      html << "<tr class=\"#{cycle('even', 'odd')}\" id=\"item_#{item.id}\">"

      @model.typus_fields_for(fields).each do |column|
        case column[1]
        when 'boolean'
          image = "#{image_tag(status = item.send(column[0])? "typus_status_true.gif" : "typus_status_false.gif")}"
          html << "<td width=\"20px\" align=\"center\">#{link_to image, { :params => params.merge(:controller => 'typus', :model => model, :action => 'toggle', :field => column[0], :id => item.id) } , :confirm => "Change #{column[0]}?"}</td>"
        when "datetime"
          html << "<td>#{item.send(column[0]).to_s(:db) rescue "-"}</td>"
        when "collection"
          html << "<td>#{link_to item.send(column[0].split("_id").first).try(:typus_name), :controller => "typus", :action => "edit", :model => "#{column[0].split("_id").first.pluralize}", :id => item.send(column[0])}</td>"
        when 'tree'
          html << "<td>#{item.parent.typus_name if item.parent}</td>"
        when "position"
          html << "<td>"
          [["&uarr;", "move_higher"], 
           ["&darr;", "move_lower"]].each do |position|
            html << "#{link_to position.first, :params => params.merge(:action => 'position', :id => item.id, :go => position.last)} "
          end
          html << "</td>"

        else # 'string', 'integer', 'selector'
          html << "<td>#{link_to item.send(column[0]) || "", :params => params.merge(:model => model, :action => 'edit', :id => item.id)}</td>"
        end
      end

      ##
      # This controls the action to perform. If we are on a model list we 
      # will remove the entry, but if we inside a model we will remove the 
      # relationship between the models.
      #
      case params[:model]
      when model
        @perform = link_to image_tag("typus_trash.gif"), { :model => model, 
                                                           :id => item.id, 
                                                           :params => params.merge(:action => 'destroy') }, 
                                                           :confirm => "Remove entry?"
      else
        @perform = link_to image_tag("typus_trash.gif"), { :action => "unrelate", 
                                                           :unrelated => model, 
                                                           :unrelated_id => item.id, 
                                                           :id => params[:id] }, 
                                                           :confirm => "Remove #{model.humanize.singularize.downcase} \"#{item.typus_name}\" from #{params[:model].titleize.singularize}?"
      end
      html << "<td width=\"10px\">#{@perform}</td>\n</tr>"

    end

    html << "</table>"

  rescue Exception => error
    display_error(error)
  end

  def typus_form(fields = @item_fields)

    html = error_messages_for :item, :header_tag => "h3"

    fields.each do |field|

      ##
      # Read only attributes (attributes that begin with "*")
      #
      if field[0].first == "*"
        if params[:action] != "new"
          attribute = field[0][1..-1]
          html << "<p><label for=\"item_#{field[0]}\">#{attribute.titleize.capitalize}</label>"
          html << "<p>#{@item.send(attribute)}"
        end
        next
      end

      html << "<p><label for=\"item_#{field[0]}\">#{field[0].titleize.capitalize}</label>"
      
      ##
      # When the field is an asset ...
      #
      case field[0]
      when /file_name/
        attribute = field[0].split("_file_name").first
        case @item.send("#{attribute}_content_type")
        when /image/
          html << "<p>#{link_to image_tag(@item.send(attribute).url(:thumb)), @item.send(attribute).url, :popup => ['Sanoke', 'height=461,width=692'], :style => "border: 1px solid #D3D3D3;"}</p>"
        else
          html << "<p>No Preview Available</p>"
        end
      end

      ##
      # Field Type
      #
      case field[1]
      when "boolean"
        html << "#{check_box :item, field[0]} Checked if active"
      when "file"
        html << "#{file_field :item, field[0].split("_").first, :style => "border: 0px;"}"
      when "datetime"
        html << "#{datetime_select :item, field[0], { :minute_step => 5 }}"
      when "password"
        html << "#{password_field :item, field[0], :class => 'title'}"
      when "text"
        html << "#{text_area :item, field[0], :class => 'text', :rows => '10'}"
      when "tree"
        html << "<select id=\"item_#{field[0]}\" name=\"item[#{field[0]}]\">\n"
        html << %{<option value=""></option>}
        html << "#{expand_tree_into_select_field(@item.class.top)}"
        html << "</select>\n"
      when "selector"
        values = eval field[0].upcase
        html << "<select id=\"item_#{field[0]}\" name=\"item[#{field[0]}]\">"
        html << "<option value=\"\">Select a #{field[0].titleize}</option>"
        values.each do |value|
          html << "<option #{"selected" if @item.send(field[0]).to_s == value.last.to_s} value=\"#{value.last}\">#{value.first}</option>"
        end
        html << "</select>"
      when "collection"
        related = field[0].split("_id").first.capitalize.camelize.constantize
        html << "#{select :item, "#{field[0]}", related.find(:all).collect { |p| [p.typus_name, p.id] }.sort_by { |e| e.first }, :prompt => "Select a #{related.to_s.downcase}"}"
      else # when "string", "integer", "float", "position"
        html << "#{text_field :item, field[0], :class => 'title'}"
      end
      html << "</p>"
    end
    return html
  rescue Exception => error
    display_error(error)
  end

  ##
  # FIXME: The admin shouldn't be hardcoded.
  #
  def typus_form_has_many
    html = ""
    if @item_has_many
      @item_has_many.each do |field|
        model_to_relate = field.singularize.camelize.constantize
        html << "<h2 style=\"margin: 20px 0px 10px 0px;\"><a href=\"/admin/#{field}\">#{field.titleize}</a> <small>#{ link_to "Add new", :model => field, :action => 'new', "#{params[:model].singularize.downcase}_id" => @item.id, :btm => params[:model], :bti => params[:id], :bta => "edit" }</small></h2>"
        current_model = params[:model].singularize.camelize.constantize
        @items = current_model.find(params[:id]).send(field)
        if @items.size > 0
          html << typus_table(field, 'relationship')
        else
          html << "<div id=\"flash\" class=\"notice\"><p>There are no #{field.titleize.downcase}.</p></div>"
        end
      end
    end
    return html
  rescue Exception => error
    display_error(error)
  end

  ##
  # FIXME: The admin shouldn't be hardcoded.
  #
  def typus_form_has_and_belongs_to_many
    html = ""
    if @item_has_and_belongs_to_many
      @item_has_and_belongs_to_many.each do |field|
        model_to_relate = field.singularize.camelize.constantize
        html << "<h2 style=\"margin: 20px 0px 10px 0px;\"><a href=\"/admin/#{field}\">#{field.titleize}</a> <small>#{link_to "Add new", :model => field, :action => 'new', :btm => params[:model], :bti => params[:id], :bta => params[:action]}</small></h2>"
        items_to_relate = (model_to_relate.find(:all) - @item.send(field))
        if items_to_relate.size > 0
          html << <<-HTML
            #{form_tag :action => "relate", :related => field, :id => params[:id]}
            <p>#{ select "model_id_to_relate", :related_id, items_to_relate.collect { |f| [f.typus_name, f.id] }.sort_by { |e| e.first } }
          &nbsp; #{submit_tag "Add", :class => 'button'}
            </form></p>
          HTML
        end
        current_model = params[:model].singularize.camelize.constantize
        @items = current_model.find(params[:id]).send(field)
        html << typus_table(field, 'relationship') if @items.size > 0
      end
    end
    return html
  rescue Exception => error
    display_error(error)
  end

  def typus_block(name)
    render :partial => "typus/#{params[:model]}/#{name}" rescue nil
  end

  ##
  # Tree when +acts_as_tree+
  #
  def expand_tree_into_select_field(categories)
    returning(String.new) do |html|
      categories.each do |category|
        html << %{<option #{"selected" if @item.parent_id == category.id} value="#{ category.id }">#{ "-" * category.ancestors.size } #{category.name}</option>}
        html << expand_tree_into_select_field(category.children) if category.has_children?
      end
    end
  end

  ##
  # Simple and clean pagination links
  #
  def windowed_pagination_links(pager, options)
    link_to_current_page = options[:link_to_current_page]
    always_show_anchors = options[:always_show_anchors]
    padding = options[:window_size]
    pg = params[:page].blank? ? 1 : params[:page].to_i
    current_page = pager.page(pg)
    html = ""
    # Calculate the window start and end pages
    padding = padding < 0 ? 0 : padding
    first = pager.first.number <= (current_page.number - padding) && pager.last.number >= (current_page.number - padding) ? current_page.number - padding : 1
    last = pager.first.number <= (current_page.number + padding) && pager.last.number >= (current_page.number + padding) ? current_page.number + padding : pager.last.number
    # Print start page if anchors are enabled
    html << yield(1) if always_show_anchors and not first == 1
    # Print window pages
    first.upto(last) do |page|
      (current_page.number == page && !link_to_current_page) ? html << page.to_s : html << (yield(page)).to_s
    end
    # Print end page if anchors are enabled
    html << yield(pager.last.number).to_s if always_show_anchors and not last == pager.last.number
    # return the html
    return html
  end

  ##
  #
  #
  def display_error(error)
    log_error error
    "<div id=\"flash\" class=\"error\"><p>#{error}</p></div>"
  end

  ##
  #
  #
  def log_error(exception)
    ActiveSupport::Deprecation.silence do
        logger.fatal(
        "Typus Error:\n\n#{exception.class} (#{exception.message}):\n    " +
        exception.backtrace.join("\n    ") +
        "\n\n"
        )
    end
  end

end