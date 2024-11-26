module PandaCore
  module Services
    class BaseService
      def self.call(*args)
        new(*args).call
      end

      private

      def success(payload = {})
        OpenStruct.new(success?: true, payload: payload)
      end

      def failure(errors)
        OpenStruct.new(success?: false, errors: errors)
      end
    end
  end
end 
