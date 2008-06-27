class Backend::AcknowledgeController < Backend::BackendController
  require_role "inventory_manager" # TODO

  before_filter :load_order, :except => :index

  def index
#old#    @submitted_orders = Order.submitted_orders
    @submitted_orders = current_inventory_pool.orders.submitted_orders
    @working_orders = @submitted_orders.select { |o| o.has_backup? }

    if params[:search]
      params[:search] = "*#{params[:search]}*" # search with partial string
#old#      @orders = Order.find_by_contents(params[:search], {}, {:conditions => ["status_const = ?", Order::SUBMITTED]})
      @orders = @submitted_orders.find_by_contents(params[:search])
    elsif params[:user_id]
#old#      @orders = User.find(params[:user_id]).orders.submitted_orders
      # OPTIMIZE named_scope intersection?
      @orders = @submitted_orders.select { |o| o.user.id == params[:user_id].to_i}
    end
    
    render :partial => 'orders' if request.post?
  end
  
  def show
    @order.to_backup unless @order.has_backup?
    set_order_to_session(@order)
  end
  
  def approve
    if request.post? and @order.approve(params[:comment])
      
      remove_order_from_session
      redirect_to :action => 'index'
    else
      render :layout => $modal_layout_path
    end    
  end
  
  def reject
    if request.post?
      @order.status_const = Order::REJECTED
      @order.backup = nil
      @order.save
      OrderMailer.deliver_rejected(@order, params[:comment])
      
      remove_order_from_session
      redirect_to :action => 'index'
    else
      render :layout => $modal_layout_path
    end
  end 

  def restore
    if request.post?
      @order.from_backup      
      redirect_to :controller=> 'acknowledge', :action => 'index'        
    else
      render :layout => $modal_layout_path
    end
  end 
  
  def destroy
     if request.post?
        @order.destroy
        remove_order_from_session
        redirect_to :controller=> 'acknowledge', :action => 'index'
    else
      render :layout => $modal_layout_path
    end    
  end

  def add_line
    generic_add_line(@order, @order.id)
  end

  def swap_model_line
    generic_swap_model_line(@order, @order.id)
  end
  
  # change quantity for a given line
  def change_line
    if request.post?
      @order_line = OrderLine.find(params[:order_line_id])
      @order = @order_line.order
      required_quantity = params[:quantity].to_i

      @order_line, @change = @order.update_line(@order_line.id, required_quantity, session[:user_id])
      @maximum_exceeded = required_quantity != @order_line.quantity
      @order.save
    end
  end

  def time_lines
    generic_time_lines(@order, @order.id)
  end    
  
  def remove_lines
    generic_remove_lines(@order, @order.id)
  end

  def add_options
    @option = params[:option_id].nil? ? Option.new : Option.find(params[:option_id]) 
    if request.post?
      params[:lines].each do | ol | 
        line = OrderLine.find(ol)
        option = Option.new(params[:option])
        if option.save
          line.options << option
          line.save
          @order.log_change(_("Added Option:") + " (#{option.quantity}) #{option.name}", session[:user_id])
        else
          flash[:notice] = _("Couldn't create option.")
        end
      end
      redirect_to :controller=> 'acknowledge', :action => 'show', :id => @order.id      
    else
      @order_lines = OrderLine.find(params[:lines].split(','))
      render :layout => $modal_layout_path      
    end
  end

  def remove_options
     if request.post?
        params[:options].each {|o| @order.remove_option(o, session[:user_id]) }
        redirect_to :controller=> 'acknowledge', :action => 'show', :id => @order.id
    else
      @options = Option.find(params[:options].split(','))
      render :layout => $modal_layout_path
    end   
  end


  def change_purpose
    if request.post?
      @order.change_purpose(params[:purpose], session[:user_id])
      redirect_to :controller=> 'acknowledge', :action => 'show', :id => @order.id
    else
      render :layout => $modal_layout_path
    end
  end
    
   def swap_user
    if request.post?
      if params[:user_id].nil?
        flash[:notice] = _("User must be selected")
      else
        @order.swap_user(params[:user_id], session[:user_id])
      end  
      redirect_to :controller=> 'acknowledge', :action => 'show', :id => @order.id        
    else
      redirect_to :controller => 'users', 
                  :action => 'search',
                  :id => params[:id],
                  :source_controller => 'acknowledge',
                  :source_action => 'swap_user'
    end
  end   

    
    
  private
  
  def load_order
      @order = Order.find(params[:id], :conditions => { :status_const => Order::SUBMITTED }) if params[:id]
    rescue
      redirect_to :action => 'index' unless @order
  end
    
end
