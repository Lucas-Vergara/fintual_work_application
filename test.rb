
class Portfolio
  STOCKS = [
    { name: 'Falabella', volume: 10 },
    { name:'Banco de Chile', volume: 9 },
    { name: 'Concha y Toro', volume: 11 },
    { name: 'SQM-B', volume: 12 },
    { name: 'Enel Américas', volume: 13 }
  ]

  def profit input
    total = 0
    initial_investment = 0
    initial_date = input[:initial_date]
    end_date = input[:end_date]
    years = end_date.split('-').last.to_i - initial_date.split('-').last.to_i
    STOCKS.each do |stock_hash|
      # Since we don't have a Stock model nor a database, for this example, we are going to
      # call an instance of a Stock class that emulates what would be the Stock model instance.
      stock = Stock.new(stock_hash[:name])
      # The next 2 commented lines are the "oficial" code.
      # stock = Stock.find_by(name: stock_hash[:name])
      # next if stock.nil?
      initial_price = stock.price(initial_date)
      initial_investment += initial_price
      end_price = stock.price(end_date)
      next if initial_price.nil? || end_price.nil?
      
      stock_profit = (end_price - initial_price)*stock_hash[:volume]
      puts "'#{stock_hash[:name]}' profit:#{stock_profit.round(2)}"
      total += stock_profit
    end
    annualized_return = ((total/initial_investment)**years) if years > 0
    annualized_return ||= nil
    {
      profit: total,
      annualized_return: annualized_return.round(2)
    }
  end

end

class Stock
  
  def initialize name
    @name = name
  end

  # This method would be in the Stock model, but it would use the database or an api to get the price.
  # This hardcoded data serves just as an example.
  def price date    
    # The input dates would help us fetch the correct data. In this case, I just hardcoded everything.
    # I put this data based on information given by https://www.bolsadesantiago.com/ for 
    # initial_date: 02-01-2018, end_date: 02-01-2021.
    prices = case @name
    when 'Falabella'
      {
        initial_date: 6324, 
        end_date: 2850
      }
    when 'Banco de Chile'
      {
        initial_date: 98.78,
        end_date: 80.12
      }
    when 'Concha y Toro'
      {
        initial_date: 1343,
        end_date: 1282
      }
    when 'SQM-B'
      {
        initial_date: 33835,
        end_date: 42700
      }
    when 'Enel Américas'
      {
        initial_date: 141,
        end_date: 94
      }
    else 
        nil
    end

    return prices[:initial_date] if date == '02-01-2018'
    return prices[:end_date] if date == '02-01-2021'
  end
end

portolio = Portfolio.new
profit = portolio.profit(initial_date: '02-01-2018', end_date: '02-01-2021')
puts "\n---------------------------\n\n"
puts "Ganancias: $#{profit[:profit]}\nRetorno Anualizado: #{profit[:annualized_return]}%"