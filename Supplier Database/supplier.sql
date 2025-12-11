CREATE TABLE SUPPLIERS (sid INT(5) PRIMARY KEY, sname VARCHAR(20), city VARCHAR(20));
DESC SUPPLIERS;
CREATE TABLE PARTS (pid INT(5) PRIMARY KEY, pname VARCHAR(20), color VARCHAR(10));
DESC PARTS;
CREATE TABLE CATALOG (sid INT(5), pid INT(5), cost FLOAT(6), FOREIGN KEY (sid) REFERENCES SUPPLIERS(sid), FOREIGN KEY (pid) REFERENCES PARTS(pid), PRIMARY KEY (sid, pid));
DESC CATALOG;

INSERT INTO SUPPLIERS VALUES (10001, 'Acme Widget', 'Bangalore');
INSERT INTO SUPPLIERS VALUES (10002, 'Johns', 'Kolkata');
INSERT INTO SUPPLIERS VALUES (10003, 'Vimal', 'Mumbai');
INSERT INTO SUPPLIERS VALUES (10004, 'Reliance', 'Delhi');
INSERT INTO SUPPLIERS VALUES (10005, 'Mahindra', 'Mumbai');
select * from SUPPLIERS;

insert into PARTS values(20001, 'Book', 'Red');
insert into PARTS values(20002, 'Pen', 'Red');
insert into PARTS values(20003, 'Pencil', 'Green');
insert into PARTS values(20004, 'Mobile', 'Green');
insert into PARTS values(20005, 'Charger', 'Black');
select * from PARTS;

insert into CATALOG values(10001, 20001, 10);
insert into CATALOG values(10001, 20002, 10);
insert into CATALOG values(10001, 20003, 30);
insert into CATALOG values(10001, 20004, 10);
insert into CATALOG values(10001, 20005, 10);

insert into CATALOG values(10002, 20001, 10);
insert into CATALOG values(10002, 20002, 20);
insert into CATALOG values(10003, 20003, 30);
insert into CATALOG values(10004, 20003, 40);
select * from CATALOG;

SELECT DISTINCT P.pname
FROM Parts P, Catalog C
WHERE P.pid = C.pid;


SELECT S.sname
FROM Suppliers S
WHERE
(( SELECT count(P.pid)
FROM Parts P ) =
( SELECT count(C.pid)
FROM Catalog C
WHERE C.sid = S.sid ));

SELECT S.sname
FROM Suppliers S
WHERE
(( SELECT count(P.pid)
FROM Parts P where color='Red') =
( SELECT count(C.pid)
FROM Catalog C, Parts P
WHERE C.sid = S.sid AND
C.pid = P.pid AND P.color = 'Red' ));

SELECT P.pname
FROM Parts P, Catalog C, Suppliers S
WHERE P.pid = C.pid AND C.sid = S.sid
AND S.sname = 'Acme Widget'
AND NOT EXISTS ( SELECT *
FROM Catalog C1, Suppliers S1
WHERE P.pid = C1.pid AND C1.sid = S1.sid AND
S1.sname <> 'Acme Widget');

SELECT DISTINCT C.sid
FROM Catalog C
WHERE C.cost > (
    SELECT AVG(C1.cost)
    FROM Catalog C1
    WHERE C1.pid = C.pid
);

SELECT P.pid, S.sname
FROM Parts P, Suppliers S, Catalog C
WHERE C.pid = P.pid
AND C.sid = S.sid
AND C.cost = (SELECT max(C1.cost)
FROM Catalog C1
WHERE C1.pid = P.pid);

SELECT P.pid, P.pname, S.sname, C.cost
FROM Parts P, CATALOG C, SUPPLIERS S
where P.pid = C.pid
and S.sid = C.sid
and C.cost = (SELECT MAX(cost) FROM Catalog); 


SELECT S.sname
FROM Suppliers S
WHERE NOT EXISTS (
    SELECT 1
    FROM Catalog C, PARTS P
    where C.pid = P.pid
    and C.sid = S.sid AND P.color = 'Red');

SELECT S.sid, S.sname, SUM(C.cost) AS total_value
FROM Suppliers S, CATALOG C
where S.sid = C.sid
GROUP BY S.sid, S.sname;

SELECT S.sname
FROM Suppliers S, CATALOG C
where S.sid = C.sid
and C.cost < 20
GROUP BY S.sid, S.sname
HAVING COUNT(*) >= 2;

SELECT P.pid, P.pname, S.sname, C.cost
FROM Parts P, CATALOG C, SUPPLIERS S
where P.pid = C.pid
and S.sid = C.sid
and C.cost = (
    SELECT MIN(C1.cost)
    FROM Catalog C1
    WHERE C1.pid = P.pid
);

CREATE VIEW view1 AS
SELECT S.sid, S.sname, COUNT(C.pid) AS total_parts
FROM Suppliers S, CATALOG C
where S.sid = C.sid
GROUP BY S.sid, S.sname;
select * from view1;                                

CREATE VIEW view2 AS
SELECT P.pid, P.pname, S.sname, C.cost
FROM Parts P, CATALOG C, SUPPLIERS S
where P.pid = C.pid
and S.sid = C.sid
and C.cost = (
SELECT MAX(C1.cost)
    FROM Catalog C1
    WHERE C1.pid = P.pid);
select * from view2;

DELIMITER $$
CREATE TRIGGER t1
BEFORE INSERT ON CATALOG
FOR EACH ROW
BEGIN
    IF NEW.cost < 1 THEN
        SET NEW.cost = 1;
    END IF;
END;
DELIMITER;

DELIMITER $$
CREATE TRIGGER t2
BEFORE INSERT ON CATALOG
FOR EACH ROW
BEGIN
    IF NEW.cost is NULL THEN
        SET NEW.cost = default(cost);
    END IF;
END;
DELIMITER;
drop trigger t2;
