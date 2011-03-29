
CREATE TABLE "DBHealthCheck" (
  "id" serial,
);


--
-- Table: User
--

CREATE TABLE "User" (
  "id" serial,
  "username" text NOT NULL,
  "password" text NOT NULL,
  "email_address" text NOT NULL,
  PRIMARY KEY ("id")
);


--
-- Table: Student
--
CREATE TABLE "Student" (
  "id" serial,
  "user_id" integer,
  "name" text,
  "type" text,
  "address" text,
  "address2" text,
  "city" text,
  "province" text,
  "postalcode" text,
  "phone" text,
  "email" text,
  "location" text,
  PRIMARY KEY ("id")
);

--
-- Table: Supervisor
--
CREATE TABLE "Supervisor" (
  "id" serial,
  "user_id" integer,
  "name" text,
  "speedcode" text,
  PRIMARY KEY ("id")
);

--
-- Table: Plan
--
CREATE TABLE "Plan" (
  "id" serial,
  "name" text,
  PRIMARY KEY ("id")
);

--
-- Table: Fund
--
CREATE TABLE "Fund" (
  "id" serial,
  "type" text,
  "value" numeric,
  "start" date,
  "end" date,
  PRIMARY KEY ("id")
);

--
-- Table: Term
--
CREATE TABLE "Term" (
  "id" serial,
  "termdate" date,
  "length" numeric,
  PRIMARY KEY ("id")
);

--
-- Table: Event
--
CREATE TABLE "Event" (
  "id" serial,
  "ref_id" integer NOT NULL,
  "refers_to" text,
  "type" text,
  "timestamp" timestamp NOT NULL,
  "description" text,
  PRIMARY KEY ("id")
);

--
-- Table: TermFunding
--
CREATE TABLE "TermFunding" (
  "term_id" integer NOT NULL,
  "fund_id" integer NOT NULL,
  PRIMARY KEY ("term_id", "fund_id")
);

--
-- Table: TermStudent
--
CREATE TABLE "TermStudent" (
  "term_id" integer NOT NULL,
  "student_id" integer NOT NULL,
  PRIMARY KEY ("term_id", "student_id")
);

--
-- Table: PlanStudent
--
CREATE TABLE "PlanStudent" (
  "plan_id" integer NOT NULL,
  "student_id" integer NOT NULL,
  PRIMARY KEY ("plan_id", "student_id")
);

--
-- Table: StudentSupervisor
--
CREATE TABLE "StudentSupervisor" (
  "student_id" integer NOT NULL,
  "supervisor_id" integer NOT NULL,
  PRIMARY KEY ("student_id", "supervisor_id")
);

--
-- Table: Role
--
CREATE TABLE "Role" (
  "id" serial,
  "role" text,
  "name" text,
  PRIMARY KEY ("id")
);

--
-- Table: UserRole
--
CREATE TABLE "UserRole" (
  "user_id" integer NOT NULL,
  "role_id" integer NOT NULL,
  PRIMARY KEY ("user_id", "role_id")
);

--
-- Table: Meeting
--
CREATE TABLE "Meeting" (
  "id" serial,
  "student_id" integer,
  "datetime" timestamp,
  "description" text,
  "status" text,
  "progress" text,
  "agreement" text,
  "student_sign" text,
  "locked" integer,
  PRIMARY KEY ("id")
);

--
-- Table: MeetingConfirmation
--
CREATE TABLE "MeetingConfirmation" (
  "id" serial,
  "key" text,
  "status" text,
  "details" text,
  PRIMARY KEY ("id")
);

--
-- Table: MeetingAdvisor
--
CREATE TABLE "MeetingAdvisor" (
  "meeting_id" integer NOT NULL,
  "advisor_id" integer NOT NULL,
  "signature" text,
  "confirmation" integer,
  PRIMARY KEY ("meeting_id", "advisor_id")
);

--
-- Table: MeetingComments
--
CREATE TABLE "MeetingComments" (
  "id" serial,
  "meeting_id" integer,
  "commenter_id" integer,
  "comment" text,
  "type" text,
  PRIMARY KEY ("id")
);

--
-- Table: Report
--
CREATE TABLE "Report" (
  "id" serial,
  "name" text,
  "query" text,
  "datum" text,
  "cols" text,
  PRIMARY KEY ("id")
);

--
-- Foreign Key Definitions
--

ALTER TABLE "Student" ADD FOREIGN KEY ("user_id")
  REFERENCES "User" ("id") DEFERRABLE;

