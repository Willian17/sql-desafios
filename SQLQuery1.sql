-- INTRODUCAO --
SELECT FirstName, LastName 
FROM Person.Person;

SELECT DISTINCT LastName 
FROM Person.Person;

SELECT name 
FROM Production.Product 
WHERE "Weight" > 500 AND "Weight" <= 700;

SELECT * 
FROM HumanResources.Employee 
WHERE MaritalStatus = 'M' AND SalariedFlag = 1;

Select EmailAddress
FROM Person.EmailAddress 
WHERE BusinessEntityID IN
(SELECT BusinessEntityID FROM Person.Person WHERE FirstName = 'Peter' AND LastName = 'Krebs');

-- COUNT (FUNCAO DE AGREGACAO) -- 

SELECT count(*) 
FROM Production.Product;

SELECT count(size) 
FROM Production.Product;

SELECT count(DISTINCT size) 
FROM Production.Product;

-- TOP E ORDER BY--
SELECT TOP 10 ProductID 
FROM Production.Product 
ORDER BY ListPrice desc;

SELECT TOP 4 "Name", ProductNumber  
FROM Production.Product 
ORDER BY ProductID asc;

SELECT count(ListPrice) 
FROM Production.Product 
WHERE ListPrice > 1500;

-- LIKE E between  --
SELECT count(LastName) 
FROM Person.Person 
WHERE LastName LIKE 'p%';

SELECT COUNT(DISTINCT (city)) 
FROM Person.Address;

SELECT DISTINCT(city) 
FROM Person.Address;

SELECT COUNT(*) 
FROM Production.Product 
WHERE Color = 'Red' and  ListPrice between 500 and 1000;

SELECT COUNT(*) 
FROM Production.Product
WHERE "Name" LIKE '%road%';


-- WHERE filtra antes do agrupamento, HAVING filtra depois do agrupamento -- 

SELECT FirstName, count(FirstName) as "quantidade" 
FROM Person.Person
WHERE Title = 'Mr.'
GROUP BY FirstName
HAVING count(FirstName) > 10;

SELECT StateProvinceID, COUNT(StateProvinceID) AS "Quantidade"
FROM Person.Address
GROUP BY StateProvinceID
HAVING COUNT(StateProvinceID) > 1000;

SELECT ProductID, AVG(LineTotal) as "MEDIA"
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING AVG(LineTotal) < 1000000;

-- AS -- 

SELECT FirstName AS "Nome", LastName AS "Sobrenome" 
FROM Person.Person;

SELECT ProductNumber AS "Numero do Produto"
FROM Production.Product;

SELECT UnitPrice AS "Preço Unitário"
FROM Sales.SalesOrderDetail;

SELECT * 
FROM Person.PhoneNumberType;

-- JOINS -- 

SELECT TOP 10 PE.BusinessEntityID, PN.Name, PN.PhoneNumberTypeID, PE.PhoneNumber
FROM Person.PersonPhone PE
INNER JOIN Person.PhoneNumberType PN ON PN.PhoneNumberTypeID = PE.PhoneNumberTypeID;

SELECT TOP 10 PA.AddressID, PA.City, PS.StateProvinceID, PS.Name
FROM person.StateProvince PS
INNER JOIN Person.Address PA ON PA.StateProvinceID = PS.StateProvinceID;

-- INNER JOIN (interseção) -- 

-- FULL OUTER JOIN (UNIÃO) -- 

-- LEFT JOIN (interseção + A) --

-- RIGHT JOIN (interseção + B) --

-- QUANTAS PESSOAS TEM CARTÃO DE CRÉDITO CADASTRADO = 19118

SELECT COUNT(*) 
FROM Person.Person PP
INNER JOIN Sales.PersonCreditCard PC ON PC.BusinessEntityID = PP.BusinessEntityID;

-- QUANTAS PESSOAS NÃO TEM CARTÃO DE CRÉDITO CADASTRADO =  854

SELECT COUNT(*)
FROM Person.Person PP
LEFT JOIN Sales.PersonCreditCard PC ON PC.BusinessEntityID = PP.BusinessEntityID
WHERE PC.BusinessEntityID IS NULL;

-- QUANTOS CARTÕES DE CRÉDITO CADASTRADOS SEM DONO = 0
SELECT *
FROM Person.Person PP
RIGHT JOIN Sales.PersonCreditCard PC ON PC.BusinessEntityID = PP.BusinessEntityID
WHERE PP.BusinessEntityID IS NULL;

-- SELF JOIN (Utilizar database NORTHWIND) -- 

SELECT A.FirstName, B.FirstName, A.HireDate
FROM Employees A, Employees B
WHERE DATEPART(YEAR, a.HireDate) = DATEPART(YEAR, b.HireDate)
AND A.FirstName <> B.FirstName;

SELECT TOP 10 A.ProductID, B.ProductID, A.Discount
FROM [Order Details] A, [Order Details] B
WHERE A.Discount = B.Discount
ORDER BY Discount DESC;

-- UNION --

SELECT Name, ListPrice 
FROM Production.Product
WHERE Name LIKE 'T%'
UNION
SELECT Name, ListPrice
FROM Production.Product
WHERE ListPrice > 1000
ORDER BY ListPrice desc;

-- SUBQUERY --

