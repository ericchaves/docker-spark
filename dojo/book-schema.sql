CREATE TABLE IF NOT EXISTS books (
  latest_revision int,
  revision int,
  title string,
  languages array<map<string,string>>,
  subjects array<string>,
  publish_country string,
  by_statement string,
  type map<string,string>,
  location array<string>,
  other_titles array<string>,
  publishers array<string>,
  last_modified struct<type:string, value:timestamp>,
  key string,
  authors array<struct<key:string>>,
  publish_places array<string>,
  oclc_number array<int>,
  pagination string,
  created struct<type:string, value:timestamp>,
  notes  struct<type:string, value:string>,
  number_of_pages int,
  publish_date int,
  works array<struct<key:string>>
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE

