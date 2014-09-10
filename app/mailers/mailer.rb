class Mailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mailer.reset_password.subject
  #
  def reset_password(user,uemail)
    @greeting = "Hi"
    @user = user
    #mail to: uemail
    mail(:to => uemail, :subject => "Password Reset", :from => "\"Arturito Lopez\" ")

  end


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mailer.recover_password.subject
  #
  def recover_password(user,uemail)
    @greeting = "Hi"
    @user = user
    #mail to: uemail
    mail(:to => uemail, :subject => "Recuperacion de Password", :from => "\"Arturito Lopez\" ", :reply_to =>"arturito@tbf.com")
  end

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset" , :from => "\"Arturito Lopez\" ", :reply_to =>"arturito@tbf.mx"
  end

  def create_user(user)
    @user = user
    mail :to => user.email, :subject => "Se creo su usuario", :from => "\"Arturito Lopez\" ", :reply_to =>"arturito@tbf.mx"
  end
  def create_equip(user,equip)
    @user = user
    @equipment = equip
    mail :to => user.email, :subject => "Se creo su Anuncio", :from => "\"Arturito Lopez\" ", :reply_to =>"arturito@tbf.mx"
  end

  def destroy_user(user)
    @user = user
    mail :to => user.email, :subject => "Su usuario a sido destruido", :from => "\"Arturito Lopez\" ", :reply_to =>"arturito@tbf.mx"
  end

#intento de mailer
  def equipment_contact(buyer_m,buyer_n,buyer_ms,buyer_p,seller,equipment)

    # puts "----------------------buyer_m-----------------------------------"
    # puts buyer_m.inspect
    # puts "----------------------------------------------------------------"

    # puts "----------------------buyer_n-----------------------------------"
    # puts buyer_n.inspect
    # puts "----------------------------------------------------------------"

    # puts "----------------------buyer_ms----------------------------------"
    # puts buyer_ms.inspect
    # puts "----------------------------------------------------------------"

    # puts "----------------------buyer_p-----------------------------------"
    # puts buyer_p.inspect
    # puts "----------------------------------------------------------------"

    # puts "----------------------seller------------------------------------"
    # puts seller.inspect
    # puts "----------------------------------------------------------------"

    # puts "----------------------equipment---------------------------------"
    # puts equipment.inspect
    # puts "----------------------------------------------------------------"

    @buyer_m = buyer_m
    @buyer_ms = buyer_ms
    @buyer_n = buyer_n
    @buyer_p = buyer_p
    @seller = seller
    @equipment = equipment        
    mail(:to => @seller.email, :subject => "Nueva notificacion EYM anuncio", :from => "\"EYM\" ", :reply_to =>"arturito@tbf.mx")
    #puts "---------------------pase el primero---------------------"
    #mail(:to => buyer_m, :subject => "Nueva notificacion EYM anuncio" + equipment.name.to_s, :from => "\"EYM\" ", :reply_to =>"arturito@tbf.mx")
    #puts "---------------------pase el segundo---------------------"
  end 

  def contact_send(obj)
    @body_data = obj
    mail(:to => @body_data.email, :subject => "Tiene una peticion de contacto de su sitio Equipos Y Maquinarias", :from => "\"EYM\" ", :reply_to => @body_data.email)


  end 

end
