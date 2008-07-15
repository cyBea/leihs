require 'digest/sha1'
class User < ActiveRecord::Base
  
  belongs_to :authentication_system
  has_many :access_rights
  has_many :inventory_pools, :through => :access_rights
  has_many :items, :through => :inventory_pools # thanks to the nested_has_many_through plugin
  has_many :models, :through => :inventory_pools, :uniq => true # thanks to the nested_has_many_through plugin
  
  has_many :orders
  has_one  :current_order, :class_name => "Order", :conditions => ["status_const = ?", Contract::NEW]

  has_many :contracts
  has_many :current_contracts, :class_name => "Contract", :conditions => ["status_const = ?", Contract::NEW]
  
  acts_as_ferret :fields => [ :login ]  #, :store_class_name => true

  def authinfo
    @authinfo ||= Class.const_get(authentication_system.class_name).new(login)
  end
  
  def email=(email)
    authinfo.email = email
  end
  
  def email
    authinfo.email
  end

################################################

  # get or create a new order (among all inventory pools)
  def get_current_order
    order = current_order
    if order.nil?
      order = Order.create(:user => self, :status_const => Order::NEW)
      reload
    end  
    order
  end

  # a user has at most one new contract for each inventory pool
  def current_contract(inventory_pool)
    current_contracts.detect {|c| c.inventory_pool == inventory_pool } # OPTIMIZE
  end
  
  # get or create a new contract for a given inventory pool
  def get_current_contract(inventory_pool)
    contract = current_contract(inventory_pool)
    if contract.nil?
      contract = Contract.create(:user => self, :status_const => Contract::NEW, :inventory_pool => inventory_pool)
      reload
    end  
    contract
  end

  # get signed contract lines, filtering the already returned lines
  def get_signed_contract_lines
    contracts.signed_contracts.collect { |c| c.contract_lines.to_take_back }.flatten
  end
  

#################### Start role_requirement
  
  # ---------------------------------------
  # The following code has been generated by role_requirement.
  # You may wish to modify it to suit your need
#sellittf#  has_and_belongs_to_many :roles
  
#sellittf#  attr_protected :roles

  
  # has_role? simply needs to return true or false whether a user has a role or not.  
  # It may be a good idea to have "admin" roles return true always
  def has_role?(role_in_question, inventory_pool_id_in_question) #sellittf# (role_in_question)
#sellittf#    @_list ||= self.roles.collect(&:name)
#sellittf#    return true if @_list.include?("admin")

#old# retrieve roles for a given inventory_pool
#sellittf#    @_list = self.access_rights.collect{|a| a.role.name if a.inventory_pool.id == inventory_pool_id_in_question }
#sellittf#    (@_list.include?(role_in_question.to_s) )

# retrieve roles for a given inventory_pool hierarchically with betternestedset plugin #sellittf#
    role = Role.find(:first, :conditions => {:name => role_in_question})
    roles = self.access_rights.collect{|a| a.role if a.inventory_pool.id == inventory_pool_id_in_question }.compact
    ( roles.any? {|r| r.full_set.include?(role)} )
  end
  # ---------------------------------------
  
#################### End role_requirement

#################### Start temp complete record

  before_validation_on_create { |record| 
    record.login ||= "bar"
    record.email ||= "#{rand(100000)}_foo@example.com"
    record.password ||= "pass"
    record.password_confirmation ||= "pass"
  }

#################### End temp complete record
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    
end
