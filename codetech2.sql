use codtech;

create table rooms(
room_id int primary key auto_increment,
room_no int(10),
room_type varchar(20),
floor_no int(10),
availability Boolean default True,
capacity int(10),
price_per_night int(100)
);

create table customers(
customer_id int primary key auto_increment,
first_name varchar(50),
last_name varchar(50),
email varchar(50),
address varchar(50),
phoneno int(15),
city varchar(50),
country varchar(50),
gender varchar(10)
);

create table reservations(
room_id int ,
customer_id int,
primary key(room_id,customer_id),
reservation_date date not null,
check_in_date date not null,
check_out_date date not null,
foreign key(room_id)references rooms(room_id),
foreign key(customer_id)references customers(customer_id)
);

alter table reservations add reservations_id int(20) unique;


create table payments(
payment_id int primary key auto_increment,
customer_id int,
reservations_id int,
amount decimal not null,
payment_method enum('credit Card','Cash','Online Payment'),
payment_status enum('completed','pending','failed'),
foreign key(customer_id)references customers(customer_id),
foreign key(reservations_id)references reservations(reservations_id)
);

Insert into rooms values(501,101,'single',1,True,2,500);
Insert into rooms values(502,201,'Double',2,True,6,1500);
Insert into rooms values(503,302,'single',3,False,2,500);
Insert into rooms values(504,601,'single',6,True,2,500);
Insert into rooms values(505,703,'Triple',7,True,8,2500);
Insert into rooms values(506,701,'Triple',1,True,6,3000);
Insert into rooms values(507,801,'single',8,False,2,500);
Insert into rooms values(508,301,'Double',3,True,4,2000);
Insert into rooms values(509,102,'Triple',1,True,6,3000);
Insert into rooms values(510,401,'Double',4,True,6,1500);
 
select * from rooms;
desc rooms;

insert into customers values(1,'usha','naidu','usha@gmail.com','kodad',868807088,'kodad','India','Female');
insert into customers values(2,'vinay','naidu','vinay@gmail.com','suryapet',934626446,'suryapet','India','Male');
insert into customers values(3,'manisha','naidu','manisha@gmail.com','Hyd',123456789,'Hyd','India','Female');
insert into customers values(4,'supriya','Reddy','suppu@gmail.com','khammam',868807890,'khammam','India','Female');
insert into customers values(5,'ushasri','varma','ushasri@gmail.com','kodad',123457088,'suryapet','India','Female');
insert into customers values(6,'vijay','Reddy','vijay@gmail.com','khammam',567891234,'khammam','India','Male');
insert into customers values(7,'vamshi','varma','vamshi@gmail.com','hyd',868345088,'hyd','India','Male');
insert into customers values(8,'yathin','reddy','yathin@gmail.com','suryapet',868845678,'suryapet','India','Male');
insert into customers values(9,'Ajay','chowdary','ajay@gmail.com','hyd',868789088,'hyd','India','Male');
insert into customers values(10,'Triveni','chowdary','triveni@gmail.com','kodad',868823088,'kodad','India','Female');


select * from customers;
desc customers;

INSERT INTO reservations (room_id, customer_id, reservation_date, check_in_date, check_out_date,reservations_id)
VALUES
(501, 1, '2024-10-10', '2024-10-15', '2024-10-18',201),
(502, 2, '2024-10-11', '2024-10-16', '2024-10-19',202),
(503, 3, '2024-10-12', '2024-10-17', '2024-10-20',203),
(504, 4, '2024-10-13', '2024-10-18', '2024-10-21',204),
(505, 5, '2024-10-14', '2024-10-19', '2024-10-22',205);


select * from reservations;

INSERT INTO payments(payment_id,customer_id,reservations_id,amount,payment_method,payment_status)
VALUES
(10,1,201,500.00,'credit Card','completed'),
(20,2,202,2500.00,'credit Card','completed'),
(30,3,203,3000.00,'Online Payment','pending'),
(40,4,204,1500.00,'Cash','failed'),
(50,5,205,500.00,'Online Payment','completed');


select * from payments;

-- Query for available rooms for a specific date range

select r.room_id, r.room_no,r.room_type,r.floor_no,r.capacity,r.price_per_night
from rooms r
left join reservations res on r.room_id=res.room_id 
and (res.check_in_date <= '2024-10-20' and res.check_out_date>='2024-10-15')
where res.room_id is null;

 -- Query to find all customers who have made reservations
 
 select c.customer_id,c.first_name,c.last_name,c.email,res.check_in_date,res.check_out_date 
 from customers c
 join reservations res on c.customer_id=res.customer_id;

-- Query to calculate total revenue from payments

select sum(p.amount) as total_revenue
from payments p
where p.payment_status='completed';

-- Query to find the most booked room type

select r.room_type,count(res.room_id) as booking_count
from rooms r
join reservations res on r.room_id=res.room_id
group by r.room_type
order by booking_count desc 
limit 1;

-- Query to find cusomers who have pending payments

select c.customer_id,c.first_name,c.last_name, p.payment_id,p.amount,p.payment_status
from customers c
join payments p on c.customer_id=p.customer_id
where p.payment_status='pending';

-- Query for availability of rooms

select r.room_id,r.room_type,r.availability
from rooms r
where r.availability=True;

-- Query to find customers who have booked multiple rooms

select c.customer_id,c.first_name,c.last_name,count(res.room_id) as total_rooms_booked
from customers c
join reservations res on c.customer_id=res.customer_id 
group by c.customer_id,c.first_name,c.last_name
having total_rooms_booked>1;

-- Query to find reservations with failed payments

SELECT r.room_id, r.check_in_date, r.check_out_date, p.amount, p.payment_status
FROM reservations r
JOIN payments p ON r.reservations_id = p.reservations_id
WHERE p.payment_status = 'failed';

-- Query to list all customers who are currently staying in the hotel

SELECT c.first_name,c.last_name,r.room_id,res.check_in_date,res.check_out_date
from customers c
join reservations res on c.customer_id=res.customer_id
join rooms r on res.room_id=r.room_id
where curdate() between res.check_in_date and res.check_out_date;

-- Query to list all reservations made by a specific customer

select c.first_name,c.last_name,r.room_id,res.check_in_date,res.check_out_date
from customers c
join reservations res on c.customer_id=res.customer_id
join rooms r on res.room_id=r.room_id
where c.customer_id=1;

