require 'spec_helper'

describe Secret, :type => :model do
  include_context "create user"
  
  let(:login) { "u-#{SecureRandom.uuid}" }
    
  describe "#counter" do
    let(:resource) { Resource.create(resource_id: "rspec:test-resource:#{SecureRandom.uuid}", owner: the_user) }
    it "auto-increments" do
      secret_0 = Secret.create resource: resource, value: "value-0"
      secret_0.reload
      expect(secret_0.counter).to eq(1)
      
      secret_1 = Secret.create resource: resource, value: "value-1"
      secret_1.reload
      expect(secret_1.counter).to eq(2)
      
      secret_0.destroy
      
      resource.reload
      
      secret_2 = Secret.create resource: resource, value: "value-2"
      secret_2.reload
      expect(secret_2.counter).to eq(3)
    end
  end
    
  describe "#latest_public_keys" do
    let(:login) { SecureRandom.uuid }
    let(:resource) { Resource.create(resource_id: "rspec:public_key:user/#{login}/my-key", owner: the_user) }
    
    it "finds only the latest public key of a user" do
      Secret.create resource: resource, value: "value-0"
      Secret.create resource: resource, value: "value-1"
      
      expect(Secret.latest_public_keys("rspec", "user", login)).to eq(["value-1"])
    end
  end
end
