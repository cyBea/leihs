module Availability2

    class Observer < ActiveRecord::Observer
      observe :order_line, :contract_line, :item
      
      # TODO bulk recompute if many lines are updated together
      
      def recompute(record)
        if record.is_a?(Item) and record.inventory_pool
            Availability2::Change.recompute(record.model, record.inventory_pool)
        elsif (record.is_a?(OrderLine) and record.order.status_const == Order::SUBMITTED) or record.is_a?(ContractLine)
            Availability2::Change.recompute(record.model, record.document.inventory_pool)
        end
      end
      
      def after_save(record)
        recompute(record)
      end

      def after_destroy(record)
        recompute(record)
      end
    end

end