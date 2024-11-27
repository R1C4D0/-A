CREATE TABLE parents AS
  SELECT "ace" AS parent, "bella" AS child UNION
  SELECT "ace"          , "charlie"        UNION
  SELECT "daisy"        , "hank"           UNION
  SELECT "finn"         , "ace"            UNION
  SELECT "finn"         , "daisy"          UNION
  SELECT "finn"         , "ginger"         UNION
  SELECT "ellie"        , "finn";

CREATE TABLE dogs AS
  SELECT "ace" AS name, "long" AS fur, 26 AS height UNION
  SELECT "bella"      , "short"      , 52           UNION
  SELECT "charlie"    , "long"       , 47           UNION
  SELECT "daisy"      , "long"       , 46           UNION
  SELECT "ellie"      , "short"      , 35           UNION
  SELECT "finn"       , "curly"      , 32           UNION
  SELECT "ginger"     , "short"      , 28           UNION
  SELECT "hank"       , "curly"      , 31;

CREATE TABLE sizes AS
  SELECT "toy" AS size, 24 AS min, 28 AS max UNION
  SELECT "mini"       , 28       , 35        UNION
  SELECT "medium"     , 35       , 45        UNION
  SELECT "standard"   , 45       , 60;


-- All dogs with parents ordered by decreasing height of their parent
CREATE TABLE by_parent_height AS
  SELECT 
    d.name
  from parents p join dogs d on p.child = d.name join dogs p_dog on p.parent = p_dog.name
  order by p_dog.height desc;


-- The size of each dog
CREATE TABLE size_of_dogs AS
  SELECT 
    d.name, s.size
  from dogs d join sizes s on d.height > s.min and d.height <= s.max;


-- [Optional] Filling out this helper table is recommended
CREATE TABLE siblings AS
  SELECT 
    p1.child as sibling1, p2.child as
  from parents p1 join parents p2 on p1.parent = p2.parent and p1.child != p2.child
  where p1.child < p2.child;
  

-- Sentences about siblings that are the same size
CREATE TABLE sentences AS
  SELECT
    'The two siblings, ' || s1.sibling1 || ' and ' || s2.sibling2 || ', have the same size: ' || s1.size
  from siblings s1 join siblings s2 on s1.sibling1 = s2.sibling1 and s1.size = s2.size;


-- Height range for each fur type where all of the heights differ by no more than 30% from the average height
/* We want to create a table that contains the height range (defined as the difference between maximum and minimum height) of all dogs that share a fur type. However, we'll only consider fur types where each dog with that fur type is within 30% of the average height of all dogs with that fur type; we call this the low variance criterion.

For example, if the average height for short-haired dogs is 10, then in order to be included in our output, all dogs with short hair must have a height of at most 13 and at least 7 (inclusive). */
CREATE TABLE low_variance AS
  SELECT 
    d.fur, max(d.height) - min(d.height) as height_range
  from dogs d join (select fur, avg(height) as avg_height from dogs group by fur) avg_heights on d.fur = avg_heights.fur
  where d.height <= 1.3 * avg_heights.avg_height and d.height >= 0.7 * avg_heights.avg_height;

