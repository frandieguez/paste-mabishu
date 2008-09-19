require File.dirname(__FILE__) + '/../test_helper'

class StringTest < Test::Unit::TestCase

  def test_modelize
    assert "people".modelize, Person
    assert "categories".modelize, Category
    assert "typus_users".modelize, TypusUser
  end

end