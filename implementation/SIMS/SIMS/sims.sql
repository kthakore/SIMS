
CREATE TABLE Student (

		ID INT NOT NULL UNIQUE PRIMARY KEY,
		user_id INTEGER REFERENCES User,
		name TEXT,
		type TEXT,
		address TEXT,
		address2 TEXT,
		city	TEXT,
		province TEXT,
		postalcode TEXT,
		phone	 TEXT,
		email	 TEXT,
		location TEXT

		);


CREATE TABLE Supervisor (

		ID INT NOT NULL UNIQUE PRIMARY KEY,
		user_id INTEGER REFERENCES User,
		name TEXT,
		speedCode TEXT

		); 

CREATE TABLE Plan (

		ID  INT NOT NULL UNIQUE PRIMARY KEY, 
		name TEXT

		);

CREATE TABLE Fund (

		ID  INT NOT NULL UNIQUE PRIMARY KEY,
		type TEXT,
		value FLOAT,
		start DATE,
		end DATE
		);

CREATE TABLE Term (

		ID  INT NOT NULL UNIQUE PRIMARY KEY,
		termDate DATE,
		length FLOAT

		);

CREATE TABLE TermFunding (

		ID INT NOT NULL UNIQUE PRIMARY KEY,
		TermID INT NOT NULL CONSTRAINT fk_tf_term_id
		REFERENCES Term(ID)
		ON DELETE CASCADE,
		FundID INT NOT NULL CONSTRAINT fk_tf_fund_id
		REFERENCES Fund(ID)
		ON DELETE CASCADE
		);


CREATE TABLE TermStudent (


		ID INT NOT NULL UNIQUE PRIMARY KEY,
		TermID INT NOT NULL CONSTRAINT fk_ts_term_id
		REFERENCES Term(ID)
		ON DELETE CASCADE,
		StudentID INT NOT NULL CONSTRAINT fk_ts_student_id
		REFERENCES Student(ID)
		ON DELETE CASCADE
		);

CREATE TABLE PlanStudent (


		ID INT NOT NULL UNIQUE PRIMARY KEY,
		PlanID INT NOT NULL CONSTRAINT fk_ps_plan_id
		REFERENCES PLAN(ID)
		ON DELETE CASCADE,
		StudentID INT NOT NULL CONSTRAINT fk_ps_student_id
		REFERENCES Student(ID)
		ON DELETE CASCADE
		);

CREATE TABLE StudentSupervisor (

		ID INT NOT NULL UNIQUE PRIMARY KEY,
		StudentID INT NOT NULL CONSTRAINT fk_ps_student_id
		REFERENCES Student(ID)
		ON DELETE CASCADE,
		SupervisorID INT NOT NULL CONSTRAINT fk_ps_supervisor_id
		REFERENCES Supervisor(ID)
		ON DELETE CASCADE

		);

CREATE TABLE User (
        id       INTEGER PRIMARY KEY,
        username TEXT NOT NULL UNIQUE,
        password  TEXT NOT NULL,
        email_address TEXT NOT NULL UNIQUE 
        );

CREATE TABLE Role (
		id   INTEGER PRIMARY KEY,
		role TEXT
		);

CREATE TABLE UserRole (
		user_id INTEGER REFERENCES User,
		role_id INTEGER REFERENCES Role,
		PRIMARY KEY (user_id, role_id)
		);

---
--- Initial Role Data
---

    INSERT INTO User VALUES (1, 'test01', 'mypass', 't01@na.com');
    INSERT INTO User VALUES (2, 'test02', 'mypass', 't02@na.com');
    INSERT INTO User VALUES (3, 'test03', 'mypass', 't03@na.com');
    INSERT INTO User VALUES (4, 'test04', 'mypass', 't04@na.com');
    INSERT INTO User VALUES (5, 'test05', 'mypass', 't05@na.com');
    INSERT INTO User VALUES (6, 'test06', 'mypass', 't06@na.com');
 
    INSERT INTO Role VALUES (0, 'user');
    INSERT INTO Role VALUES (1, 'g_admin');
    INSERT INTO Role VALUES (2, 'g_exec');
    INSERT INTO Role VALUES (3, 'student');
    INSERT INTO Role VALUES (4, 't_admin');
    INSERT INTO Role VALUES (5, 'adv_com');

    INSERT INTO UserRole VALUES (1, 0);
    INSERT INTO UserRole VALUES (2, 1);
    INSERT INTO UserRole VALUES (3, 2);
    INSERT INTO UserRole VALUES (4, 3);
    INSERT INTO UserRole VALUES (5, 4);
    INSERT INTO UserRole VALUES (6, 5);

---
--- Initial Student Data
---

	INSERT INTO "Student" VALUES ("1", "4", "Kartik Thakore","New Student","123 Numbers blvd","--","London","ON","L2T2W1","123456789","123@email.com","MSC");


