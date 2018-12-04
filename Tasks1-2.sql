--������� 1. ��������� SQL �������� �� ����� � ����������
--������� 1.1. ������� ���������� ������.

--������� � ������� Orders ������, 
--������� ���� ���������� ����� 6 ��� 1998 ���� (������� ShippedDate) 
--������������ � ������� ���������� � ShipVia >= 2. 
--������ ������ ���������� ������ ������� OrderID, ShippedDate � ShipVia.

select Orders.OrderID, Orders.ShippedDate, Orders.ShipVia from Orders
where Orders.ShippedDate >= '19980506' and Orders.ShipVia >= 2;

--�������� ������, ������� ������� ������ �������������� ������ �� ������� Orders. 
--� ����������� ������� ���������� ��� ������� ShippedDate ������ �������� NULL ������ �Not Shipped� 
--(������������ ��������� ������� CAS�). ������ ������ ���������� ������ ������� OrderID � ShippedDate.

select Orders.OrderID,
case 
when Orders.ShippedDate IS NULL then 'Not Shipped' 
end ShippedDate
from Orders
where Orders.ShippedDate IS NULL;

--������� � ������� Orders ������, ������� ���� ���������� ����� 6 ��� 1998 ���� (ShippedDate) 
--�� ������� ��� ���� ��� ������� ��� �� ����������. � ������� ������ ������������ ������
-- ������� OrderID (������������� � Order Number) � ShippedDate (������������� � Shipped Date). 
--� ����������� ������� ���������� ��� ������� ShippedDate ������ �������� NULL ������ �Not Shipped�, 
--��� ��������� �������� ���������� ���� � ������� �� ���������.

select Orders.OrderID as 'Order Number',
case 
when Orders.ShippedDate IS NULL then 'Not Shipped'
else CAST(Orders.ShippedDate AS CHAR(20))
end 'Shipped else'
from Orders
where Orders.ShippedDate > '19980506' or Orders.ShippedDate IS NULL;

--������� 1.2. ������������� ���������� IN, DISTINCT, ORDER BY, NOT

--������� �� ������� Customers ���� ����������, ����������� � USA � Canada. 
--������ ������� � ������ ������� ��������� IN. 
--���������� ������� � ������ ������������ � ��������� ������ � ����������� �������. 
--����������� ���������� ������� �� ����� ���������� � �� ����� ����������.

select Customers.CompanyName, Customers.Country from Customers
where Customers.Country in ('USA', 'Canada')
order by Customers.CompanyName, Customers.Country;

--������� �� ������� Customers ���� ����������, �� ����������� � USA � Canada. 
--������ ������� � ������� ��������� IN. ���������� ������� � ������ ������������ � ��������� ������ � ����������� �������. 
--����������� ���������� ������� �� ����� ����������.

select Customers.CompanyName, Customers.Country from Customers
where Customers.Country not in ('USA', 'Canada')
order by Customers.CompanyName;

--������� �� ������� Customers ��� ������, � ������� ��������� ���������. 
--������ ������ ���� ��������� ������ ���� ��� � ������ ������������ �� ��������.
--�� ������������ ����������� GROUP BY. ���������� ������ ���� ������� � ����������� �������.

select distinct Customers.Country from Customers
order by Customers.Country desc;

--������� 1.3. ������������� ��������� BETWEEN, DISTINCT

--������� ��� ������ (OrderID) �� ������� Order Details (������ �� ������ �����������), 
--��� ����������� �������� � ����������� �� 3 �� 10 ������������ � ��� ������� Quantity � ������� Order Details. 
--������������ �������� BETWEEN. ������ ������ ���������� ������ ������� OrderID.

select distinct [Order Details].OrderID from [Order Details]
where [Order Details].Quantity between 3 and 10;

--������� ���� ���������� �� ������� Customers, � ������� �������� ������ ���������� �� ����� �� ��������� b � g. 
--������������ �������� BETWEEN. ���������, ��� � ���������� ������� �������� Germany. 
--������ ������ ���������� ������ ������� CustomerID � Country � ������������ �� Country.

select Customers.CustomerID, Customers.Country from Customers
where Customers.Country between 'b' AND 'h'
order by Customers.Country;

--������� ���� ���������� �� ������� Customers, � ������� �������� ������ ���������� �� ����� �� ��������� b � g, �� ��������� �������� BETWEEN.

select Customers.CustomerID, Customers.Country from Customers
where substring(Customers.Country, 1, 1) >= 'b' AND substring(Customers.Country, 1, 1) <= 'g'
order by Customers.Country;

--������� 1.4. ������������� ��������� LIKE

--� ������� Products ����� ��� �������� (������� ProductName), ��� ����������� ��������� 'chocolade'. 
--��������, ��� � ��������� 'chocolade' ����� ���� �������� ���� ����� 'c' � �������� - ����� ��� ��������, ������� ������������� ����� �������.

select Products.ProductName from Products
where Products.ProductName like '%cho_olade%';

--������� 2. ��������� SQL �������� �� ����������� ������ � ���������
--������� 2.1. ������������� ���������� ������� (SUM, COUNT)

--����� ����� ����� ���� ������� �� ������� Order Details � ������ ���������� ����������� ������� � ������ �� ���. 
--����������� ������� ������ ���� ���� ������ � ����� �������� � ��������� ������� 'Totals'.

select sum([Order Details].Quantity * ([Order Details].UnitPrice - ([Order Details].UnitPrice * [Order Details].Discount))) as Totals
from [Order Details];

