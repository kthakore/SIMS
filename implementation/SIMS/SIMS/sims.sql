
CREATE TABLE Student (

		ID INT NOT NULL UNIQUE PRIMARY KEY,
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

CREATE TABLE user (
		id       INTEGER PRIMARY KEY,
		username TEXT,
		password TEXT
		);

CREATE TABLE role (
		id   INTEGER PRIMARY KEY,
		role TEXT
		);

CREATE TABLE user_role (
		user INTEGER REFERENCES user,
		role INTEGER REFERENCES role,
		PRIMARY KEY (user, role)
		);