ALTER TABLE "Supervisor" ADD FOREIGN KEY ("user_id")
  REFERENCES "User" ("id") DEFERRABLE;

ALTER TABLE "TermFunding" ADD FOREIGN KEY ("term_id")
  REFERENCES "Term" ("id") DEFERRABLE;

ALTER TABLE "TermFunding" ADD FOREIGN KEY ("fund_id")
  REFERENCES "Fund" ("id") DEFERRABLE;

ALTER TABLE "TermStudent" ADD FOREIGN KEY ("term_id")
  REFERENCES "Term" ("id") DEFERRABLE;

ALTER TABLE "TermStudent" ADD FOREIGN KEY ("student_id")
  REFERENCES "Student" ("id") DEFERRABLE;

ALTER TABLE "PlanStudent" ADD FOREIGN KEY ("plan_id")
  REFERENCES "Plan" ("id") DEFERRABLE;

ALTER TABLE "PlanStudent" ADD FOREIGN KEY ("student_id")
  REFERENCES "Student" ("id") DEFERRABLE;

ALTER TABLE "StudentSupervisor" ADD FOREIGN KEY ("student_id")
  REFERENCES "Student" ("id") DEFERRABLE;

ALTER TABLE "StudentSupervisor" ADD FOREIGN KEY ("supervisor_id")
  REFERENCES "Supervisor" ("id") DEFERRABLE;

ALTER TABLE "UserRole" ADD FOREIGN KEY ("user_id")
  REFERENCES "User" ("id") DEFERRABLE;

ALTER TABLE "UserRole" ADD FOREIGN KEY ("role_id")
  REFERENCES "Role" ("id") DEFERRABLE;

ALTER TABLE "Meeting" ADD FOREIGN KEY ("student_id")
  REFERENCES "Student" ("id") DEFERRABLE;

ALTER TABLE "MeetingAdvisor" ADD FOREIGN KEY ("meeting_id")
  REFERENCES "Meeting" ("id") DEFERRABLE;

ALTER TABLE "MeetingAdvisor" ADD FOREIGN KEY ("advisor_id")
  REFERENCES "User" ("id") DEFERRABLE;

ALTER TABLE "MeetingAdvisor" ADD FOREIGN KEY ("confirmation")
  REFERENCES "MeetingConfirmation" ("id") DEFERRABLE;

ALTER TABLE "MeetingComments" ADD FOREIGN KEY ("meeting_id")
  REFERENCES "Meeting" ("id") DEFERRABLE;

ALTER TABLE "MeetingComments" ADD FOREIGN KEY ("commenter_id")
  REFERENCES "User" ("id") DEFERRABLE;


      INSERT INTO "User" (id, username, password, email_address) VALUES (1, 'user', 'mypass', 'user@mailinator.com');
    INSERT INTO "User"  (id, username, password, email_address) VALUES (2, 'gradadmin', 'mypass', 'gradadmin@mailinator.com');
    INSERT INTO "User" (id, username, password, email_address)  VALUES (3, 'gradexec', 'mypass', 'gradexec@mailinator.com');
    INSERT INTO "User"  (id, username, password, email_address) VALUES (4, 'student', 'mypass', 'student@mailinator.com');
    INSERT INTO "User"  (id, username, password, email_address) VALUES (5, 'techadmin', 'mypass', 'techadmin5@mailinator.com');
    INSERT INTO "User"  (id, username, password, email_address) VALUES (6, 'advcom', 'mypass', 'adv@mailinator.com');

    INSERT INTO "Role" VALUES (0, 'user', 'user');
    INSERT INTO "Role" VALUES (1, 'g_admin', 'graduateadmin');
    INSERT INTO "Role" VALUES (2, 'g_exec', 'graduateexec');
    INSERT INTO "Role" VALUES (3, 'student','student');
    INSERT INTO "Role" VALUES (4, 't_admin', 'techadmin');
    INSERT INTO "Role" VALUES (5, 'adv_com', 'advcommmember');

    INSERT INTO "UserRole" VALUES (1, 0);
    INSERT INTO "UserRole" VALUES (2, 1);
    INSERT INTO "UserRole" VALUES (3, 2);
    INSERT INTO "UserRole" VALUES (4, 3);
    INSERT INTO "UserRole" VALUES (5, 4);
    INSERT INTO "UserRole" VALUES (6, 5);


    INSERT INTO "Student" VALUES (1, '4', 'Kartik Thakore','New Student','123 Numbers blvd','--','London','ON','L2T2W1','123456789','123@email.com','MSC');

