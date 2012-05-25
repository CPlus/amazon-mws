require 'set'

module Amazon
  module MWS

    class FeedBuilder
      attr_accessor :xml

      def initialize(message_type, messages = [], params = {})
        @xml = Builder::XmlMarkup.new(:indent=>2)
        @message_type = message_type
        @messages = messages
        @params = params
        @merchant_id = params[:merchant_id]
      end

      def render
        @xml.instruct!
        @xml.AmazonEnvelope("xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance", "xsi:noNamespaceSchemaLocation"=>"amzn-envelope.xsd") do
          render_header
          
          envelope_params = { :message_type => @message_type }
          envelope_params.merge!({:purge => @params[:purge]}) if Feed::Enumerations::PRODUCT_MESSAGE_TYPES.include?(@message_type) && @params[:purge]==true
          envelope_params.merge!({:marketplace_name => @params[:marketplace_name]}) if !@params[:marketplace_name].blank?
          render_envelope(envelope_params)
          
          if !@messages.nil?
            @messages.flatten.each_with_index do |message,i|
              ordered_message = ActiveSupport::OrderedHash.new
              if message[:MessageID].nil?
                ordered_message["MessageID"] = i + 1
              end
              ordered_message.merge!(message)
              render_message(ordered_message, @params)
            end
          end
        end
      end

      def render_header
        @xml.Header do
          @xml.DocumentVersion "1.2"
          @xml.MerchantIdentifier @merchant_id
        end
      end

      def render_envelope(params = {})
        #@xml.EffectiveDate Time.now
        @xml.MessageType(params[:message_type].to_s)
        # @xml.PurgeAndReplace(params[:purge] || false)
        @xml.MarketplaceName(params[:marketplace_name]) if !params[:marketplace_name].blank?
      end

      def render_message(message, params = {})
        if (message.is_a?(Hash) || message.is_a?(YAML::Omap))
          @xml.Message do |xml|
            build_xml(message, xml)
          end
        else
          raise "Unknown type for: #{message.inspect}"
        end
      end

      # Hack exceptional cases added for elements with 1 and 2 attributes
      def build_xml(hash, xml)
        hash.each {|key, value|
          case value
            when Hash then xml.tag!(key) {|xml| build_xml(value, xml) }
            when YAML::Omap then xml.tag!(key) {|xml| build_xml(value, xml) }
            #when Array then xml.tag!(key) {|xml| value.each {|v| build_xml(v, xml) } }
            when Array then
              case value.first
                when Hash then xml.tag!(key) {|xml| value.each {|v| build_xml(v, xml) } }
                else # array can include hashes for attributes, but not in the first slot
                  if value.length==2 && value[1].is_a?(Hash) && value[1].length==1 # first slot is not a hash, second might be (for attribute)
                    xml.tag!(key, value[0], value[1])
                  elsif value.length==3 && value[1].is_a?(Hash) && value[1].length==1 && value[2].is_a?(Hash) && value[2].length==1
                    xml.tag!(key, value[0], value[1], value[2])
                  else
                    value.each { |v| xml.tag!(key, v) } # accept array of non-hashes and create a <key>value_x</key> for each
                  end
              end
            else xml.tag!(key, value)
          end
        }
      end
    end
  end
end
