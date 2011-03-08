
CREATE TABLE User (
        id       INTEGER PRIMARY KEY,
        username TEXT NOT NULL UNIQUE,
        password  TEXT NOT NULL,
        email_address TEXT NOT NULL UNIQUE 
        );

CREATE TABLE Student (

		id INTEGER PRIMARY KEY,
		user_id INTEGER REFERENCES User(id),
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
		user_id INTEGER REFERENCES User(id),
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
		ref_id INT NOT NULL UNIQUE,
		refers_to TEXT, 
		type TEXT,
		timestamp DATETIME NOT NULL,
		description TEXT
	);

CREATE TABLE TermFunding (
		term_id INTEGER REFERENCES Term(id),
		fund_id INTEGER REFERENCES Fund(id),
		PRIMARY KEY(term_id, fund_id)
		);


CREATE TABLE TermStudent (
		term_id INTEGER REFERENCES Term(id),
		student_id INTEGER REFERENCES Student(id),
		PRIMARY KEY(term_id, student_id)
		);

CREATE TABLE PlanStudent (
		plan_id INTEGER REFERENCES Plan(id),
		student_id INTEGER REFERENCES Student(id),
		PRIMARY KEY( plan_id, student_id)
	
		);

CREATE TABLE StudentSupervisor (

		student_id INTEGER REFERENCES Student(id),
		supervisor_id INTEGER REFERENCES Supervisor(id),
		PRIMARY KEY( student_id, supervisor_id)
		);

CREATE TABLE Role (
		id   INTEGER PRIMARY KEY,
		role TEXT,
		name TEXT
		);

CREATE TABLE UserRole (
		user_id INTEGER REFERENCES User(id),
		role_id INTEGER REFERENCES Role(id),
		PRIMARY KEY (user_id, role_id)
		);

CREATE TABLE Meeting (
		id INTEGER PRIMARY KEY,
		student_id INTEGER REFERENCES Student(id),
		datetime DATETIME,
		description TEXT,
		status TEXT,
		progress TEXT,
		agreement TEXT,
		student_sign TEXT,
		locked INTEGER 
	);

CREATE TABLE MeetingConfirmation (
		id INTEGER PRIMARY KEY,
		key TEXT,
		status TEXT,
		details TEXT
	);

CREATE TABLE MeetingAdvisor (
		meeting_id INTEGER REFERENCES Meeting(id),
		advisor_id INTEGER REFERENCES User(id),
		signature TEXT,
		confirmation INTEGER REFERENCES MeetingConfirmation(id),
		PRIMARY KEY( meeting_id, advisor_id)
	);

CREATE TABLE MeetingComments (
		id INTEGER PRIMARY KEY,
		meeting_id INTEGER REFERENCES Meeting(id),
		commenter_id INTEGER REFERENCES User(id),
		comment TEXT,
		type TEXT
	);

CREATE TABLE Report (
		id INTEGER PRIMARY KEY,
		name TEXT,
		query TEXT,
		datum TEXT,
		cols TEXT
	);