--�� ������� Orders ����� ���������� �������, ������� ��� �� ���� ���������� (�.�. � ������� ShippedDate ��� �������� ���� ��������). 
--������������ ��� ���� ������� ������ �������� COUNT. �� ������������ ����������� WHERE � GROUP.

select count(*) - count(Orders.ShippedDate) AS 'Not delivered count' 
from Orders;

--�� ������� Orders ����� ���������� ��������� ����������� (CustomerID), ��������� ������. 
--������������ ������� COUNT � �� ������������ ����������� WHERE � GROUP.

select count(distinct Orders.CustomerID) from Orders;

--������� 2.2. ���������� ������, ������������� ���������� ������� � ����������� GROUP BY � HAVING

--�� ������� Orders ����� ���������� ������� � ������������ �� �����. 
--� ����������� ������� ���� ���������� ��� ������� c ���������� Year � Total. 
--�������� ����������� ������, ������� ��������� ���������� ���� �������.

select Orders.RequiredDate as 'Year', count(Orders.OrderID) as 'Total' from Orders
group by Orders.RequiredDate;

--�� ������� Orders ����� ���������� �������, c�������� ������ ���������. 
--����� ��� ���������� �������� � ��� ����� ������ � ������� Orders, 
--��� � ������� EmployeeID ������ �������� ��� ������� ��������. 
--� ����������� ������� ���� ���������� ������� � ������ �������� (������ ������������� ��� ���������� ������������� LastName & FirstName. 
--��� ������ LastName & FirstName ������ ���� �������� ��������� �������� � ������� ��������� �������. 
--����� �������� ������ ������ ������������ ����������� �� EmployeeID.) � ��������� ������� �Seller� � ������� c ����������� ������� ���������� � ��������� 'Amount'.
--���������� ������� ������ ���� ����������� �� �������� ���������� �������.

select (
select CONCAT(Employees.FirstName, '', Employees.LastName)
from Employees
where Employees.EmployeeID = Orders.EmployeeID)
as 'Seller', COUNT(Orders.OrderID) AS 'Amount'
from Orders
group by Orders.EmployeeID
order by 'Amount' desc;

--�� ������� Orders ����� ���������� �������, ��������� ������ ��������� � ��� ������� ����������. 
--���������� ���������� ��� ������ ��� �������, ��������� � 1998 ����.

select Orders.CustomerID, Orders.EmployeeID, count(Orders.OrderID) as 'Count' from Orders
where year (Orders.OrderDate) = 1998
group by Orders.EmployeeID, Orders.CustomerID;

--����� ����������� � ���������, ������� ����� � ����� ������. 
--���� � ������ ����� ������ ���� ��� ��������� ���������, ��� ������ ���� ��� ��������� �����������, 
--�� ���������� � ����� ���������� � ��������� �� ������ �������� � �������������� �����. �� ������������ ����������� JOIN.

select Customers.CustomerId, Employees.EmployeeID, Customers.City
from Customers
cross apply (select Employees.EmployeeID 
                FROM Employees
                WHERE Employees.City = Customers.City) Employees;

--����� ���� �����������, ������� ����� � ����� ������

select CustomersL.CustomerID as 'Customer id'
      ,CustomersR.CustomerID as 'Neighbor id'
      ,CustomersL.City       as 'City'
from Customers CustomersL
    left join Customers CustomersR 
        on CustomersL.CustomerID <> CustomersR.CustomerID AND CustomersL.City = CustomersR.City
order by CustomersL.CustomerID;

--�� ������� Employees ����� ��� ������� �������� ��� ������������

select Employees.EmployeeID, Employees.FirstName,
(select Managers.FirstName 
        from dbo.Employees Managers
        where Managers.EmployeeID = Employees.ReportsTo) 
    as 'Manager'
from Employees;

--������� 2.3. ������������� JOIN

--���������� ���������, ������� ����������� ������ 'Western' (������� Region).

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

--������ � ����������� ������� ����� ���� ���������� �� ������� Customers � ��������� ���������� �� ������� �� ������� Orders. 
--������� �� ��������, ��� � ��������� ���������� ��� �������, �� ��� ����� ������ ���� �������� � ����������� �������. 
--����������� ���������� ������� �� ����������� ���������� �������.

select Customers.CompanyName, count (Orders.OrderID) as 'Orders count' from Customers
left join Orders on Customers.CustomerID=Orders.CustomerID 
group by Customers.CompanyName
order by 'Orders count';

--������� 2.4. ������������� �����������

--������ ���� ����������� (������� CompanyName � ������� Suppliers), 
--� ������� ��� ���� �� ������ �������� �� ������ (UnitsInStock � ������� Products ����� 0). 
--������������ ��������� SELECT ��� ����� ������� � �������������� ��������� IN.

select Suppliers.CompanyName from Suppliers
where  Suppliers.SupplierID in (select Products.SupplierID
from Products
where Products.UnitsInStock=0)

--������ ���� ���������, ������� ����� ����� 150 �������. ������������ ��������� SELECT.

select Employees.FirstName from Employees
where (select count(Orders.OrderID) 
	   from Orders
	   where Orders.EmployeeID=Employees.EmployeeID) > 150 

--������ ���� ���������� (������� Customers), ������� �� ����� �� ������ ������ (��������� �� ������� Orders). 
--������������ �������� EXISTS.

select Customers.CompanyName from Customers
where not exists(select Orders.OrderID 
				 from Orders
				 where Orders.CustomerID = Customers.CustomerID)