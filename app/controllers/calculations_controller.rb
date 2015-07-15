class CalculationsController < ApplicationController

  def word_count
    @text = params[:user_text]
    @special_word = params[:user_word]

    @character_count_with_spaces = @text.length

    @character_count_without_spaces = @text.gsub(" ", "").length

    @word_count = @text.split.count

    @occurrences = @text.capitalize.split.count(@special_word)

  end

  def loan_payment
    @apr = params[:annual_percentage_rate].to_f
    @years = params[:number_of_years].to_i
    @principal = params[:principal_value].to_f

    @monthly_payment = (@apr/100/12*@principal)/(1-(1+@apr/100/12)**(-(@years*12)))

  end

  def time_between
    @starting = Chronic.parse(params[:starting_time])
    @ending = Chronic.parse(params[:ending_time])

    @seconds = (@ending-@starting).abs
    @minutes = ((@ending-@starting)/60).abs
    @hours = ((@ending-@starting)/60/60).abs
    @days = ((@ending-@starting)/60/60/24).abs
    @weeks = ((@ending-@starting)/60/60/24/7).abs
    @years = ((@ending-@starting)/60/60/24/365.25).abs

  end

  def descriptive_statistics
    @numbers = params[:list_of_numbers].gsub(',', '').split.map(&:to_f)

    @sorted_numbers = @numbers.sort

    @count = @numbers.count

    @minimum = @numbers.min

    @maximum = @numbers.max

    @range = @numbers.max-@numbers.min

    def median(list_of_numbers)
      middle = list_of_numbers.size/2
      sorting = list_of_numbers.sort
      if sorting.length.odd?
        return sorting[middle].to_f
      else sorting.length.even?
        return (((sorting[middle]) + (sorting[middle-1]))/2).to_f
      end
    end

    @median = median @numbers

    def sum(list_of_numbers)
      running_total = 0
      list_of_numbers.each do |number|
        running_total = running_total + number
      end
      return running_total
    end

    @sum = sum @numbers

    @mean = @sum/@count

    @variance = (@numbers.inject(0.0){|sum,x| sum +(x - @mean)**2})/@count

    @standard_deviation = Math.sqrt(@variance)

    def mode(list_of_numbers)
      modecalc = list_of_numbers.inject({}){|a,b| a[b] = list_of_numbers.count(b); a}
      display = modecalc.select{|a,b| b == modecalc.values.max}
      return display.keys
          end

    @mode = mode @numbers
  end

end
