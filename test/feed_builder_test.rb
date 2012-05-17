require 'test_helper'

class FeedTest < MiniTest::Unit::TestCase
  def setup
  end

  def test_nothing
    msgs = [
      { "Product" => "somethinglame",
        "NestedHash" => {"hash"=> 7},
        "NestedArray" => [{"NA1"=> 1}, {"NA2"=> 2}]
    } ,
      { "Product" => "lame1",
        "NestedHash" => {"hash"=> 8},
        "NestedArray" => [{"NA1"=> 1}, {"NA2"=> 2}]
    } ,
    ];
    fb = Amazon::MWS::FeedBuilder.new(:product, msgs)
    assert_instance_of FeedBuilder, fb
    xml = fb.render
    assert_instance_of String, xml
  end
  
  def test_element_with_attribute    
    fb = Amazon::MWS::FeedBuilder.new(:product_data)
    fb.xml.ShippingWeight('1', 'unitOfMeasure'=>'LB')

    fb2 = Amazon::MWS::FeedBuilder.new(:product_data)
    fb2.xml.tag!('ShippingWeight', '1', 'unitOfMeasure'=>'LB')
    assert_equal fb.render, fb2.render
    
    messages = [{
      #'MessageID' => 2,
      'OperationType' => 'Update',
      'Product'=> {
        'SKU'=>'sku1324234324',
        'ItemPackageQuantity'=>'1',
        'NumberOfItems'=>'1',
        'StandardProductID'=>{'Type'=>'UPC', 'Value'=>'814digitstring'},
        'DescriptionData'=>[
          {'Title'=>'title'},
          {'BulletPoint'=>['bp1', 'bp2']},
          {'ShippingWeight'=>['1', 'unitOfMeasure'=>'LB']}, #TODO value is probably not the right term
          {'MSRP'=>'5.43'},
          {'SearchTerms' => 'asdf1'},
          {'SearchTerms' => 'asdf2'}
        ],#DescriptionData
        'ProductData' => {
          'Clothing'=>{
            "VariationData"=> {
              "Parentage"=>"child", 
              "Size"=>"size",
              "Color"=>"color",
              "VariationTheme"=>"SizeColor"
            }, #VariationData
            'ClassificationData'=>[
              {'ClothingType'=>'Accessory'},
              {'Department'=>'d1'},
              {'Department'=>'d2'}, # max 10 
              {'StyleKeywords'=>'style1'},
              {'StyleKeywords'=>'style2'},  # max 10
              {'OccasionAndLifestyle'=>'ol1'},
              {'OccasionAndLifestyle'=>'ol2'} # max 10
            ]#ClassificationData
          }#Clothing
        }#ProductData
      }#Product
    }]
    fb3 = Amazon::MWS::FeedBuilder.new(:product_data, messages)
    #puts fb3.render
    assert_kind_of String, fb3.render
  end
  
  def test_stores_feed
    msgs = [{"Store"=>[{"MarketplaceName"=>"Amazon.co.uk"}, {"StoreID"=>"Y4TG"}], "OperationType"=>"Update"}]
    fb = Amazon::MWS::FeedBuilder.new("Store", msgs)
    assert_instance_of FeedBuilder, fb
    xml = fb.render
    assert_instance_of String, xml
    assert_equal xml, xml_for("submit_feed_stores_request", 200).body
  end

end
