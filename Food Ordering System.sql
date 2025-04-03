--DBMS assigment

Create Database FoodOrderingSystem;

Use FoodOrderingSystem;

--create table that are not dependant yet to each other
--order are arranged to descending vertically
Create table Manager
(ManagerID nvarchar(50) not null Primary key,
Name nvarchar(50));

Create table Members
(MemberID nvarchar(50) not null Primary key,
Gender nvarchar(50),
Role nvarchar(50),
MemberName nvarchar(50));

Create table Food
(FoodID nvarchar(50) not null Primary key,
FoodName nvarchar(50),
Price decimal (10,2));

Create table Feedback
(FeedbackID nvarchar(50) not null Primary key,
Rating int,
MemberID nvarchar(50) Foreign key references Members(MemberID),
FoodID nvarchar(50) Foreign key references Food(FoodId));

--tables below have alter commands for later execution after the dependant table are created(OrdersFood) and value inserted
Create table CartSummary
(CartID nvarchar(50) not null Primary key,
TotalPrice decimal (10,2));

Create table Payment
(PaymentID nvarchar(50) not null Primary key,
PaymentDetails nvarchar(50));

Create table Chef 
(ChefID nvarchar(50) not null Primary key,
ChefName nvarchar(50));

Create table OrdersFood
(OrderID nvarchar(50) not null Primary key,
OrderDate date,
Quantity int,
ContactNumbers nvarchar (15),
MemberID nvarchar(50) Foreign key references Members(MemberID),
FoodID nvarchar(50) Foreign key references Food(FoodID),
ManagerID nvarchar(50) Foreign key references Manager(ManagerID),
ChefID nvarchar(50) Foreign key references Chef(ChefID),
StatusOfDelivery nvarchar(50));


Insert into Members values
('M01', 'Male', 'Student', 'Bryan'),
('M02', 'Male', 'Lecturer', 'Jason'),
('M03', 'Male', 'Student', 'Jack'),
('M04', 'Male', 'Student', 'Peter'),
('M05', 'Female', 'Student', 'Aurora'),
('M06', 'Female', 'Lecturer', 'Shamirah');

Insert into Food values
('F01', 'Nasi Lemak', '5.50'),
('F02', 'Pan Mee', '8.00'),
('F03', 'Chicken Rice', '9.50'),
('F04', 'Yee Mee', '8.50'),
('F05', 'Cabonara Spaghetti', '8.50'),
('F06', 'Chicken Chop', '10.00'),
('F07', 'Roti Canai', '2.00');

Insert into Feedback values
('FB01', '5', 'M06', 'F02'),
('FB02', '4', 'M06', 'F07'),
('FB03', '2', 'M06', 'F01'),
('FB04', '5', 'M03', 'F02'),
('FB05', '3', 'M03', 'F04'),
('FB06', '5', 'M01', 'F07');

Select Feedback.FeedbackID, Feedback.Rating, Feedback.MemberID, Feedback.FoodID, Food.FoodName from Feedback
Full join Food on Feedback.FeedbackID = Food.FoodID
Group by Feedback.FeedbackID, Feedback.Rating, Feedback.MemberID, Feedback.FoodID, Food.FoodName
Having Food.FoodName = 'Nasi Lemak';

Insert into Manager values
('A01', 'Justin');

Insert into CartSummary values
('CT01', '11.00'),
('CT02', '4.00'),
('CT03', '9.50'),
('CT04', '8.00'),
('CT05', '10.00'),
('CT06', '8.50'),
('CT07', '2.00');

--alter commands for payment since it's only dependant on cart,
--we can ignore the wait for values to be inserted into ordersfood
Alter table Payment
Add CartID nvarchar(50) Foreign key references CartSummary(CartID);

Insert into Payment values
('P01', 'Visa', 'CT01'),
('P02', 'MasterCard', 'CT02'),
('P03', 'MasterCard', 'CT03'),
('P04', 'TnG', 'CT04'),
('P05', 'TnG', 'CT05'),
('P06', 'TnG', 'CT06'),
('P07', 'TnG', 'CT07');

