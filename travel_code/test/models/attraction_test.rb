require 'test_helper'

class AttractionTest < ActiveSupport::TestCase

  def setup
    @attraction = Attraction.new(name: "Attraction name",
                                 longitude: 123.23,
                                 latitude: -12.0,
                                 address: "Japan Tokyo",
                                 phone: "123345897",
                                 category_id: 1,
                                 user_id: 1)
  end


  test "name should be present" do
    @attraction.name = " "
    assert_not @attraction.valid?
  end

  test "name should not too long" do
    @attraction.name = "a" * 101
    assert_not @attraction.valid?
  end

  test "longitude should be number" do
    @attraction.longitude = "test"
    assert_not @attraction.valid?
  end

  test "latitude should be number" do
    @attraction.latitude = "test"
    assert_not @attraction.valid?
  end

  test "category id should be number" do
    @attraction.category_id = "test"
    assert_not @attraction.valid?
  end

  test "phone should not too long" do
    @attraction.phone = "2" * 21
    assert_not @attraction.valid?
  end

  test "address should not too long" do
    @attraction.address = "a" * 256
    assert_not @attraction.valid?
  end

end
