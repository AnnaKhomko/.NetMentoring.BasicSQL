--Задание 1. Отработка SQL запросов на поиск и фильтрацию
--Задание 1.1. Простая фильтрация данных.

--Выбрать в таблице Orders заказы, 
--которые были доставлены после 6 мая 1998 года (колонка ShippedDate) 
--включительно и которые доставлены с ShipVia >= 2. 
--Запрос должен возвращать только колонки OrderID, ShippedDate и ShipVia.

select Orders.OrderID, Orders.ShippedDate, Orders.ShipVia from Orders
where Orders.ShippedDate >= '19980506' and Orders.ShipVia >= 2;

--Написать запрос, который выводит только недоставленные заказы из таблицы Orders. 
--В результатах запроса возвращать для колонки ShippedDate вместо значений NULL строку ‘Not Shipped’ 
--(использовать системную функцию CASЕ). Запрос должен возвращать только колонки OrderID и ShippedDate.

select Orders.OrderID,
case 
when Orders.ShippedDate IS NULL then 'Not Shipped' 
end ShippedDate
from Orders
where Orders.ShippedDate IS NULL;

--Выбрать в таблице Orders заказы, которые были доставлены после 6 мая 1998 года (ShippedDate) 
--не включая эту дату или которые еще не доставлены. В запросе должны возвращаться только
-- колонки OrderID (переименовать в Order Number) и ShippedDate (переименовать в Shipped Date). 
--В результатах запроса возвращать для колонки ShippedDate вместо значений NULL строку ‘Not Shipped’, 
--для остальных значений возвращать дату в формате по умолчанию.

select Orders.OrderID as 'Order Number',
case 
when Orders.ShippedDate IS NULL then 'Not Shipped'
else CAST(Orders.ShippedDate AS CHAR(20))
end 'Shipped else'
from Orders
where Orders.ShippedDate > '19980506' or Orders.ShippedDate IS NULL;

--Задание 1.2. Использование операторов IN, DISTINCT, ORDER BY, NOT

--Выбрать из таблицы Customers всех заказчиков, проживающих в USA и Canada. 
--Запрос сделать с только помощью оператора IN. 
--Возвращать колонки с именем пользователя и названием страны в результатах запроса. 
--Упорядочить результаты запроса по имени заказчиков и по месту проживания.

select Customers.CompanyName, Customers.Country from Customers
where Customers.Country in ('USA', 'Canada')
order by Customers.CompanyName, Customers.Country;

--Выбрать из таблицы Customers всех заказчиков, не проживающих в USA и Canada. 
--Запрос сделать с помощью оператора IN. Возвращать колонки с именем пользователя и названием страны в результатах запроса. 
--Упорядочить результаты запроса по имени заказчиков.

select Customers.CompanyName, Customers.Country from Customers
where Customers.Country not in ('USA', 'Canada')
order by Customers.CompanyName;

--Выбрать из таблицы Customers все страны, в которых проживают заказчики. 
--Страна должна быть упомянута только один раз и список отсортирован по убыванию.
--Не использовать предложение GROUP BY. Возвращать только одну колонку в результатах запроса.

select distinct Customers.Country from Customers
order by Customers.Country desc;

--Задание 1.3. Использование оператора BETWEEN, DISTINCT

--Выбрать все заказы (OrderID) из таблицы Order Details (заказы не должны повторяться), 
--где встречаются продукты с количеством от 3 до 10 включительно – это колонка Quantity в таблице Order Details. 
--Использовать оператор BETWEEN. Запрос должен возвращать только колонку OrderID.

select distinct [Order Details].OrderID from [Order Details]
where [Order Details].Quantity between 3 and 10;

--Выбрать всех заказчиков из таблицы Customers, у которых название страны начинается на буквы из диапазона b и g. 
--Использовать оператор BETWEEN. Проверить, что в результаты запроса попадает Germany. 
--Запрос должен возвращать только колонки CustomerID и Country и отсортирован по Country.

select Customers.CustomerID, Customers.Country from Customers
where Customers.Country between 'b' AND 'h'
order by Customers.Country;

--Выбрать всех заказчиков из таблицы Customers, у которых название страны начинается на буквы из диапазона b и g, не используя оператор BETWEEN.

select Customers.CustomerID, Customers.Country from Customers
where substring(Customers.Country, 1, 1) >= 'b' AND substring(Customers.Country, 1, 1) <= 'g'
order by Customers.Country;

--Задание 1.4. Использование оператора LIKE

--В таблице Products найти все продукты (колонка ProductName), где встречается подстрока 'chocolade'. 
--Известно, что в подстроке 'chocolade' может быть изменена одна буква 'c' в середине - найти все продукты, которые удовлетворяют этому условию.

select Products.ProductName from Products
where Products.ProductName like '%cho_olade%';

--Задание 2. Отработка SQL запросов на объединение таблиц и агрегацию
--Задание 2.1. Использование агрегатных функций (SUM, COUNT)

--Найти общую сумму всех заказов из таблицы Order Details с учетом количества закупленных товаров и скидок по ним. 
--Результатом запроса должна быть одна запись с одной колонкой с названием колонки 'Totals'.

select sum([Order Details].Quantity * ([Order Details].UnitPrice - ([Order Details].UnitPrice * [Order Details].Discount))) as Totals
from [Order Details];

--По таблице Orders найти количество заказов, которые еще не были доставлены (т.е. в колонке ShippedDate нет значения даты доставки). 
--Использовать при этом запросе только оператор COUNT. Не использовать предложения WHERE и GROUP.

