require "./spec_helper"

describe EventQL do
  it "should connect" do
    client = EventQL.connect(TEST_DB_OPTS)
    client.should_not be_nil
  end
  
  describe "Client" do
    it "should get query" do
      with_db do |client|
        query = client.query("*STRING*")
        query.should_not be_nil
      end
    end
    
    it "should insert one row" do
      with_db do |client|
        body = [
          {
            database: TEST_DB_NAME,
            table: TEST_DB_TABLE,
            data: {
              time: Time.now.to_utc.to_s("%FT%XZ"),
              session_id: "s1",
              url: "/page1",
            }
          }
        ].to_json
        result = client.insert!(body)
        result.should be_true
        
        query = client.query("SELECT COUNT(1) FROM #{TEST_DB_TABLE};")
        response = query.execute!
        
        # [{"type" => "table", "columns" => ["COUNT(1)"], "rows" => [["1"]]}]
        response.size.should eq(1)
        response[0]["rows"]?.should be_truthy
        response[0]["rows"][0][0].as_s.to_i.should eq(1)
      end
    end
  end
  
end
