
Schema of the data for JSON is

1) blogID
2) date
3) commenter name
4) comment
5) commenter email
6)commenter web site

Sample data comment.txt
{ "blogID" : "FJY26J1333", "date" : "2012-04-01", "name" : "vpxnksu", "comment" : "good stuff", "contact" : { "email" : "vpxnksu@gmail.com", "website" : "vpxnksu.wordpress.com" } }
{ "blogID" : "FJY26J1333", "date" : "2012-04-01", "name" : "vpxnksu", "comment" : "good stuff", "contact" : { "email" : "vpxnksu@gmail.com", "website" : "vpxnksu.wordpress.com" } }
{ "blogID" : "VSAUMDFGSD", "date" : "2012-04-01", "name" : "yhftrcx", "comment" : "another comment",}



CREATE  EXTERNAL  TABLE comments_external
(
cmt STRING 
)
COMMENT 'This is an external table'
ROW FORMAT DELIMITED
STORED AS TEXTFILE
LOCATION  '/user/test/comment';

LOAD DATA LOCAL INPATH 'comment.txt' OVERWRITE INTO TABLE comments_external;

SELECT b.blogID, c.email FROM comments_external a LATERAL VIEW json_tuple('blogID', 'contact') b 
AS blogID, contact  LATERAL VIEW json_tuple(b.contact, 'email', 'website') c 
AS email, website WHERE b.blogID='64FY4D0B28';