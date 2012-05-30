class Amazon::MWS::Authentication

  class QueryString < String
    def initialize(params = {})
      query_params = {
        'AWSAccessKeyId'   => params[:access_key],
        'MarketplaceIdList.Id.1'      => params[:marketplace_id],
        'SignatureMethod'  => Signature::METHOD,
        'SignatureVersion' => Signature::VERSION,
        'Timestamp'        => Time.now.iso8601
      }
      
      if params[:path].include? 'Orders'
      	query_params['SellerId'] = params[:merchant_id]
      	query_params['Version'] = Amazon::MWS::Authentication::ORDERS_VERSION
      else
      	query_params['Merchant'] = params[:merchant_id]
      	query_params['Version'] = Amazon::MWS::Authentication::VERSION      	
      end

      # Add any params that are passed in via uri before calculating the signature
      query_params = query_params.merge(params[:query_params] || {})
      # Calculate the signature
      query_params['Signature'] = Signature.new(query_params, params)

      self << formatted_querystring(query_params)
    end

    def formatted_querystring(query_params)
      query_params.collect { |key, value| [CGI.escape(key.to_s), CGI.escape(value.to_s)].join('=') }.join('&') # order doesn't matter for the actual request
    end
  end

end
