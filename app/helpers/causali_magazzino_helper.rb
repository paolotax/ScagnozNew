module CausaliMagazzinoHelper
  def tipo_movimento_badge(tipo)
    case tipo
    when 0
      content_tag :span, "Carico", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800"
    when 1
      content_tag :span, "Scarico", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800"
    when 2
      content_tag :span, "Trasferimento", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800"
    else
      content_tag :span, "Sconosciuto", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800"
    end
  end

  def segno_movimento_badge(segno)
    case segno
    when 1
      content_tag :span, "Carico (+)", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800"
    when -1
      content_tag :span, "Scarico (-)", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800"
    when 0
      content_tag :span, "Neutro (0)", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800"
    else
      content_tag :span, "Sconosciuto", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800"
    end
  end

  def stato_causale_badge(attiva)
    if attiva
      content_tag :span, "Attiva", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800"
    else
      content_tag :span, "Inattiva", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800"
    end
  end

  def di_sistema_badge(di_sistema)
    if di_sistema
      content_tag :span, "Sistema", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800"
    else
      content_tag :span, "Utente", class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800"
    end
  end
end
