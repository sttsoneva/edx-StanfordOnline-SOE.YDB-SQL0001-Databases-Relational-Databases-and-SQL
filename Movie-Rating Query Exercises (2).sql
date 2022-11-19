/*SQL Social-Network Query Exercises Extras

Students at your hometown high school have decided to organize their social network using databases. So far, they have collected information about sixteen students in four grades, 9-12. Here's the schema:

Highschooler ( ID, name, grade )
English: There is a high school student with unique ID and a given first name in a certain grade.

Friend ( ID1, ID2 )
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123).

Likes ( ID1, ID2 )
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present.*/

/*Task 1: For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C.*/

select H.name, H.grade, H1.name, H1.grade, H2.name, H2.grade from Likes as L1, Likes as L2, Highschooler as H, Highschooler as H1, Highschooler as H2
where L1.ID2 = L2.ID1 and L1.ID1 <> L2.ID2 and H.ID = L1.ID1 and H1.ID = L1.ID2 and H2.ID = L2.ID2;

/*Task 2: Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades.*/

select distinct H.name, H.grade from Highschooler as H
join Friend as F on H.ID = F.ID1
where H.grade not in (select H1.grade from Highschooler as H1 join Friend as F1 on H1.ID = F1.ID2
where F1.ID1 = H.ID);

/*Task 3: What is the average number of friends per student? (Your result should be just one number.)*/

select avg(count)
from (select count(*) as count from Friend group by ID1);