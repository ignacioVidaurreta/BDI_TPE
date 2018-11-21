/* Decreases reputation by 4  */
SELECT * FROM UserTP WHERE id=5;
UPDATE UserTP SET downvotes = downvotes + 2 WHERE id=5;
SELECT * FROM UserTP WHERE id=5;

/* Increases reputation by 10 */
SELECT * FROM UserTP WHERE id=5;
UPDATE UserTP SET upvotes = upvotes + 2 WHERE id=5;
SELECT * FROM UserTP WHERE id=5;

/* Insert with upvotes modifies reputation */
SELECT * FROM UserTP WHERE id=0;
INSERT INTO UserTP VALUES (0, 0, TIMESTAMP '2011-05-16 15:36:38', 'Sherlock', TIMESTAMP '2011-05-16 15:36:38', NULL, NULL, NULL, 0, 2, 0,500);
SELECT * FROM UserTP WHERE id=0;

/* If reputation<0 ==> reputation = 1 */
UPDATE UserTP SET reputation = 2  WHERE id=5;
SELECT * from UserTP where id=5;
UPDATE UserTP SET downvotes = downvotes + 6 WHERE id=5;
SELECT * FROM UserTP where id=5;

/* If downvotes<0 mantain old downvotes*/
SELECT * from UserTP where id=5;
UPDATE UserTP SET downvotes = -3 WHERE id=5;
SELECT * FROM UserTP where id=5;

/* Insert with upvotes<0 inserts with upvotes = 0 */
SELECT * from UserTP where id=1;
INSERT INTO UserTP VALUES (1, 10, TIMESTAMP '2011-05-16 15:36:38', 'Sherlock', TIMESTAMP '2011-05-16 15:36:38', NULL, NULL, NULL, 0, -3, 0,500);
SELECT * FROM UserTP where id=1;


