class User < ActiveRecord::Base
  has_secure_password
  validates :username,  uniqueness: true
  belongs_to :rol 
  after_destroy :ensure_an_admin_remains
  validates :password, presence: true, length: { in: 6..20 }, :on => :create
  validates :email, 
             presence: true, 
             uniqueness: true
  validates_format_of :email, 
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, 
    :message => ' - The email provided does not have a valid format.'
  validates :name, :lastname, presence: true
  has_many :comments

  def send_password_reset
	  generate_token(:password_reset_token)
	  self.password_reset_sent_at = Time.zone.now
	  save!
	  Mailer.password_reset(self).deliver
  end

  def self.from_omniauth(auth)

    @aux = User.find_by(email: auth.info.email)

    if @aux.blank?
      where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|

          user.provider = auth.provider
          user.uid = auth.uid
          user.name = auth.info.first_name
        if :provider == "facebook"  
          user.password = "FBzRGEbIp-"
          user.username = auth.info.name + "_fb"
        elsif :provider == "google_oauth2"
          user.password = "GLOTzRGEbIp-"
          user.username = auth.info.name + "_gl"
        else
          user.password = "OTzRGEbIp-" 
          user.username = auth.info.name + "_ot"   
        end  
          user.email = auth.info.email
          user.lastname = auth.info.last_name
          @rol = Rol.find_by(rol_name: 'usuario')
          user.rol_id = @rol.id
          user.oauth_token = auth.credentials.token
          user.oauth_expires_at = Time.at(auth.credentials.expires_at)
          
          begin
            #some logic
             user.save 
          rescue ActiveRecord::RecordNotSaved => e
            redirect_to root_url, notice: 'su correo ya esta registrado, use uno diferente' 
          end
                     
      end
    else
      user = @aux  
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  private
    def ensure_an_admin_remains
		  if User.count.zero?
        raise "Can't delete last user"
		  end
    end
    
end
