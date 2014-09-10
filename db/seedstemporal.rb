#!/bin/env ruby
# ruby encoding: utf-8

# ############### PARAMETROS ###############
# name
# etiquetas
# description
# category_id
# subcategory_id
# brand_id
# modelo
# year
# color
# country_id
# state_id
# ciudad
# publication_type
# precio
# currency_id
# package_id
# user_id
# status
# ##############################

# ############## NECESITAN BUSQUEDAS #################
# category_id
# subcategory_id
# brand_id
# country_id
# state_id
# currency_id
# package_id
# user_id
# ################################


################ BUSQUEDAS ###############
@cat1 = Category.find_by(title: 'Camiones')
@cat7 = Category.find_by(title: 'Maquinaria para Mineria')

@subcat37 = Subcategory.find_by(title: 'Montacargas')
@subcat3 = Subcategory.find_by(title: 'Plataformas')
@subcat63 = Subcategory.find_by(title: 'Pipa de Agua')

@brand28 = Brand.find_by(name: 'Hyster')
@brand12 = Brand.find_by(name: 'JLG')
@brand29 = Brand.find_by(name: 'Sterling')
@brand30 = Brand.find_by(name: 'Raymond')

@country = Country.find_by(name: 'Mexico')

@state = State.find_by(name: 'Tamaulipas')

@currency = Currency.find_by(name: 'M.N.')

@package = Package.find_by(name: 'Basico')

@user = User.find_by(username: 'admin@admin.com')
################################


###############################
@equip1 = Equipment.new(name:'MONTACARGAS HYSTER H80XL CAP. 8000LBS', 
etiquetas:'montacargas, montacargas gas', 
description:'
MONTACARGAS  TIPO GAS
MARCA: HYSTER
MODELO: H80XL
CAPACIDAD 8000 LBS
AÑO: 1998
SERIE: G005D11714V
ELEVACION DE CUCHILLAS 190"
TIPO DE LLANTAS NEUNMATICAS(AIRE)
MEDIDA DE LLANTAS DELANTERAS : 29X8-15"
MEDIDA DE LLANTAS TRASERAS: 7.00-12-12"
TAMAÑO DE CUCHILLAS
20" ALTURA
44" LONGITUD',
category_id: @cat1.id, 
subcategory_id: @subcat37.id, 
brand_id: @brand28.id, 
modelo: 'H80XL', 
year: '1998', 
color: 'amarillo', 
country_id: @country.id, 
state_id: @state.id, 
ciudad: 'Reynosa', 
publication_type: '1', 
precio: '1', 
currency_id: @currency.id, 
package_id: @package.id, 
user_id: @user.id, 
status: '2')

@equip1.save

@galeria1 = Gallery.new(title: 'principal', equipment_id: @equip1.id)
@galeria1.save

############################################################

@equip2 = Equipment.create(name:'BOOM LIFT E300AJP', 
description:'
Alcance Altura de la plataforma 9.14m
Alcance horizontal 6.10m
Altura global 3.99m
Rotación 360º Non-Continuous
Capacidad de la plataforma 230kg
Giro de plataforma 180º
Hydraulic Brazo 1.24m
Mayor versatilidad con la posibilidad de elegir entre dos modelos con alturas de trabajo hasta los 11,00 m 
Aumento de la accesibilidad gracias al plumín JibPLUS opcional con movimiento de lado a lado y funcionamiento del plumín casi vertical
Control automático de la tracción de serie que ofrece un mejor rendimiento sobre el terreno y mayor capacidad de maniobra 
Tracción eléctrica directa sumamente eficiente con ciclos de trabajo más largos, que aumenta la productividad 
Emisión de gases cero, que hace que los equipos sean ecológicos',
category_id: @cat7.id, 
subcategory_id: @subcat3.id, 
brand_id: @brand12.id, 
modelo: 'E300AJP', 
year: '2001', 
color: 'naranja', 
country_id: @country.id, 
state_id: @state.id, 
ciudad: 'Reynosa', 
publication_type: '1', 
precio: '1', 
currency_id: @currency.id, 
package_id: @package.id, 
user_id: @user.id, 
status: '2')

@equip2.save

@galeria2 = Gallery.new(title: 'principal', equipment_id: @equip2.id)
@galeria2.save

############################################################

@equip3 = Equipment.create(name:'PLATAFORMA JLG 3394RT', 
etiquetas:'plataformas, boom lift', 
description:
'33\' Max Lift Height
2,250 lb. MaxWeight Capacity
4x4
Platform Extension
Dual Fuel
Ford Engine
89" Wide x 153" Long Platform
Lectura métrica: 2,396 Horas',
category_id: @cat7.id, 
subcategory_id: @subcat3.id, 
brand_id: @brand12.id, 
modelo: '3394RT', 
color: 'naranja', 
country_id: @country.id, 
state_id: @state.id, 
ciudad: 'Reynosa', 
publication_type: '1', 
precio: '1', 
currency_id: @currency.id, 
package_id: @package.id, 
user_id: @user.id, 
status: '2')

@equip3.save

@galeria3 = Gallery.new(title: 'principal', equipment_id: @equip3.id)
@galeria3.save

############################################################

