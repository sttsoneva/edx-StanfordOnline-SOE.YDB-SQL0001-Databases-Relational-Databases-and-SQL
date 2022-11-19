/*SQL Social-Network Query Exercises

Students at your hometown high school have decided to organize their social network using databases. So far, 
they have collected information about sixteen students in four grades, 9-12. Here's the schema:

Highschooler ( ID, name, grade )
English: There is a high school student with unique ID and a given first name in a certain grade.

Friend ( ID1, ID2 )
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123).

Likes ( ID1, ID2 )
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, 
there is no guarantee that (456, 123) is also present.*/

/*Task 1: Find the names of all students who are friends with someone named Gabriel.*/

select H1.name from Highschooler as H1
join Friend as F1
on H1.ID = F1.ID1
where F1.ID2 in (select H.ID from Highschooler as H
where H.name like 'Gabriel');

/*Task 2: For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, 
and the name and grade of the student they like.*/

select H.name, H.grade, H1.name, H1.grade
from Highschooler as H
join Likes as L
on H.ID = L.ID1
inner join Highschooler as H1
on H1.ID = L.ID2
where H.grade - H1.grade >= 2;

/*Task 3: For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.*/

select H1.name, H1.grade, H2.name, H2.grade
from Highschooler as H1, Highschooler as H2, Likes as L1, Likes as L2
where (H1.ID = L1.ID1 and H2.ID = L1.ID2) and (H2.ID = L2.ID1 and H1.ID = L2.ID2) and H1.name < H2.Name 
order by H1.name, H2.name;

/*Task 4: Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.*/

select H.name, H.grade
from Highschooler as H
where H.ID not in (select L.ID1 from Likes as L) and H.ID not in (select L.ID2 from Likes as L)
order by H.grade, H.name;

/*Task 5: For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.*/

select H.name, H.grade, H1.name, H1.grade
from Highschooler as H
join Likes as L
on H.ID = L.ID1
inner join Highschooler as H1
on H1.ID = L.ID2
where L.ID2 not in (select L1.ID1 from Likes as L1 );

/*Task 6: Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.*/

select name, grade
from Highschooler as H
where H.ID not in (select ID1 from Friend, Highschooler as H1 where H.ID = Friend.ID1 and H1.ID = Friend.ID2 and H.grade <> H1.grade)
order by grade, name;

/*Task 7: For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.*/

select distinct H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Highschooler as H1, Highschooler as H2, Highschooler as H3, Likes as L, Friend as F1, Friend as F2
where (H1.ID = L.ID1 and H2.ID = L.ID2) and H2.ID not in (select ID2 from Friend where ID1 = H1.ID) 
and (H1.ID = F1.ID1 AND H3.ID = F1.ID2) and (H2.ID = F2.ID1 and H3.ID = F2.ID2);

/*Task 8: Find the difference between the number of students in the school and the number of different first names.*/

select count(*) - count(distinct name)
from Highschooler as H;

/*Task 9: Find the name and grade of all students who are liked by more than one other student.*/

select H.name, H.grade
from Highschooler as H
where 1 < (select count(*) from Likes as L where H.id = L.ID2);