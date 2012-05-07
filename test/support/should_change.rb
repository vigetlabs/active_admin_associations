class ActiveSupport::TestCase
  def self.should_change(expression, options = {})
    by, from, to = options.values_at(:by, :from, :to)
    stmt = "change #{expression.inspect}"
    stmt << " from #{from.inspect}" if from
    stmt << " to #{to.inspect}" if to
    stmt << " by #{by.inspect}" if by

    expression_eval = lambda { eval(expression) }
    before = lambda { @_before_should_change = expression_eval.bind(self).call }
    should stmt, :before => before do
      old_value = @_before_should_change
      new_value = expression_eval.bind(self).call
      assert_operator from, :===, old_value, "#{expression.inspect} did not originally match #{from.inspect}" if from
      assert_not_equal old_value, new_value, "#{expression.inspect} did not change" unless by == 0
      assert_operator to, :===, new_value, "#{expression.inspect} was not changed to match #{to.inspect}" if to
      assert_equal old_value + by, new_value if by
    end
  end
  
  def self.should_not_change(expression)
    expression_eval = lambda { eval(expression) }
    before = lambda { @_before_should_not_change = expression_eval.bind(self).call }
    should "not change #{expression.inspect}", :before => before do
      new_value = expression_eval.bind(self).call
      assert_equal @_before_should_not_change, new_value, "#{expression.inspect} changed"
    end
  end
end