@equip4 = Equipment.create(name:'Pipa de Agua para Riego 2013', 
etiquetas:'pipa de agua, pipa para riego, camion de riego', 
description:' Especificaciones:
Largo exterior 4 mts.
Ancho exterior:1.93 mts
Alto interior: 1.22 mts
Capacidad 2,500 Galones
Tractocamion Sterling 2007
 
Motobomba incluida
marca Champion semitrash
Potencia 5.5Conexiones de entrada 2"
Flujo 158 G.p.m
Conexión rápida de aluminio
manguera de succion de 12\'
manguera de descarga 20\'',
category_id: @cat1.id, 
subcategory_id: @subcat63.id, 
brand_id: @brand29.id, 
modelo: 'Sterling', 
year: '2013', 
color: 'blanco', 
country_id: @country.id, 
state_id: @state.id, 
ciudad: 'Reynosa', 
publication_type: '1', 
precio: '1', 
currency_id: @currency.id, 
package_id: @package.id, 
user_id: @user.id, 
status: '2')

@equip4.save

@galeria4 = Gallery.new(title: 'principal', equipment_id: @equip4.id)
@galeria4.save

################################

@equip5 = Equipment.create(name:'Montacargas Raymond 9600 Swing Reach-CSR 30T ACR System', 
etiquetas:'Montacargas, lateral, plataforma, levante', 
description:'Montacargas Raymond de Ataque Lateral con Plataforma con levante
Palanca de Control “EASi” multifuncional de diseño ergonómico con :
Control de dirección
Velocidad de traslado
Elevación y descenso de plataforma y horquillas
Elevación y descenso de minimástil
Movimiento lateral en ambas direcciones
Giro de portahorquillas
Claxon
Capacidad de realizar operaciones simultaneas
Pantalla digital con comunicación básica en plataforma para operador :
* Indicador de descarga de batería
* Fecha y hora
* Sensor de peso
* Indicador de posición de rueda direccional / motriz
* Indicador de posición de carro y giro de horquillas
* Altura de levante
* Monitoreo de la operación 
* Autodiagnóstico permanente
* Tres horómetros en pantalla ( encendido, viaje y levante) y odómetro(kilometraje).
* Reflejo de comunicación básica en vidrio frontal por pantalla especial.
Procesador “intellidrive” para control de traslado:
cambios de dirección controlados con transistores (sin contactores)
Autodiagnóstico y monitoreo al 100% con código de fallas en pantalla
Programación de la operación en cuanto a: velocidades, frenado, consumo de batería, aceleraciones, mantenimiento y otros.
Simulación de operación y diagnóstico en programa de mantenimiento
Aprovechamiento e incremento de aceleración inteligente
Levante y descenso de velocidad variable

SISTEMA ELECTRICO: 

RUEDAS:
Rueda direccional motriz de poliuretano de 15” x 6” (381 X 152 mm)
Ruedas de carga de poliuretano suave de 14” x 8” ( 356 X 203 mm)

VELOCIDADES:
48 Volts ; Sistema regenerativo de recarga de batería.
Traslado con / sin carga : 6.0 / 6.0 mph
Levante con / sin carga: 80 / 70 fpm 
Descenso con / sin carga: 100 / 100 fpm
Levante mástil Auxiliar : 80 / 80 fpm 
Descenso mástil Auxiliar : 60 / 60 fpm 
Rotación de horquillas: 6.5 segundos 
FRENOS: 1) freno hidráulico de balata y 2) freno electrónico permitido con inversión de dirección.

MOTORES:
Tres motores independientes: tracción, levante y dirección (auxiliar)
Motores de tracción y levante de Corriente Alterna

PASILLOS: 
A) De Operación:
Sin rotación de la carga en el pasillo de trabajo= 66”/ 1,676 mm.
Con rotación de carga 180° en pasillo de trabajo: ( según tamaño de tarima) Con tarimas de : 40" (1016 mm) x 48" (1219 mm) = pasillo de 72” /1,829 mm.
B) De intersección: 166” ( 4,21 mm. )
CAPACIDAD DE CARGA: 1,361 Kg ( 3,000 lb.) a 6,096 mm. (240”)
1,134 Kg ( 2,500 lb.) a 7,620 mm. (300”)
1,089 Kg ( 2,400 lb.) a 8,026 mm. (316”)

ACCESORIOS INCLUIDOS:
* Luces de trabajo en compartimiento del operador y ventilador.
* Asiento de operador con suspensión, rotación y ajuste de descansa brazos
* Puertas laterales abatibles.
* Asistente de navegación.
* Vidrio en guarda del mástil
* Rodillos en compartimiento de baterías
* Torreta
* Arnés de seguridad para el operador y cable de vida
* Sensor de peso
* Indicador de Altura
* Indicador de carga en batería
* Batería 48 Volts 750 amperes
* Cargador Trifásico 48 Volts 775 amperes

SEGURIDAD:
Cumple con los requerimientos de OSHA y ANSI categoría “E” según “UL”
Freno de estacionamiento de aplicación automática
Cinturón y gancho de seguridad para el operador
Desconexión de energía de emergencia',
category_id: @cat1.id, 
subcategory_id: @subcat37.id, 
brand_id: @brand30.id, 
modelo: 'Sterling', 
year: '2013', 
color: 'blanco', 
country_id: @country.id, 
state_id: @state.id, 
ciudad: 'Reynosa', 
publication_type: '1', 
precio: '1', 
currency_id: @currency.id, 
package_id: @package.id, 
user_id: @user.id, 
status: '2')

@equip5.save

@galeria5 = Gallery.new(title: 'principal', equipment_id: @equip5.id)
@galeria5.save
################################