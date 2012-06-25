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
      @account_count = Account.count
      @hash = Ldapsearch.group_hash(@testfile)
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

    context "creates a membership if gid exists but for another user" do
      before(:each) do
        another_account = FactoryGirl.create(:account, username:"b-satou")
        FactoryGirl.create(:membership, gid:155, account:another_account)
        @membership_count = Membership.count
        memberships = Ldapsearch.find_or_create_accounts_and_memberships(@hash,@small_testfile)
        @membership = memberships.last
      end

      it "increases no database membership count" do
        Membership.count.should be(@membership_count+1)
      end
      it "membership path is set" do
        @membership.path.should eq "/home/otsuji/a-satou"
      end
      it "membership gid is set" do
        @membership.gid.should eq 155
      end
      it "membership gidname is set" do
        @membership.gidname.should eq "otsuji" 
      end
      it "membership account_id is set" do
        @membership.account.should eq Account.last
      end
    end

    context "creates no membership if gid already exists for that user" do
      before(:each) do
        account = FactoryGirl.create(:account, username:"a-satou")
        FactoryGirl.create(:membership, gid:155, account:account)
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
        Ldapsearch.find_or_create_accounts_and_memberships(@hash,@small_testfile)
        @membership = Membership.last
      end

      it "increases database membership count" do
        Membership.count.should be(@membership_count+1)
      end
      it "membership path is set" do
        @membership.path.should eq "/home/otsuji/a-satou"
      end
      it "membership gid is set" do
        @membership.gid.should eq 155
      end
      it "membership gidname is set" do
        @membership.gidname.should eq "otsuji" 
      end
      it "membership account_id is set" do
        @membership.account.should eq Account.last
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
