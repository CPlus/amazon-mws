module Amazon
  module MWS
    class Orders
			
			def request_orders_list(params ={})
        
				created_after = params[:created_after]
        created_before = params[:created_before]
				last_updated_after = params[:last_updated_after]
        last_updated_before = params[:last_updated_before]
				buyer_email = params[:buyer_email]
        seller_order_id = params[:seller_order_id]
				results_per_page = params[:results_per_page]
        fulfillment_channel = params[:fulfillment_channel]
				order_status = params[:order_status]
				marketplace_id = params[:marketplace_id]

      
        query_params = {
          "Action"   => "ListOrders"
        }
      
        query_params.merge!({"CreatedAfter" => created_after}) if created_after
        query_params.merge!({"CreatedBefore" => created_before}) if created_before
				query_params.merge!({"LastUpdatedAfter" =>last_updated_after}) if last_updated_after
        query_params.merge!({"LastUpdatedBefore" => last_updated_before}) if last_updated_before
				query_params.merge!({"BuyerEmail" => buyer_email}) if buyer_email
				query_params.merge!({"SellerOrderId" => seller_order_id}) if seller_order_id
        query_params.merge!({"MaxResultsPerPage" => results_per_page}) if results_per_page
				
				if fulfillment_channel
					i = 1
					fulfillment_channel.to_a.each{|channel| query_params.merge!({'FulfillmentChannel.Channel.#{i++}' => channel})}
				end
	 			
				if order_status
					i = 1
					order_status.to_a.each{|status| query_params.merge!({'OrderStatus.Status.#{i++}' => status})}
				end
				
				if marketplace_id
					i = 1
					marketplace_id.to_a.each{|id| query_params.merge!({'MarketplaceId.Id.#{i++}' => id})}
				end
            
        response = get("/Orders/", query_params)
        response
      end
			
			def request_list_order_items(params ={})
        amazon_order_id = params[:amazon_order_id]
        
        query_params = {
          "Action"   => "ListOrderItems"
        }
      	if amazon_order_id
		      query_params.merge!({"AmazonOrderId" => amazon_order_id}) 
		      response = get("/Orders/", query_params)
		      response
				end
      end
    end
  end
end
