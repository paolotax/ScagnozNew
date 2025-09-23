# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym "RESTful"
# end

# Italian inflections for warehouse management system
ActiveSupport::Inflector.inflections(:en) do |inflect|
  # Magazzini
  inflect.irregular "magazzino", "magazzini"

  # Articoli
  inflect.irregular "articolo", "articoli"

  # Soggetti
  inflect.irregular "soggetto", "soggetti"

  # Documenti
  inflect.irregular "documento", "documenti"

  # Giacenze
  inflect.irregular "giacenza", "giacenze"

  # Numeratori
  inflect.irregular "numeratore", "numeratori"

  # Causali magazzino
  inflect.irregular "causale_magazzino", "causali_magazzino"

  # Righe documento
  inflect.irregular "riga_documento", "righe_documento"

  # Movimenti magazzino
  inflect.irregular "movimento_magazzino", "movimenti_magazzino"

  # Righe movimento magazzino
  inflect.irregular "riga_movimento_magazzino", "righe_movimento_magazzino"
end
