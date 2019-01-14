require 'oystercard'

describe OysterCard do

  before(:each) do
    @card = OysterCard.new
  end

  describe 'setting up the OysterCard' do

    it 'should have an initial balance equal to default balance' do
      expect(@card.balance).to eq(OysterCard::DEFAULT_BALANCE)
    end

    it 'should have a default balance equal to 0' do
      expect(OysterCard::DEFAULT_BALANCE).to eq(0)
    end

    it 'should respond to "top_up" method' do
      top_up_amount = 10
      expect { @card.top_up(top_up_amount) }.to change { @card.balance }.by(top_up_amount)
    end

  end

end
