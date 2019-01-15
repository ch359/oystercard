class OysterCard
  DEFAULT_BALANCE = 0
  MAXIMUM_BALANCE = 90
  MAX_BALANCE_ERROR = "Card limit of #{MAXIMUM_BALANCE} reached".freeze

  attr_reader :balance

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @in_use = false
  end

  def top_up(amount)
    raise MAX_BALANCE_ERROR if amount + balance >= MAXIMUM_BALANCE

    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def touch_in
    @in_use = true
  end

  def touch_out
    @in_use = false
  end

  def in_journey?
    @in_use
  end
end