select count(*) - count(Orders.ShippedDate) AS 'Not delivered count' 
from Orders;

--По таблице Orders найти количество различных покупателей (CustomerID), сделавших заказы. 
--Использовать функцию COUNT и не использовать предложения WHERE и GROUP.

select count(distinct Orders.CustomerID) from Orders;

--Задание 2.2. Соединение таблиц, использование агрегатных функций и предложений GROUP BY и HAVING

--По таблице Orders найти количество заказов с группировкой по годам. 
--В результатах запроса надо возвращать две колонки c названиями Year и Total. 
--Написать проверочный запрос, который вычисляет количество всех заказов.

select Orders.RequiredDate as 'Year', count(Orders.OrderID) as 'Total' from Orders
group by Orders.RequiredDate;

--По таблице Orders найти количество заказов, cделанных каждым продавцом. 
--Заказ для указанного продавца – это любая запись в таблице Orders, 
--где в колонке EmployeeID задано значение для данного продавца. 
--В результатах запроса надо возвращать колонку с именем продавца (Должно высвечиваться имя полученное конкатенацией LastName & FirstName. 
--Эта строка LastName & FirstName должна быть получена отдельным запросом в колонке основного запроса. 
--Также основной запрос должен использовать группировку по EmployeeID.) с названием колонки ‘Seller’ и колонку c количеством заказов возвращать с названием 'Amount'.
--Результаты запроса должны быть упорядочены по убыванию количества заказов.

select (
select CONCAT(Employees.FirstName, '', Employees.LastName)
from Employees
where Employees.EmployeeID = Orders.EmployeeID)
as 'Seller', COUNT(Orders.OrderID) AS 'Amount'
from Orders
group by Orders.EmployeeID
order by 'Amount' desc;

--По таблице Orders найти количество заказов, сделанных каждым продавцом и для каждого покупателя. 
--Необходимо определить это только для заказов, сделанных в 1998 году.

select Orders.CustomerID, Orders.EmployeeID, count(Orders.OrderID) as 'Count' from Orders
where year (Orders.OrderDate) = 1998
group by Orders.EmployeeID, Orders.CustomerID;

--Найти покупателей и продавцов, которые живут в одном городе. 
--Если в городе живут только один или несколько продавцов, или только один или несколько покупателей, 
--то информация о таких покупателя и продавцах не должна попадать в результирующий набор. Не использовать конструкцию JOIN.

select Customers.CustomerId, Employees.EmployeeID, Customers.City
from Customers
cross apply (select Employees.EmployeeID 
                FROM Employees
                WHERE Employees.City = Customers.City) Employees;

--Найти всех покупателей, которые живут в одном городе

select CustomersL.CustomerID as 'Customer id'
      ,CustomersR.CustomerID as 'Neighbor id'
      ,CustomersL.City       as 'City'
from Customers CustomersL
    left join Customers CustomersR 
        on CustomersL.CustomerID <> CustomersR.CustomerID AND CustomersL.City = CustomersR.City
order by CustomersL.CustomerID;

--По таблице Employees найти для каждого продавца его руководителя

select Employees.EmployeeID, Employees.FirstName,
(select Managers.FirstName 
        from dbo.Employees Managers
        where Managers.EmployeeID = Employees.ReportsTo) 
    as 'Manager'
from Employees;

--Задание 2.3. Использование JOIN

--Определить продавцов, которые обслуживают регион 'Western' (таблица Region).

select distinct 
     Employees.EmployeeId as 'EmployeeId'
    ,Employees.FirstName as 'First name'
from Employees Employees
        inner join EmployeeTerritories 
            on Employees.EmployeeID = EmployeeTerritories.EmployeeID
        inner join Territories 
            on EmployeeTerritories.TerritoryID = Territories.TerritoryID
        inner join Region Region 
            on Region.RegionID = Territories.RegionID
where Region.RegionDescription = 'Western';

--Выдать в результатах запроса имена всех заказчиков из таблицы Customers и суммарное количество их заказов из таблицы Orders. 
--Принять во внимание, что у некоторых заказчиков нет заказов, но они также должны быть выведены в результатах запроса. 
--Упорядочить результаты запроса по возрастанию количества заказов.

select Customers.CompanyName, count (Orders.OrderID) as 'Orders count' from Customers
left join Orders on Customers.CustomerID=Orders.CustomerID 
group by Customers.CompanyName
order by 'Orders count';

--Задание 2.4. Использование подзапросов

--Выдать всех поставщиков (колонка CompanyName в таблице Suppliers), 
--у которых нет хотя бы одного продукта на складе (UnitsInStock в таблице Products равно 0). 
--Использовать вложенный SELECT для этого запроса с использованием оператора IN.

select Suppliers.CompanyName from Suppliers
where  Suppliers.SupplierID in (select Products.SupplierID
from Products
where Products.UnitsInStock=0)

--Выдать всех продавцов, которые имеют более 150 заказов. Использовать вложенный SELECT.

select Employees.FirstName from Employees
where (select count(Orders.OrderID) 
	   from Orders
	   where Orders.EmployeeID=Employees.EmployeeID) > 150 

--Выдать всех заказчиков (таблица Customers), которые не имеют ни одного заказа (подзапрос по таблице Orders). 
--Использовать оператор EXISTS.

select Customers.CompanyName from Customers
where not exists(select Orders.OrderID 
				 from Orders
				 where Orders.CustomerID = Customers.CustomerID)