Insert into Chef values
('C01', 'Henry'),
('C02', 'Kow'),
('C03', 'Lian');


Insert into OrdersFood values
('OR01', '28 February 2024', '2', '012345678', 'M01', 'F01', 'A01', 'C01', 'Delivered'),
('OR02', '28 February 2024', '2', '016987654', 'M02', 'F07', 'A01', 'C01', 'Delivered'),
('OR03', '28 February 2024', '1', '016321678', 'M03', 'F03', 'A01', 'C01', 'Delivered'),
('OR04', '29 February 2024', '1', '017898678', 'M04', 'F02', 'A01', 'C02', 'Delivering'),
('OR05', '29 February 2024', '1', '012232678', 'M02', 'F06', 'A01', 'C02', 'Delivering'),
('OR06', '29 February 2024', '1', '016561678', 'M06', 'F04', 'A01', 'C03', 'Preparing'),
('OR07', '29 February 2024', '1', '011232678', 'M02', 'F07', 'A01', 'C03', 'Preparing');

--alter commands after the value of ordersfood are inserted
Alter table CartSummary
Add OrderID nvarchar(50) Foreign key references OrdersFood(OrderID);

Update CartSummary
set OrderID = 'OR01' where CartID = 'CT01';
Update CartSummary
set OrderID = 'OR02' where CartID = 'CT02';
Update CartSummary
set OrderID = 'OR03' where CartID = 'CT03';
Update CartSummary
set OrderID = 'OR04' where CartID = 'CT04';
Update CartSummary
set OrderID = 'OR05' where CartID = 'CT05';
Update CartSummary
set OrderID = 'OR06' where CartID = 'CT06';
Update CartSummary
set OrderID = 'OR07' where CartID = 'CT07';

--for checking
select * from chef;
select * from cartsummary;
select * from payment;
select * from manager;
select * from members;
select * from ordersfood;
select * from feedback;
select * from food;

--Queries for assignment
--i
select Food.FoodID, Food.FoodName, Feedback.Rating from Food
full join Feedback on Food.FoodID = Feedback.FoodID order by Rating desc;

--ii
select Members.MemberID, Members.MemberName, count(Feedback.FeedbackID) as 'TotalFeedback' from Members 
full join Feedback on Members.MemberID=Feedback.MemberID
group by Members.MemberID, Members.MemberName;

--iii
select OrdersFood.ManagerID, OrdersFood.ChefID, Chef.ChefName, count(OrdersFood.FoodID) as 'TotalOrdered'
from OrdersFood
full join Chef on OrdersFood.ChefID = Chef.ChefID
group by OrdersFood.ManagerID, OrdersFood.ChefID, Chef.ChefName;

--iv
select OrdersFood.ChefID, Chef.ChefName, count(OrdersFood.FoodID) as 'TotalCooked'
from OrdersFood
full join Chef on OrdersFood.ChefID = Chef.ChefID
group by OrdersFood.ChefID, Chef.ChefName;

--v
select Food.FoodID, Food.FoodName, avg(Feedback.Rating) as 'AverageRating'
from Food
full join Feedback on Food.FoodID = Feedback.FoodID
group by Food.FoodID, Food.FoodName
having avg(Feedback.Rating) > (select avg(Rating) from Feedback);

--vi
select top 3 Food.FoodID, Food.FoodName, Food.Price, sum(OrdersFood.Quantity) as 'QuantitySold'
from Food
full join OrdersFood on Food.FoodID = OrdersFood.FoodID
group by Food.FoodID, Food.FoodName, Food.Price
order by sum(OrdersFood.Quantity) desc;

--vii
select top 3 Members.MemberID, Members.MemberName, Members.Role, sum(CartSummary.TotalPrice) as 'TotalSpent' from Members
full join OrdersFood on Members.MemberID = OrdersFood.MemberID
full join CartSummary on OrdersFood.OrderID = CartSummary.OrderID
group by Members.MemberID, Members.MemberName, Members.Role
order by TotalSpent desc;

