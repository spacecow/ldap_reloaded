require 'spec_helper'

describe Ldapsearch do
  before(:each) do
    @testfile = 'test_full_ldap_info.txt'
    @small_testfile = 'test_small_ldap_info.txt'
  end

  describe "#group_hash" do
    it "returns a hash with groups" do
      hash = Ldapsearch.group_hash(@testfile)
      hash.length.should be(78)
    end
  end

  describe "read" do
    before(:each) do
      @member_count = Member.count
      @account_count = Account.count
      @hash = Ldapsearch.group_hash(@testfile)
    end

    context "creates no account if username already exists" do
      before(:each) do
        FactoryGirl.create(:account, username:"a-satou")
        @account_count = Account.count
        Ldapsearch.read(@hash,@small_testfile)
      end

      it "increases no database account count" do
        Account.count.should be(@account_count)
      end
    end

    context "creates an account if username does not exist" do
      before(:each) do
        Ldapsearch.read(@hash,@small_testfile)
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

    context "creates no member if gid already exists for that member" do
      before(:each) do
        account = FactoryGirl.create(:account, username:"a-satou")
        FactoryGirl.create(:member, gid:155, account:account)
        @member_count = Member.count
        Ldapsearch.read(@hash,@small_testfile)
      end

      it "increases no database member count" do
        Member.count.should be(@member_count)
      end
    end

    pending "creates a member to an already existsing account" 

    context "creates a member if gid does not exist" do
      before(:each) do
        Ldapsearch.read(@hash,@small_testfile)
        @member = Member.last
      end

      it "increases database member count" do
        Member.count.should be(@member_count+1)
      end
      it "member path is set" do
        @member.path.should eq "/home/otsuji/a-satou"
      end
      it "member gid is set" do
        @member.gid.should eq 155
      end
      it "member gidname is set" do
        @member.gidname.should eq "otsuji" 
      end
      it "member account_id is set" do
        @member.account.should eq Account.last
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
