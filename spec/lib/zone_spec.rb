require File.dirname(__FILE__) + '/../spec_helper'

describe "Zerigo::DNS::Zone.find_or_create" do
  
  it 'should create zone' do
    Zerigo::DNS::Zone.stub!(:find).and_return([])
    Zerigo::DNS::Zone.stub!(:create).and_return(:success => true)
    
    Zerigo::DNS::Zone.find_or_create('jackhq.com')[:success].should be_true
  end

  it 'should find zone' do
    jackhq = mock('Zerigo::DNS::Zone')
    jackhq.stub!(:domain).and_return('example.com')
    
    Zerigo::DNS::Zone.stub!(:find).and_return([jackhq])
    Zerigo::DNS::Zone.stub!(:create).and_return(:success => false)
    
    Zerigo::DNS::Zone.find_or_create('example.com').domain == 'example.com'
  end

  it 'should find zone by domain' do
    jackhq = mock('Zerigo::DNS::Zone')
    jackhq.stub!(:domain).and_return('example.com')
    
    Zerigo::DNS::Zone.stub!(:find).and_return([jackhq])
    
    Zerigo::DNS::Zone.find_by_domain('example.com').domain == 'example.com'
  end
  
  
end
