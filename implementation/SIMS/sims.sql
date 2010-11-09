
CREATE TABLE Student (

    ID INT NOT NULL UNIQUE PRIMARY KEY,
    name TEXT,
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

CREATE TABLE Plan(

    ID  INT NOT NULL UNIQUE PRIMARY KEY,
    name TEXT

);

CREATE TABLE TermFunding (

    TermID INT NOT NULL CONSTRAINT fk_tf_term_id
                                          REFERENCES Term(ID)
                                          ON DELETE CASCADE,
    FundID INT NOT NULL CONSTRAINT fk_tf_fund_id
                                          REFERENCES Fund(ID)
                                          ON DELETE CASCADE
);


CREATE TABLE TermStudent (

    TermID INT NOT NULL CONSTRAINT fk_ts_term_id
                                          REFERENCES Term(ID)
                                          ON DELETE CASCADE,
    StudentID INT NOT NULL CONSTRAINT fk_ts_student_id
                                          REFERENCES Student(ID)
                                          ON DELETE CASCADE
);

CREATE TABLE PlanStudent (

    PlanID INT NOT NULL CONSTRAINT fk_ps_plan_id
                                          REFERENCES PLAN(ID)
                                          ON DELETE CASCADE,
    StudentID INT NOT NULL CONSTRAINT fk_ps_student_id
                                          REFERENCES Student(ID)
                                          ON DELETE CASCADE
);

CREATE TABLE StudentSupervisor (

    StudentID INT NOT NULL CONSTRAINT fk_ps_student_id
                                          REFERENCES Student(ID)
                                          ON DELETE CASCADE,
    SupervisorID INT NOT NULL CONSTRAINT fk_ps_supervisor_id
                                          REFERENCES Supervisor(ID)
                                          ON DELETE CASCADE

);
