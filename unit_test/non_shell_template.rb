# UPDATE! use minitest now
# http://docs.seattlerb.org/minitest/

# old code
# http://stackoverflow.com/questions/6515333/how-do-i-execute-a-single-test-using-ruby-test-unit

require 'test/unit'
require 'test/unit/ui/console/testrunner'

#~ require './demo'  #Load the TestCases
# >>>>>>>>>>This is your test file demo.rb
class MyTest < Test::Unit::TestCase  
  def test_1()
    assert_equal( 2, 1+1)
    assert_equal( 2, 4/2)

    assert_equal( 1, 3/2)
    assert_equal( 1.5, 3/2.0)
  end
end
# >>>>>>>>>>End of your test file  


#create a new empty TestSuite, giving it a name
my_tests = Test::Unit::TestSuite.new("My Special Tests")
my_tests << MyTest.new('test_1')#calls MyTest#test_1

#run the suite
Test::Unit::UI::Console::TestRunner.run(my_tests)
