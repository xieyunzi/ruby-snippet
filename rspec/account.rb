describe "A new Account" do
  account = Account.new
  account.balance.should == Money.new(0, :USD)
end
