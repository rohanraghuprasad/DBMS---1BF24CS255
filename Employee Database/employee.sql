create Database Employee;
use Employee;
create table dept(deptno decimal(2,0) primary key, dname varchar(14) default NULL, loc varchar(13) default NULL);
desc dept;
create table emp(empno decimal(4,0) primary key, ename varchar(10) default NULL, mgr_no decimal(4,0) default NULL, hiredate date default NULL, sal decimal(7,2) default NULL, deptno decimal(2,0) references dept(deptno) on delete cascade on update cascade);
desc emp;
create table incentives (empno decimal(4,0) references emp(empno) on delete cascade on update cascade, incentive_date date, incentive_amount decimal(10,2), primary key(empno,incentive_date));
desc incentives;
drop table incentives;
create table project (pno int primary key, pname varchar(30) not null, ploc varchar(30));
desc project;
create table assigned_to (empno decimal(4,0) references emp(empno) on delete cascade on update cascade, pno int references project(pno) on delete cascade on update cascade, job_role varchar(30), primary key(empno,pno));
desc assigned_to;
insert into dept values(10, 'Accounting', 'Mumbai');
insert into dept values(20, 'Researching', 'Bengaluru');
insert into dept values(30, 'Sales', 'Delhi');
insert into dept values(40, 'Operations', 'Chennai');
select * from dept;
insert into emp values(7369, 'Adarsh', 7902, '2012-12-17', '80000.00', '20');
insert into emp values(7499, 'Shruthi', 7698, '2013-02-20', '16000.00', '30');
insert into emp values(7521, 'Anvitha', 7698, '2015-02-22', '12500.00', '30');
insert into emp values(7566, 'Tanvir', 7839, '2008-04-02', '29750.00', '20');
insert into emp values(7654, 'Ramesh', 7698, '2014-09-28', '12500.00', '30');
insert into emp values(7698, 'Kumar', 7839, '2015-05-01', '28500.00', '30');
insert into emp values(7782, 'Clark', 7839, '2017-06-09', '24500.00', '10');
insert into emp values(7788, 'Scott', 7566, '2010-12-09', '30000.00', '20');
insert into emp values(7839, 'King', NULL, '2009-11-17', 50000.00, 10);
insert into emp values(7844, 'Turner', 7698, '2010-09-08', '15000.00', '30');
insert into emp values(7876, 'Adams', 7788, '2013-01-12', '11000.00', '20');
insert into emp values(7900, 'James', 7698, '2017-12-03', '9500.00', '30');
insert into emp values(7902, 'Ford', 7566, '2010-12-03', '30000.00', '20');
select * from emp;

insert into incentives values(7499,'2019-02-01',5000.00);
insert into incentives values(7521,'2019-03-01',2500.00);
insert into incentives values(7566,'2022-02-01',5070.00);
insert into incentives values(7654,'2020-02-01',2000.00);
insert into incentives values(7654,'2022-04-01',879.00);
insert into incentives values(7521,'2019-02-01',8000.00);
insert into incentives values(7698,'2019-03-01',500.00);
insert into incentives values(7698,'2020-03-01',9000.00);
insert into incentives values(7698,'2022-04-01',4500.00);
select * from incentives; 
truncate table incentives;
insert into project values(101,'AI Project','BENGALURU');
insert into project values(102,'IOT','HYDERABAD');
insert into project values(103,'BLOCKCHAIN','BENGALURU');
insert into project values(104,'DATA SCIENCE','MYSURU');
insert into project values(105,'AUTONOMUS SYSTEMS','PUNE');
select * from project;
insert into assigned_to values(7499,101,'Software Engineer');
insert into assigned_to values(7521,101,'Software Architect');
insert into assigned_to values(7566,101,'Project Manager');
insert into assigned_to values(7654,102,'Sales');
insert into assigned_to values(7521,102,'Software Engineer');
insert into assigned_to values(7499,102,'Software Engineer');
insert into assigned_to values(7654,103,'Cyber Security');
insert into assigned_to values(7698,104,'Software Engineer');
insert into assigned_to values(7900,105,'Software Engineer');
insert into assigned_to values(7839,104,'General Manager');
select * from assigned_to;

select empno from emp where empno not in(select empno from incentives);

SELECT m.ename, count(*)
FROM emp e,emp m
WHERE e.mgr_no = m.empno
GROUP BY m.ename
HAVING count(*) =(SELECT MAX(mycount)
 from (SELECT COUNT(*) mycount
 FROM emp
 GROUP BY mgr_no) a);
 
 SELECT *
FROM emp m
WHERE m.empno IN
 (SELECT mgr_no
 FROM emp)
 AND m.sal >
 (SELECT avg(e.sal)
 FROM emp e
 WHERE e.mgr_no = m.empno ); 
 
 SELECT *
 FROM EMP E
 WHERE E.DEPTNO = (SELECT E1.DEPTNO
FROM EMP E1
 WHERE E1.EMPNO=E.MGR_NO);

 select * from emp e, incentives i
where e.empno=i.empno and 2 = ( select count(distinct j.incentive_amount) from incentives j
where i.incentive_amount <= j.incentive_amount );

select e.empno
 from emp e, assigned_to a, project p
 where e.empno=a.empno and a.pno=p.pno and
 p.ploc in ('BENGALURU','HYDERABAD','MYSURU');

SELECT distinct e.ename from emp e,incentives i
WHERE (SELECT max(sal+incentive_amount)
 FROM emp,incentives) >= ANY
 (SELECT sal
 FROM emp e1
 where e.deptno=e1.deptno);
