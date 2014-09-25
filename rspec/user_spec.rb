# usage: rspec user_spec.rb
class User
  def save; false; end
end

def save_user(user)
  "saved!" if user.save
end

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

RSpec.describe '#save_user' do
  it 'renders message on success' do
    user = User.new
    expect(user).to receive(:saave).and_return(true) # Typo in name
    expect(save_user(user)).to eq("saved!")
  end
end