SELECT * 
FROM Person.Address
WHERE StateProvinceID IN (
SELECT StateProvinceID
FROM Person.StateProvince
WHERE Name = 'Alberta');

-- DATEPART -- 

SELECT SUM(SalesQuota) AS "Total", DATEPART(YEAR, QuotaDate) as "Ano"
FROM Sales.SalesPersonQuotaHistory
GROUP BY DATEPART(YEAR, QuotaDate)
ORDER BY "Ano" ASC;

SELECT SUM(SalesQuota) AS "Total", DATEPART(MONTH, QuotaDate) as "Mes"
FROM Sales.SalesPersonQuotaHistory
GROUP BY DATEPART(MONTH, QuotaDate)
ORDER BY "Mes" ASC;

-- MANIPULACAO STRING -- 

SELECT CONCAT(FirstName, ' ', MiddleName, ' ', LastName) as "Nome completo"
FROM Person.Person;

SELECT TOP 10 FirstName, LEN(FirstName) as "Tamanho"
FROM Person.Person
ORDER BY "Tamanho" desc;

SELECT FirstName, LOWER(FirstName) as "Nome minisculo"
FROM Person.Person;

SELECT FirstName, UPPER(FirstName) as "Nome Maisculo"
FROM Person.Person;

SELECT FirstName, SUBSTRING(FirstName, 1,3) as "Nome ABREVIADO"
FROM Person.Person;

SELECT ProductNumber, REPLACE(ProductNumber, '-', '@') 
FROM Production.Product;

-- operações matemáticas --

SELECT SO.ProductID, PP.Name,
SUM(SO.LineTotal) AS "TOTAL", AVG(SO.LineTotal) AS "MEDIA", 
MAX(SO.LineTotal) AS "Melhor Venda", MIN(SO.LineTotal) AS "Pior Venda"
FROM Sales.SalesOrderDetail SO
INNER JOIN Production.Product PP ON PP.ProductID = SO.ProductID
GROUP BY SO.ProductID, PP.NAME
ORDER BY "Total" desc;

-- CREATE TABLE -- 

CREATE TABLE Marca (
Id INT PRIMARY KEY,
Nome VARCHAR(20) NOT NULL
);

CREATE TABLE Tenis (
Id INT PRIMARY KEY,
Nome VARCHAR(20) NOT NULL,
Preco NUMERIC NOT NULL,
MarcaId INT FOREIGN KEY REFERENCES Marca(Id) NOT NULL
);

-- INSERT INTO --

INSERT INTO Marca (Id, Nome)
VALUES(1, 'Nike');

INSERT INTO Marca (Id, Nome)
VALUES(2, 'Adidas'), (3, 'Puma'), (4, 'Mizuno');

INSERT INTO Tenis (Id, Nome, Preco, MarcaId)
VALUES 
(1, 'Downshifter', 227.99, 1),
(2, 'Coreracer', 179.99, 2),
(3, 'Flyer Runner', 199.49, 3),
(4, 'Wave Titan', 224.99, 4);

SELECT T.Id, T.Nome, T.Preco, M.Nome
FROM Tenis T
LEFT JOIN Marca M ON M.Id = T.MarcaId
ORDER BY T.Preco desc;

-- UPDATE --

UPDATE Tenis 
SET Preco = 280.99
WHERE Id = 2 and MarcaId = 2;

UPDATE Tenis 
SET Nome = 'Air Force'
WHERE Id = 1;

-- DELETE --

DELETE FROM Tenis 
WHERE Preco IN (SELECT MIN(PRECO) FROM TENIS)

-- ALTER TABLE --

ALTER TABLE Tenis
ALTER COLUMN Preco REAL NOT NULL;

EXEC sp_RENAME 'Tenis.preco', 'precoUnitario', 'COLUMN'

SELECT T.Id, T.Nome, T.PrecoUnitario, M.Nome
FROM Tenis T
LEFT JOIN Marca M ON M.Id = T.MarcaId
ORDER BY T.PrecoUnitario desc;

EXEC sp_RENAME 'Marca', 'MarcaTenis'

SELECT T.Id, T.Nome, T.PrecoUnitario, M.Nome
FROM Tenis T
LEFT JOIN MarcaTenis M ON M.Id = T.MarcaId
ORDER BY T.PrecoUnitario desc;

-- DROP TABLE --

DROP TABLE Tenis;

DROP TABLE MarcaTenis;

-- CHECK --

CREATE TABLE AlistamentoMilitar(
Id INT PRIMARY KEY,
Nome VARCHAR(255) NOT NULL,
Idade int CHECK (idade >= 18)
)

INSERT INTO AlistamentoMilitar(Id, Nome, Idade)
VALUES(1, 'Willian', 17)

CREATE TABLE ContaPoupanca(
Id INT PRIMARY KEY,
Valor int CHECK (valor >= 1000)
)

INSERT INTO ContaPoupanca(Id, Valor)
VALUES(1, 999)

DROP TABLE  AlistamentoMilitar;
DROP TABLE ContaPoupanca;

-- UNIQUE --
CREATE TABLE UserLogin(
Id INT Primary Key,
email VARCHAR(100) UNIQUE
);

INSERT INTO UserLogin(Id, email)
VALUES(1, 'email@gmail.com'), (2, 'email@gmail.com')

SELECT * FROM UserLogin;
DROP TABLE UserLogin;
