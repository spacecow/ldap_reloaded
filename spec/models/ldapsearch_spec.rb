require 'spec_helper'

describe Ldapsearch do
  before(:each) do
    @testfile = 'ldap_info.txt'
    @small_testfile = 'small_ldap_info.txt'
  end

  describe "#group_hash" do
    it "returns a hash with groups" do
      hash = Ldapsearch.group_hash(@testfile)
      hash.length.should be(78)
    end
  end

  describe "find_or_create_accounts_and_memberships for full test file" do
    it "returns an array with memberships", slow:true do
      hash = Ldapsearch.group_hash(@testfile)
      memberships = Ldapsearch.find_or_create_accounts_and_memberships(hash,@testfile)
      memberships.length.should be(529)
    end
  end

  describe "find_or_create_accounts_and_memberships for small test file" do
    before(:each) do
      @membership_count = Membership.count
      @account_count    = Account.count
      @group_count      = Group.count
      @hash             = Ldapsearch.group_hash(@testfile)
    end

    context "creates no account if username already exists" do
      before(:each) do
        FactoryGirl.create(:account, username:"a-satou")
        @account_count = Account.count
        Ldapsearch.find_or_create_accounts_and_memberships(@hash,@small_testfile)
      end

      it "increases no database account count" do
        Account.count.should be(@account_count)
      end
    end

    context "creates an account if username does not exist" do
      before(:each) do
        Ldapsearch.find_or_create_accounts_and_memberships(@hash,@small_testfile)
        @account = Account.last
      end

      it "increases database account count" do
        Account.count.should be(@account_count+1)
      end
      it "account username is set" do
        @account.username.should eq "a-satou"
      end
      it "account uid is set" do
        @account.uid.should be 15540 
      end
      it "account realname is set" do
        @account.realname.should eq "Akira Sato"  
      end
    end

    context "creates a membership if group exists but no membership" do
      before(:each) do
        group = FactoryGirl.create(:group, gid:155)
        @membership_count = Membership.count
        @membership = Ldapsearch.find_or_create_accounts_and_memberships(@hash,@small_testfile).last
      end

      it "increases the database membership count" do
        Membership.count.should be(@membership_count+1)
      end
      it "membership path is set" do
        @membership.path.should eq "/home/otsuji/a-satou"
      end
      it "membership account_id is set" do
        @membership.account.should eq Account.last
      end
      it "membership group_id is set" do
        @membership.group.should eq Group.last
      end
    end

    context "creates no membership if that group already exists for that user" do
      before(:each) do
        account = FactoryGirl.create(:account, username:"a-satou")
        account.groups << FactoryGirl.create(:group, gid:155)
        @account_count = Account.count
        @membership_count = Membership.count
        Ldapsearch.find_or_create_accounts_and_memberships(@hash,@small_testfile)
      end

      it "increases no database membership count" do
        Account.count.should eq(@account_count)
        Membership.count.should eq(@membership_count)
      end
    end

    context "creates a membership if gid nor user exist" do
      before(:each) do
        @membership = Ldapsearch.find_or_create_accounts_and_memberships(@hash,@small_testfile).last
      end

      it "increases database membership count" do
        Membership.count.should be(@membership_count+1)
      end
      it "membership path is set" do
        @membership.path.should eq "/home/otsuji/a-satou"
      end
      it "membership account_id is set" do
        @membership.account.should eq Account.last
      end
      it "membership group_id is set" do
        @membership.group.should eq Group.last
      end
    end

    context "creates a group if gid does not exist" do
      before(:each) do
        Ldapsearch.find_or_create_accounts_and_memberships(@hash,@small_testfile)
        @group = Group.last
      end

      it "increases database membership count" do
        Group.count.should be(@group_count+1)
      end
      it "membership gid is set" do
        @group.gid.should eq 155
      end
      it "membership gidname is set" do
        @group.gidname.should eq "otsuji" 
      end
    end

    context "creates no group if gid already exists" do
      before(:each) do
        FactoryGirl.create(:group, gid:155)
        @group_count = Group.count
        Ldapsearch.find_or_create_accounts_and_memberships(@hash,@small_testfile)
      end

      it "increases no database group count" do
        Group.count.should eq(@group_count)
      end
    end
  end

  describe "#people_match" do
    context "matches" do
      it 'people' do
        Ldapsearch.people_match('ou=people')[0].should eq('ou=people') 
      end
      it 'People' do
        Ldapsearch.people_match('ou=People')[0].should eq('ou=People') 
      end
      it '"people"' do
        Ldapsearch.people_match('ou="people"')[0].should eq('ou="people"') 
      end
      it '"People"' do
        Ldapsearch.people_match('ou="People"')[0].should eq('ou="People"') 
      end
    end
  end
end