--viii
Select Members.MemberID, Members.Role, Members.Gender, Members.MemberName, count(*) as TotalMembers From Members
Group by Members.MemberID, Members.Role, Members.Gender, Members.MemberName
order by Members.Gender;

--ix
select Members.MemberID, Members.Role, OrdersFood.ContactNumbers, OrdersFood.FoodID, Food.FoodName, OrdersFood.Quantity, OrdersFood.OrderDate, OrdersFood.StatusOfDelivery
from OrdersFood
full join Members on OrdersFood.MemberID = Members.MemberID
full join Food on OrdersFood.FoodID = Food.FoodID
where OrdersFood.StatusOfDelivery <> 'Delivered';

--x
select Members.MemberID, Members.MemberName, Members.Role as MemberType, count(OrdersFood.OrderID) as TotalOrders
from Members
join OrdersFood on Members.MemberID = OrdersFood.MemberID
group by Members.MemberID, Members.MemberName, Members.Role
having count(OrdersFood.OrderID) > 2;


Select Food.FoodName, Food.FoodID, Feedback.Rating from Food
full join Feedback on Food.FoodID = Feedback.FoodID order by rating desc;

Select Members.MemberID, Members.MemberName, count(Feedback.FeedbackID) as 'Total Number of Feedback' from Members
full join Feedback on Members.MemberID = Feedback.MemberID
group by Members.MemberID, Members.MemberName;

Select OrdersFood.ManagerID, OrdersFood.ChefID, Chef.ChefName, count(OrdersFood.OrderID) as 'Total Food' from OrdersFood
Full join Chef on OrdersFood.ChefID = Chef.ChefID
group by OrdersFood.ManagerID, OrdersFood.ChefID, Chef.ChefName;

Select Chef.ChefID, Chef.ChefName, count(OrdersFood.OrderID) as 'Total Food' from Chef
Full join OrdersFood on Chef.ChefID = OrdersFood.ChefID
group by Chef.ChefID,Chef.ChefName; 

Select Food.FoodID, Food.FoodName, avg(Feedback.Rating) as 'Average Rating' from Food
full join Feedback on Food.FoodID = Feedback.FoodID
group by Food.FoodID, Food.FoodName
having avg(Feedback.Rating) > (select avg(rating) from Feedback);

Select top 3 Food.FoodID, Food.FoodName, Food.Price, sum(OrdersFood.Quantity)as 'Quantity Sold' From Food
full join OrdersFood on Food.FoodID = OrdersFood.FoodID
group by Food.FoodID, Food.FoodName, Food.Price
order by sum(OrdersFood.Quantity) desc;

Select top 3 Members.MemberID, Members.MemberName, Members.Role, count(CartSummary.TotalPrice) as 'Spent Most' From Members
Full join OrdersFood on Members.MemberID = OrdersFood.MemberID
full join CartSummary on OrdersFood.OrderID = CartSummary.OrderID
group by Members.MemberID, Members.MemberName, Members.Role
order by sum(CartSummary.TotalPrice) desc;

Select Members.MemberID, Members.MemberName, Members.Role, Members.Gender, count(Members.Gender) as 'Total Members' from Members
group by Members.MemberID, Members.MemberName, Members.Role, Members.Gender
order by Members.Role, Members.Gender;

Select Members.MemberID, Members.Role, OrdersFood.ContactNumbers, Food.FoodID, Food.FoodName, OrdersFood.Quantity, OrdersFood.OrderDate, OrdersFood.StatusOfDelivery
from Members
full join OrdersFood on Members.MemberID = OrdersFood.MemberID
full join Food on OrdersFood.FoodID = Food.FoodID
Where OrdersFood.StatusOfDelivery <> 'Delivered';

Select Members.MemberID, Members.MemberName, Members.Role, count(OrdersFood.OrderID) as 'Total Orders' from Members
full join OrdersFood on Members.MemberID = OrdersFood.MemberID
group by Members.MemberID, Members.MemberName, Members.Role
having count(OrdersFood.OrderID) > 2;