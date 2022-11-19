/*SQL Social-Network Modification Exercises

Students at your hometown high school have decided to organize their social network using databases. 
So far, they have collected information about sixteen students in four grades, 9-12.

Highschooler ( ID, name, grade )

Friend ( ID1, ID2 )
The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123).

Likes ( ID1, ID2 )
The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, 
there is no guarantee that (456, 123) is also present.*/

/*Task 1: It's time for the seniors to graduate. Remove all 12th graders from Highschooler.*/

delete from Highschooler where grade = 12;

 /*Task 2: f two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.*/

delete from Likes
where ID2 in (select ID2 from Friend where Friend.ID1 = Likes.ID1) 
and ID2 not in (select L.ID1 from Likes L where L.ID2 = Likes.ID1);

/*Task 3: For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, 
friendships that already exist, or friendships with oneself.*/

insert into Friend
select distinct F1.ID1, F2.ID2 from Friend as F1, Friend as F2
where F1.ID2 = F2.ID1 and F1.ID1 <> F2.ID2 and F1.ID1 not in
(select F3.ID1 from Friend as F3 where F3.ID2 = F2.ID2);
