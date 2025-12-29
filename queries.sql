create database Vehicle_Rental_System;

create table users(
  user_id serial primary key,
  name varchar(100) not null,
  email varchar(100) not null unique,
  phone varchar(15) not null,
  role varchar(50) check (role in('Admin', 'Customer')) not null
)

insert into users (name, email, phone, role) values
('Alice', 'alice@example.com', '1234567890', 'Customer'),
('Bob', 'bob@example.com', '0987654321', 'Admin'),
('Charlie', 'charlie@example.com','1122334455', 'Customer');


create table vehicles (
  vehicle_id serial primary key,
  name varchar(100),
  type varchar(20),
  model varchar(50),
  registration_number varchar(100) unique,
  rental_price integer,
  status VARCHAR(50) NOT NULL CHECK (status IN ('available', 'rented','maintenance'))
)


insert into vehicles (name,type,model,registration_number,
  rental_price,status
)values
('Toyota Corolla', 'car', 2022, 'ABC-123', 50, 'available'),
('Honda Civic', 'car', 2021, 'DEF-456', 60, 'rented'),
('Yamaha R15', 'bike', 2023, 'GHI-789', 30, 'available'),
('Ford F-150', 'truck', 2020, 'JKL-012', 100, 'maintenance');

create table bookings (
 booking_id serial primary key,
 user_id integer references users(user_id),
 vehicle_id integer references vehicles(vehicle_id),
 start_date date,
 end_date date,
 status varchar(20),
 total_cost integer
)


insert into bookings (user_id,vehicle_id,start_date,
  end_date,status,total_cost
)
values
(1, 2, '2023-10-01', '2023-10-05', 'completed', 240),
(1, 2, '2023-11-01', '2023-11-03', 'completed', 120),
(3, 2, '2023-12-01', '2023-12-02', 'confirmed', 60),
(1, 1, '2023-12-10', '2023-12-12', 'pending', 100);


--Query 1: JOIN

select b.booking_id, u.name as customer_name ,v.name as vehicle_name,
b.start_date, b.end_date, b.status from bookings b
inner join users u on b.user_id = u.user_id 
inner join vehicles v on b.vehicle_id = v.vehicle_id


--Query 2: EXISTS
  
select * from vehicles v
where not exists ( select 1 from bookings b 
where b.vehicle_id = v.vehicle_id) 
order by vehicle_id asc;


--Query 3: WHERE

select * from vehicles  
where (status = 'available' and type = 'car');

-- Query 4

select v.name as vehicle_name, count(*) as total_bookings from vehicles v 
inner join bookings b on v.vehicle_id = b.vehicle_id 
group by v.name having count(*) > 2


