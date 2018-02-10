require_relative("../db/sql_runner.rb")

class Screening

  attr_reader :id
  attr_accessor :film_id, :time

  def initialize(options)

    @id = options['id'].to_i
    @film_id = options['film_id'].to_i
    @time = options['time']

  end

  def self.delete_all

    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)

  end

  def self.all

    sql = "SELECT * FROM screenings"
    result = SqlRunner.run(sql)
    screenings = result.map { |screening| Screening.new(screening)  }

  end

  def save()

    sql = "INSERT INTO screenings (film_id, time) VALUES ($1, $2) RETURNING id"
    values = [@film_id, @time]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i

  end

  def delete

    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)

  end

  def update

    sql = "UPDATE screenings SET (film_id, time) = ($1, $2) WHERE id = $3"
    values = [@film_id, @time, @id]
    SqlRunner.run(sql, values)

  end

end
