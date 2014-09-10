Rails.application.routes.draw do

  resources :contacts

=begin
  get 'dashboard/index'

  get 'dashboard/login'

  get 'dashboard/equipos'

  get 'dashboard/gallerias'

  get 'dashboard/imagenes'

  get 'dashboard/videos'
=end

  resources :discounts

  resources :categories

  resources :brands

  resources :packages

  resources :comments

  resources :videos

  resources :images

  resources :galleries

  resources :equipment


  get 'welcome/index'

  resources :module5s

  resources :module4s

  resources :module3s

  resources :module2s

  resources :module1s

  get 'password_resets/new'

  get 'admin' => 'admin#index'

  controller :sessions do
    get 'login' => :new , :as => "login"
    post 'login' => :create
    delete 'logout' => :destroy
  end

  controller :welcome do
    get 'welcome/index' => :new
    post 'welcome/index' => :create
    delete 'welcome/index' => :destroy
    delete 'welcome/logout' => :destroy
    #post '/' => :create
    #delete '/' => :destroy
    #delete '/logout' => :destroy
  end

  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/destroy'

  resources :welcome

  resources :users

  resources :rols

  resources :password_resets

  controller :users do
    get 'recover_password' => :recover_password
    post 'recover_password' => :recover_password 
    get 'new_recover_password' => :new_recover_password
    post 'new_recover_password' => :new_recover_password 
    get 'cambiar_password' => :cambiar_password
    post 'cambiar_password' => :cambiar_password
    get 'new_cambiar_password' => :new_cambiar_password
    post 'new_cambiar_password' => :new_cambiar_password
  end 


  #preparacion para usar rutas amigables o traducidas segun se ocupe

  controller :galleries do
    get ':id/galerias' => :index , :as => 'galeria_index'
    get ':equip/galerias/:id' => :show , :as => 'galeria_show_p'
    get 'Mi_Panel/:equip/galerias/:id' => :show , :as => 'galeria_show'
    get 'Mi_Panel/:equip/galeria_nueva/' => :new , :as => 'galeria_nueva'
    post 'Mi_Panel/:equip/galeria_nueva/' => :new
    get 'Mi_Panel/:equip/galeria/:id/editar' => :edit , :as => 'galeria_edit'
    post 'Mi_Panel/:equip/galeria/:id/editar' => :edit
  end  
  controller :videos do
    get 'Mi_Panel/:equip/:gal/videos' => :index , :as => 'video_index'
    get 'Mi_Panel/:equip/:gal//videos/:id' => :show , :as => 'video_show'
    get 'Mi_Panel/:equip/:gal/video_nuevo' => :new, :as => 'video_nuevo'
    post 'Mi_Panel/:equip/:gal/video_nuevo' => :new
    get 'Mi_Panel/:equip/:gal/:id/editar' => :new , :as => 'video_edit'
    post 'Mi_Panel/:equip/:gal/:id/editar' => :new
  end  
  controller :images do
    get 'Mi_Panel/:equip/:gal/imagenes' => :index, :as => 'imagen_index'
    get 'Mi_Panel/:equip/:gal/imagenes/:id' => :index , :as => 'imagen_show'
    get 'Mi_Panel/:equip/:gal/imagen_nueva' => :new, :as => 'imagen_nueva'
    post 'Mi_Panel/:equip/:gal/imagen_nueva' => :new
    get 'Mi_Panel/:equip/:gal/editar/:id' => :edit, :as => 'imagen_editar'
    post 'Mi_Panel/:equip/:gal/editar/:id' => :edit
    get 'change_image/:image/:equipment/:gallery' => :select_image , :as => 'select_image'
  end

  controller :comments do
    get 'Mi_Panel/:id/comentarios' => :index, :as => 'comentarios_index'
    get 'Mi_Panel/:equip/comentarios/:id' => :show, :as => 'comentarios_show'
    get 'Mi_Panel/:id/comentario_nuevo' => :new, :as => 'comentario_nuevo'
    post 'Mi_Panel/:id/comentartio_nuevo' => :new
    get 'Mi_Panel/:equip/editar/:id' => :edit, :as => 'comentario_editar'
    post 'Mi_Panel/:equip/editar/:id' => :edit
  end   

  controller :equipment do
    get 'Filtro' => :grid 
    post 'Filtro' => :grid    
    get '/equipo/contacto' => :contact
    post '/equipo/contacto' => :contact
    post '/send' => :sender
    get '/previsalizar/:id' => :preview , as: 'preview'
    #delete '/equipo/:id' => :destroy , :as =>'destroy_equip'
    get 'Mi_Panel/:equip/impulsar' => :master_console, :as => 'master_console'
    post 'Mi_Panel/:equip/impulsar' => :master_console_exe , :as => 'master_console_exe'
    get  'equipos/resultados' => :search , :as => 'search'
    post 'equipos/resultados' => :search
    get 'equipos/listado' => :users_view, :as => 'users_view'
    get 'industrias/:industria' => :industry, :as => 'industry'
    post 'industrias/:industria' => :industry
    get 'fav_new' => :add_favorito, :as => 'new_fav'
    get 'fav_destroy' => :removed_favoritos, :as => 'del_fav'
    get 'reactivar/:equipment' => :reactivate, :as => 'reactivate'
    get 'anuncios' => :temporal, :as => 'anuncios_t'
  end

  controller :dashboard do
    get 'Mi_Panel' => :index, :as => 'dashboard_index' 
    get 'Mi_Panel/Administracion_de_Cuenta' =>:login, :as => 'dashboard_login'
    get 'Mi_Panel/equipos' => :equipos, :as => 'dashboard_equipos'
    get 'Mi_Panel/:equip/galerias' => :gallerias, :as => 'dashboard_gallerias'
    get 'Mi_Panel/:equip/:gal/imagenes' => :imagenes, :as => 'dashboard_imagenes'
    get 'Mi_Panel/:equip/:gal/videos' => :videos, :as => 'dashboard_videos'
    get 'Mi_Panel/Mis_Equipos' => :equip_history, :as => 'dashboard_equip_history'
    get 'Mi_Panel/Reporte_de_Estado' => :report_status, :as => 'dashboard_status_rep'
    get 'Mi_Panel/Mis_Equipos_Favoritos' => :favorites , :as => 'dashboard_favorite'
  end  

  controller :categories do
    get 'category/vista' => :vista
  end
  
  get 'auth/:provider/callback', to: 'sessions#createfb'
  post 'auth/:provider/callback', to: 'sessions#createfb'
  #, via: [:get, :post]
  get 'auth/failure', to: redirect('/')
  post 'auth/failure', to: redirect('/')
  #, via: [:get, :post]
  get 'signout', to: 'sessions#destroy'
  post 'signout', to: 'sessions#destroy'
  #, as: 'signout', via: [:get, :post]

  get 'auth/google_oauth2/callback?error=access_denied', to: redirect('/')
  get 'nosotros', to: 'welcome#nosotros'
  get 'especiales', to: 'welcome#especiales'
  get 'marcas', to: 'welcome#marcas'
  get 'contactanos', to: 'welcome#contactanos'      

  #get '*unmatched_route', :to => 'application#raise_not_found2'



  #get 'welcome' => 'index#welcome'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
