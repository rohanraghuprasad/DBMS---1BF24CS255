create database Bank_Enterprise;
create table Branch(branchname varchar(30), branchcity varchar(30), assets real, primary key(branchname));
create table BankAccount(accno integer, branchname varchar(30), balance real, primary key(accno), foreign key(branchname) references Branch(branchname));
create table BankCustomer(customername varchar(30), customerstreet varchar(30), customercity varchar(30), primary key(customername));
create table Depositer(customername varchar(30), accno integer, primary key(customername, accno), foreign key(customername) references BankCustomer(customername), foreign key(accno) references BankAccount(accno));
create table Loan(loannumber int, branchname varchar(30), amount real, primary key(loannumber), foreign key(branchname) references Branch(branchname));
create table Borrower(customername varchar(30), loannumber int, foreign key(customername) references BankCustomer(customername), foreign key(loannumber) references Loan(loannumber));
desc Branch;
desc BankAccount;
desc BankCustomer;
desc Depositer;
desc Loan;
desc Borrower;
insert into Branch values('SBI_Chamrajpet', 'Bangalore', 50000);
insert into Branch values('SBI_ResidencyRoad', 'Bangalore', 10000);
insert into Branch values('SBI_ShivajiRoad', 'Bombay', 20000);
insert into Branch values('SBI_ParliamentRoad', 'Delhi', 10000);
insert into Branch values('SBI_Jantarmantar', 'Delhi', 20000);
insert into Branch values('SBI_MantriMarg', 'Delhi', 200000);
select * from Branch;
insert into Loan values(1, 'SBI_Chamrajpet', 1000);
insert into Loan values(2, 'SBI_ResidencyRoad', 2000);
insert into Loan values(3, 'SBI_ShivajiRoad', 3000);
insert into Loan values(4, 'SBI_ParliamentRoad', 4000);
insert into Loan values(5, 'SBI_Jantarmantar', 5000);
select * from Loan;
insert into BankAccount values(1, 'SBI_Chamrajpet', 2000);
insert into BankAccount values(2, 'SBI_ResidencyRoad', 5000);
insert into BankAccount values(3, 'SBI_ShivajiRoad', 6000);
insert into BankAccount values(4, 'SBI_ParliamentRoad', 9000);
insert into BankAccount values(5, 'SBI_Jantarmantar', 8000);
insert into BankAccount values(6, 'SBI_ShivajiRoad', 4000);
insert into BankAccount values(8, 'SBI_ResidencyRoad', 4000);
insert into BankAccount values(9, 'SBI_ParliamentRoad', 3000);
insert into BankAccount values(10, 'SBI_ResidencyRoad', 5000);
insert into BankAccount values(11, 'SBI_Jantarmantar', 2000);
insert into BankAccount values(12, 'SBI_MantriMarg', 2000);
select * from BankAccount;
insert into BankCustomer values('Avinash', 'Bull_Temple_Road', 'Bangalore');
insert into BankCustomer values('Dinesh', 'Bannerghata_Road', 'Bangalore');
insert into BankCustomer values('Mohan', 'NationalCollege_Road', 'Bangalore');
insert into BankCustomer values('Nikil', 'Akbar_Road', 'Delhi');
insert into BankCustomer values('Ravi', 'Prithviraj_Road', 'Delhi');
commit;
select * from BankCustomer;
insert into Depositer values('Avinash', 1);
insert into Depositer values('Dinesh', 2);
insert into Depositer values('Nikil', 4);
insert into Depositer values('Ravi', 5);
insert into Depositer values('Avinash', 8);
insert into Depositer values('Nikil', 9);
insert into Depositer values('Dinesh', 10);
insert into Depositer values('Nikil', 11);
insert into Depositer values('Nikil', 12);
select * from Depositer;
insert into Borrower values('Avinash', 1);
insert into Borrower values('Dinesh', 2);
insert into Borrower values('Mohan', 3);
insert into Borrower values('Nikil', 4);
insert into Borrower values('Ravi', 5);
select * from Borrower;
select C.customername from BankCustomer C where exists (select D.customername, count(D.customername) from depositer D, BankAccount BA where D.accno = BA.accno AND C.customername = D.customername AND BA.branchname = 'SBI_ResidencyRoad' group by D. customername having count(D.customername)>=2);
SELECT BC.customername
FROM BankCustomer BC
WHERE NOT EXISTS (
    SELECT branchname
    FROM Branch B
    WHERE B.branchcity = 'Delhi'
    AND NOT EXISTS (
        SELECT 1
        FROM depositer D
        JOIN BankAccount BA ON D.accno = BA.accno
        WHERE D.customername = BC.customername
          AND BA.branchname = B.branchname
    )
);



 delete from BankAccount where branchname IN(select branchname from Branch where branchcity='Bombay');
 select * from BankAccount;
 select * from loan order by amount desc;
select D.customername
from Depositer D, BankAccount BA, Branch B where
D.accno=BA.accno and BA.branchname=B.branchname and B.branchcity='Delhi' group by D.customername having count(
distinct(B.branchname))=(select count(branchname) from Branch where branchcity='Delhi');
select distinct customername from Borrower where customername not in(select customername from Depositer);
select branchname from Branch where assets>all(select assets from branch where branchcity='Bangalore');
select customername from Borrower, Loan where Borrower.loannumber=Loan.loannumber and Loan.branchname in(select branchname from Depositer, BankAccount where Depositer.accno=BankAccount.branchname in(select branchname from Branch where Branch.branchcity='Bangalore'));
delete from BankAccount where branchname in (select branchname from Branch where branchcity='Bombay');
update BankAccount set balance=balance+(balance*0.05);
select * from BankAccount;
 