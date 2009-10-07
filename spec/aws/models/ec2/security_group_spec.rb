require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::SecurityGroup' do

  describe "#initialize" do

    it "should remap attributes from parser" do
      security_group = Fog::AWS::EC2::SecurityGroup.new(
        'groupDescription' => 'description',
        'groupName'        => 'name',
        'ipPermissions'    => 'permissions',
        'ownerId'          => 'owner'
      )
      security_group.group_description.should == 'description'
      security_group.group_name.should == 'name'
      security_group.ip_permissions.should == 'permissions'
      security_group.owner_id.should == 'owner'
    end

  end

  describe "#security_groups" do

    it "should return a Fog::AWS::EC2::SecurityGroups" do
      ec2.security_groups.new.security_groups.should be_a(Fog::AWS::EC2::SecurityGroups)
    end

    it "should be the security_groups the keypair is related to" do
      security_groups = ec2.security_groups
      security_groups.new.security_groups.should == security_groups
    end

  end

  describe "#destroy" do

    it "should return true if the security_group is deleted" do
      address = ec2.security_groups.create(:group_description => 'groupdescription', :group_name => 'keyname')
      address.destroy.should be_true
    end

  end

  describe "#reload" do

    before(:each) do
      @security_group = ec2.security_groups.create(:group_description => 'groupdescription', :group_name => 'keyname')
      @reloaded = @security_group.reload
    end

    after(:each) do
      @security_group.destroy
    end

    it "should return a Fog::AWS::EC2::SecurityGroup" do
      @reloaded.should be_a(Fog::AWS::EC2::SecurityGroup)
    end

    it "should reset attributes to remote state" do
      @security_group.attributes.should == @reloaded.attributes
    end

  end

  describe "#save" do

    before(:each) do
      @security_group = ec2.security_groups.new(:group_description => 'groupdescription', :group_name => 'keyname')
    end

    it "should return true when it succeeds" do
      @security_group.save.should be_true
      @security_group.destroy
    end

    it "should not exist in security_groups before save" do
      @security_group.security_groups.get(@security_group.group_name).should be_nil
    end

    it "should exist in buckets after save" do
      @security_group.save
      @security_group.security_groups.get(@security_group.group_name).should_not be_nil
      @security_group.destroy
    end

  end

end
