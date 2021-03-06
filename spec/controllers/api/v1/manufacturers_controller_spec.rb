require 'spec_helper'

describe Api::V1::ManufacturersController do  
  describe :index do
    it "loads the request" do
      m = FactoryGirl.create(:manufacturer)
      get :index, format: :json
      response.code.should eq('200')
      JSON.parse(response.body)['manufacturers'][0]['name'].should eq(m.name)
      response.headers['Access-Control-Allow-Origin'].should eq('*')
      response.headers['Access-Control-Allow-Methods'].should eq('POST, PUT, GET, OPTIONS')
      response.headers['Access-Control-Request-Method'].should eq('*')
      response.headers['Access-Control-Allow-Headers'].should eq('Origin, X-Requested-With, Content-Type, Accept, Authorization')
      response.headers['Access-Control-Max-Age'].should eq("1728000")
    end
  end    
end
