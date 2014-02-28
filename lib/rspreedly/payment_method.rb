module RSpreedly
  module PaymentMethod
    class CreditCard < Base
      attr_accessor :number, :verification_value, :month, 
                    :year, :first_name, :last_name, :card_type,
                    :address1, :address2, :city, :state, :zip, :country,
                    :phone_number, :customer_id
      class << self
        def find(id)
          return all if id == :all

          begin
            data = api_request(:get, "/subscribers/#{id}.xml")
            RSpreedly::PaymentMethod::CreditCard.new(:customer_id => data["subscriber"]['customer_id'])
          rescue RSpreedly::Error::NotFound
            nil
          end
        end
      end
      
      # update an credit card (more)
      def update
        begin
          update!
        rescue RSpreedly::Error::Base
          nil
        end
      end

      def update!
        result = api_request(:put, "/subscribers/#{self.customer_id}.xml", :body => self.to_xml(:outer => 'subscriber', :tag => 'payment-method', :inner => "credit-card"))
        self.attributes = result["subscriber"]
        true      
      end
    end
    class OnFile < Base
       def to_xml(opts=nil)
         "<payment> <account-type>on-file</account-type> </payment>"
       end
    end
  end
end