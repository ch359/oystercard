require 'oystercard'

describe OysterCard do
  let(:station) { double :station }

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

  describe 'consumer protections' do

    it 'should have a maximum balance limit of £90' do
      expect(OysterCard::MAXIMUM_BALANCE).to eq(90)
    end

    it 'topping up to more than the maximum balance should raise an error' do
      @card.top_up(40)
      expect { @card.top_up(52) }.to raise_error(OysterCard::MAX_BALANCE_ERROR)
    end

  end

  describe 'touch in/out functionality' do

    before(:each) do
      @card.top_up(10)
    end

    it 'should allow the user to tap in and start journey' do
      @card.touch_in(station)
      expect(@card).to be_in_journey
    end

    it 'should allow the user to tap out' do

      @card.touch_in(station)
      @card.touch_out
      expect(@card).not_to be_in_journey
    end

    it 'should not be on a journey when first created' do
      expect(@card).not_to be_in_journey
    end

    it 'should not allow journeys without a sufficient balance' do
      @card.instance_variable_set(:@balance, 0)
      expect { @card.touch_in(station) }.to raise_error(OysterCard::NO_FUNDS_ERROR)
    end

    it 'should deduct journey fare from balance' do
      expect { @card.touch_out }.to change { @card.balance }.by(-OysterCard::MINIMUM_CHARGE)
    end

  end

  describe 'Working with station' do
    before(:each) do
      @card.top_up(10)
      @card.touch_in(station)
    end
    it "Should remember the entry station" do
      expect(@card.entry_station).to eq(station)
    end
    it 'Should reset entry station on touch_out' do
      @card.touch_out
      expect(@card.entry_station).to be nil
    end
  end

  describe 'multiple journeys' do
    it 'should track multiple journeys' do
      @card.top_up(20)
      station1 = station
      station2 = double('station2')
      station3 = double('station3')
      station4 = double('station4')
      @card.touch_in(station1)
      @card.touch_out(station2)
      @card.touch_in(station3)
      @card.touch_out(station4)
      expected_result = [{in: station1, out: station2}, {in: station3, out: station4}]
      expect(@card.journeys).to eq(expected_result)
    end



  end

end
