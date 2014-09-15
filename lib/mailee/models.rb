# coding: utf-8
require 'faraday_middleware'
require 'her'

credentials = {api_key: "869a72b17b05a", subdomain: "mailee-api"}
Her::API.setup url: "https://api.mailee.me/v2/", params: credentials do |c|
  # Request
  c.use Faraday::Request::UrlEncoded
  # Response
  #c.use MyCustomParser
  c.use Her::Middleware::DefaultParseJSON
  # Adapter
  c.use Faraday::Adapter::NetHttp
end

module Mailee

  class Contact

    include Her::Model
    store_response_errors :errors

    def self.find_by params
      get("contacts", where: params)
    end

    def self.find_by_internal_id iid
      find_by internal_id: iid
    end

    def find_by_email email
      find_by email: email
    end

    # expect list: {id: 1234} or list{name: abcd}
    def list_subscribe(list)
      r = self.class.put_raw("contacts/#{self.id}/list_subscribe", format_param(list))
      if r[:parsed_data][:errors].empty?
        return true
      else
        return raise r[:parsed_data][:errors].to_json
      end
    end

    def list_unsubscribe(list)
      r = self.class.put_raw("contacts/#{self.id}/list_unsubscribe", format_param(list))
      if r[:parsed_data][:errors].empty?
        return true
      else
        return raise r[:parsed_data][:errors].to_json
      end
    end

    def unsubscribe
      r = self.class.put("contacts/#{self.id}/unsubscribe")
      r.errors.empty? ? true : r.errors.to_json
    end

    protected

    def format_param param
      if param.is_a? Fixnum
        {list_id: param}
      elsif param.has_key?(:name)
        {list: param[:list_name]}
      else
        {list_id: param[:list_id]}
      end
    end
  end

  class List
    include Her::Model
    store_response_errors :errors
  end

  class Message
    include Her::Model
    store_response_errors :errors

    def send_tests contacts
      self.class.put("messages/#{self.id}/test", contacts: contacts)
    end

    def ready date=nil, hour=nil
      if date.present?
        r = self.class.put("messages/#{self.id}/ready", when: 'after', date: date, hour: hour)
      else
        r = self.class.put("messages/#{self.id}/ready", when: 'now')
      end
      r["message"]
    end
  end

  class MessageStatistic
    include Her::Model
    collection_path "/v2/reports"
    primary_key :message_id
    store_response_errors :errors
    def unsubscribes
self.class.get("reports/#{self['message_statistic']['message_id']}/unsubscribes")
    end
  end


  class Template
    include Her::Model
    store_response_errors :errors
  end


end
