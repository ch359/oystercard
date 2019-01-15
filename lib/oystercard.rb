class OysterCard
  DEFAULT_BALANCE = 0
  MAXIMUM_BALANCE = 90
  MAX_BALANCE_ERROR = "Card limit of #{MAXIMUM_BALANCE} reached".freeze
  NO_FUNDS_ERROR = 'Insufficient funds'
  MINIMUM_BALANCE = 1
  MINIMUM_CHARGE = 3

  attr_reader :balance, :entry_station

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @entry_station = nil
  end

  def top_up(amount)
    raise MAX_BALANCE_ERROR if amount + balance >= MAXIMUM_BALANCE

    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def touch_in(station)
    @entry_station = station
    raise NO_FUNDS_ERROR if @balance < MINIMUM_BALANCE
  end

  def touch_out
    deduct(MINIMUM_CHARGE)
    @entry_station = nil
  end

  def in_journey?
    @entry_station
  end

  private :deduct
end
