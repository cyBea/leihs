# coding: UTF-8

# Persona:  Petra
# Job:      ZHDK Studentin
#

module Persona
  
  class Petra
    
    @@name = "Petra"
    @@lastname = "K."
    @@password = "password"
    @@email = "petra@zhdk.ch"
    @@inventory_pool_name = "A-Ausleihe"
    
    def initialize
      setup_dependencies
      
      ActiveRecord::Base.transaction do 
        select_inventory_pool 
        create_user
        create_orders
        create_overdue_hand_overs
        create_signed_contracts
      end
    end
    
    def setup_dependencies 
      Persona.create :ramon
      Persona.create :mike
      @pius = Persona.create :pius
    end

    def select_inventory_pool
      @inventory_pool = InventoryPool.find_by_name(@@inventory_pool_name)
    end
        
    def create_user
      @language = Language.find_by_locale_name "de-CH"
      @user = FactoryGirl.create(:user, :language => @language, :firstname => @@name, :lastname => @@lastname, :login => @@name.downcase, :email => @@email)
      @user.access_rights.create(:role => Role.find_by_name("customer"), :inventory_pool => @inventory_pool)
      @database_authentication = FactoryGirl.create(:database_authentication, :user => @user, :password => @@password)
    end
    
    def create_orders
      @camera_model = Model.find_by_name "Kamera Nikon X12"
      @tripod_model = Model.find_by_name "Kamera Stativ"
      @order_for_camera = FactoryGirl.create(:order, :user => @user, :inventory_pool => @inventory_pool, :status_const => 2)
      @order_for_camera_purpose = FactoryGirl.create :purpose, :description => "Für Aufnahmen im Fotokurs."
      @order_line_camera = FactoryGirl.create(:order_line, :purpose => @order_for_camera_purpose, :inventory_pool => @inventory_pool, :model => @camera_model, :order => @order_for_camera, :start_date => (Date.today + 7.days), :end_date => (Date.today + 10.days))
      @order_line_tripod = FactoryGirl.create(:order_line, :purpose => @order_for_camera_purpose, :inventory_pool => @inventory_pool, :model => @tripod_model, :order => @order_for_camera, :start_date => (Date.today + 7.days), :end_date => (Date.today + 10.days))
    end
    
    def create_overdue_hand_overs
      @beamer_model = Model.find_by_name "Sharp Beamer"
      @unsigned_contract_1 = FactoryGirl.create(:contract, :user => @user, :inventory_pool => @inventory_pool)
      @unsigned_contract_1_purpose = FactoryGirl.create :purpose, :description => "Ersatzstativ für die Ausstellung."
      FactoryGirl.create(:contract_line, :purpose => @unsigned_contract_1_purpose, :contract => @unsigned_contract_1, :model => @beamer_model, :start_date => Date.yesterday-1, :end_date => Date.today + 1)
    end
    
    def create_signed_contracts
      @unsigned_contract = FactoryGirl.create(:contract, :user => @user, :inventory_pool => @inventory_pool)
      purpose = FactoryGirl.create :purpose, :description => "Um meine Abschlussarbeit zu fotografieren."
      FactoryGirl.create(:contract_line, :purpose => purpose, :contract => @unsigned_contract, :item_id => @inventory_pool.items.in_stock.where(:model_id => @beamer_model).first.id, :model => @beamer_model, :start_date => Date.yesterday, :end_date => Date.today)
      @akku = Option.find_by_name("Akku AA")
      FactoryGirl.create(:option_line, :purpose => purpose, :contract => @unsigned_contract, :option => @akku, :start_date => Date.yesterday, :end_date => Date.today)
      @unsigned_contract.sign(nil, @pius)
    end
  end  
end
