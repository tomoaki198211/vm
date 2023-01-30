class VendingMachine

  MONEY = [10, 50, 100, 500, 1000].freeze

  def initialize
    @total_money = 0
    @slot_money = 0
    @drinks = []
    @buyable_list = []
    drink_setup
  end

  def current_slot_money
    @slot_money
  end

  def sales
    @total_money
  end

  def stocks
    @drinks
  end

  def buy_list
    index = 0
    @buyable_list.clear
    @drinks.each do |drink|
      if drink.buyable?(@slot_money)
        puts "#{index}:#{drink.name}"
        index += 1
        @buyable_list << drink
      end
    end
    if @buyable_list.empty?
      puts "買える物はありません"
    end
  end

  def slot_money(money)
    return false unless MONEY.include?(money)
    @slot_money += money
  end

  def buy
    drink = nil
    while true
      buy_list
      return if @buyable_list.empty?
      puts "購入するジュースを番号で選択して下さい。"
      input = gets.chomp
      drink =selected_drink(input)
      break unless drink.nil?
    end
    @slot_money, @total_money = drink.buy(@slot_money,@total_money)
  end

  def selected_drink(input)
    if input =~ /^[0-9]+$/ && @buyable_list.length > input.to_i
      @buyable_list[input.to_i]
    else
      false
    end
  end

  def return_money
    puts @slot_money
    @slot_money = 0
  end

  private

  def drink_setup
    refill(Drink.new(name:"cola", price:120, stock:5))
    refill(Drink.new(name:"water", price:100, stock:5))
    refill(Drink.new(name:"red_bull", price:200, stock:5))
  end

  def refill(drink)
    @drinks << drink
  end
end

class Drink

  attr_reader :name, :price ,:stock

  def initialize(name:, price:, stock:)
    @name = name
    @price = price
    @stock = stock
  end

  def buy(money,total)
    @stock -= 1
    money -= @price
    total += @price
    puts "#{@name}を購入しました"
    puts "在庫#{@stock}"
    return money, total
  end

  def buyable?(money)
    if money >= @price && @stock > 0
      true
    else
      false
    end
  end

  def refill
    @stock += 1
  end

end


