require File.dirname(__FILE__) + '/../spec_helper'

describe "Zerigo::DNS::Host.update_or_create" do
  
  it 'should create host' do
    Zerigo::DNS::Host.stub!(:find).and_return([])
    Zerigo::DNS::Host.stub!(:create).and_return(:success => true)
    
    Zerigo::DNS::Host.update_or_create(1, 'www', 'A', '10.10.10.10')[:success].should be_true
  end

  it 'should update host' do
    jackhq = mock('Zerigo::DNS::Host')
    jackhq.stub!(:hostname).and_return('www')
    jackhq.stub!(:host_type=)
    jackhq.stub!(:data=)
    jackhq.stub!(:ttl=)
    jackhq.stub!(:save).and_return(true)
    
    Zerigo::DNS::Host.stub!(:find).and_return([jackhq])
    Zerigo::DNS::Host.stub!(:create).and_return(:success => false)
    
    Zerigo::DNS::Host.update_or_create(1, 'www', 'A', '10.10.10.10').hostname == 'www'
  end
  
  
end
