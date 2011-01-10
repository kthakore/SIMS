
CREATE TABLE Student (

		id INTEGER PRIMARY KEY,
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

		id INTEGER PRIMARY KEY,
		user_id INTEGER REFERENCES User,
		name TEXT,
		speedCode TEXT

		); 

CREATE TABLE Plan (

		id  INTEGER PRIMARY KEY, 
		name TEXT

		);

CREATE TABLE Fund (

		id  INTEGER PRIMARY KEY,
		type TEXT,
		value FLOAT,
		start DATE,
		end DATE
		);

CREATE TABLE Term (

		id  INTEGER PRIMARY KEY,
		termDate DATE,
		length FLOAT

		);

CREATE TABLE Event (

		id INTEGER PRIMARY KEY,
		ref_id INT NULL UNIQUE,
		refers_to TEXT, 
		type TEXT,
		timestamp DATETIME NOT NULL,
		description TEXT
	);

--
--  Sample Events
--

INSERT INTO "Event" VALUES ( 0, 1, "Student", "Added", datetime('now'), "Added new student." );

CREATE TABLE TermFunding (

		id INTEGER PRIMARY KEY,
		Termid INT NOT NULL CONSTRAINT fk_tf_term_id
		REFERENCES Term(id)
		ON DELETE CASCADE,
		Fundid INT NOT NULL CONSTRAINT fk_tf_fund_id
		REFERENCES Fund(id)
		ON DELETE CASCADE
		);


CREATE TABLE TermStudent (


		id INTEGER PRIMARY KEY,
		Termid INT NOT NULL CONSTRAINT fk_ts_term_id
		REFERENCES Term(id)
		ON DELETE CASCADE,
		Studentid INT NOT NULL CONSTRAINT fk_ts_student_id
		REFERENCES Student(id)
		ON DELETE CASCADE
		);

CREATE TABLE PlanStudent (


		id INTEGER PRIMARY KEY,
		plan_id INTEGER REFERENCES PLAN,
		student_id INTEGER REFERENCES Student
		);

CREATE TABLE StudentSupervisor (

		id INTEGER PRIMARY KEY,
		Studentid INT NOT NULL CONSTRAINT fk_ps_student_id
		REFERENCES Student(id)
		ON DELETE CASCADE,
		Supervisorid INT NOT NULL CONSTRAINT fk_ps_supervisor_id
		REFERENCES Supervisor(id)
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
		role TEXT,
		name TEXT
		);

CREATE TABLE UserRole (
		user_id INTEGER REFERENCES User,
		role_id INTEGER REFERENCES Role,
		PRIMARY KEY (user_id, role_id)
		);

---
--- Initial Role Data
---

    INSERT INTO User VALUES (1, 'user', 'mypass', 'user@mailinator.com');
    INSERT INTO User VALUES (2, 'gradadmin', 'mypass', 'gradadmin@mailinator.com');
    INSERT INTO User VALUES (3, 'gradexec', 'mypass', 'gradexec@mailinator.com');
    INSERT INTO User VALUES (4, 'student', 'mypass', 'student@mailinator.com');
    INSERT INTO User VALUES (5, 'techadmin', 'mypass', 'techadmin5@mailinator.com');
    INSERT INTO User VALUES (6, 'advcom', 'mypass', 'adv@mailinator.com');
 
    INSERT INTO Role VALUES (0, 'user', 'user');
    INSERT INTO Role VALUES (1, 'g_admin', 'graduateadmin');
    INSERT INTO Role VALUES (2, 'g_exec', 'graduateexec');
    INSERT INTO Role VALUES (3, 'student','student');
    INSERT INTO Role VALUES (4, 't_admin', 'techadmin');
    INSERT INTO Role VALUES (5, 'adv_com', 'advcommmember');

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


