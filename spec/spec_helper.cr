require "spec"
require "../src/eventql"
require "json"

TEST_DB_NAME = "test"
TEST_DB_TABLE = "sensors"
TEST_DB_OPTS = {
  "host" => "localhost",
  "port" => "9175",
  "database" => TEST_DB_NAME,
}

def with_db(&block : EventQL::Client ->)
  Process.run "evql --database test -e 'DROP TABLE #{TEST_DB_TABLE};'", shell: true rescue nil
  Process.run "evql --database test -e 'CREATE TABLE #{TEST_DB_TABLE}(time DATETIME, session_id STRING, url STRING, PRIMARY KEY (time, session_id));'", shell: true rescue nil
  yield EventQL.connect(TEST_DB_OPTS)
ensure
  Process.run "evql --database test -e 'DROP TABLE #{TEST_DB_TABLE};'", shell: true rescue nil
end

# CREATE TABLE access_log (
#   time        DATETIME,
#   session_id  STRING,
#   url         STRING,
#   PRIMARY KEY (time, session_id)
# );
