require_relative("../db/sql_runner.rb")

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)

    @id = options['id'].to_i
    @title = options['title']
    @price = options['price']

  end

  def self.delete_all

    sql = "DELETE FROM films"
    SqlRunner.run(sql)

  end

  def self.all

    sql = "SELECT * FROM films"
    result = SqlRunner.run(sql)
    films = result.map { |film| Film.new(film)  }

  end

  def save()

    sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i

  end

  def delete

    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql,values)

  end

  def update

    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)

  end

  def customers

    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON tickets.customer_id = customers.id WHERE tickets.film_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    customers = result.map { |customer| Customer.new(customer) }

  end


end
