# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def hace_tiempo_en_palabras(time, referencia = Time.now)
    distance_in_minutes = ((time.to_time - referencia).abs/60).round
    case distance_in_minutes
      when 0..1   then "1 minuto"
      when 2..45  then "#{distance_in_minutes} minutos"
      when 46..70 then "unha hora"
      when 70..120 then "pouco máis dunha hora"
      when 120..10000 then "#{distance_in_minutes/60} horas"
      when 10000.10100 then "unha semana"
      else "moito tempo tiempo"
    end
  end
  def tiempo_exacto(time)
    case time
      when 1.day.ago then "24 horas"
      when 1.week.ago then "1 semana"
      when 1.month.ago then "1 mes"
      when 1.year.ago then "1 año"      
    end
  end
  def stat_count_helper
    @languages = Languages.find :all, :order => "name"
    salida = "<h3>Lenguajes <span>(totales)</span></h3>"
      if !@languages.blank?
        salida += "<table class=\"stats\">\n"
        for language in @languages
          salida += "\t<tr>\n
            <td class=\"l\">#{language.name}</td>\n
            <td>#{ language.pastes.size }</td>\n
          </tr>\n"
        end
        salida += "</table>\n"
      else
        salida = "No hay estadísticas"
      end
    
  end
end
