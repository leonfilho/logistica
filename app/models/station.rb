class Station < ActiveRecord::Base
   establish_connection Rails.configuration.database_configuration["cad"]
   set_table_name 'admcad.secao'
   set_primary_key 'cod_objeto'

   belongs_to :place, :foreign_key => "cod_objeto_local"
   belongs_to :city, :foreign_key => "cod_objeto_munic"
   belongs_to :zone, :foreign_key => "cod_objeto_zona"
   
   scope :mt, where("cod_objeto_uf" => "18")
   scope :ativas, where(:situacao => 1)
   scope :junta, joins(:place,:city,:zone).order("#{Zone.table_name}.num_zona").order("#{City.table_name}.nom_localidade").order("#{Place.table_name}.num_local")

   scope :boas, mt.ativas.junta
   
   def zone_id
      self[:cod_objeto_zona]
   end
   
   def city_id
      self[:cod_objeto_munic]
   end
   
   def place_id
      self[:cod_objeto_local]
   end
   
   def id
      self[:cod_objeto]
   end
   
   def numero
      self[:num_secao]
   end
   
   def self.por_zona_municipio(zona, municipio)
      ativas.where(:cod_objeto_zona => zona).where(:cod_objeto_munic => municipio).order(:cod_objeto_zona).order(:cod_objeto_munic)
   end
end
