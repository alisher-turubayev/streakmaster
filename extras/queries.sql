-- Set foreign keys to ON
PRAGMA foreign_keys = ON;

-- Remove existing tables if it exists
DROP TABLE IF EXISTS demo;
DROP TABLE IF EXISTS streak;
DROP TABLE IF EXISTS goals;
DROP TABLE IF EXISTS dailycheckins;
DROP TABLE IF EXISTS daily_check_ins;
DROP TABLE IF EXISTS milestones;

-- Verify syntax is correct
CREATE TABLE streak (
    days INT NOT NULL DEFAULT 0,
    last_timestamp INT
);

INSERT INTO streak VALUES (0, NULL);

CREATE TABLE goals (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    icon_data_code_point INT,
    timestamp_created INT NOT NULL,
    timestamp_achieved INT
);

CREATE TABLE daily_check_ins (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    last_timestamp INT,
    goal_id INT NOT NULL,
    FOREIGN KEY(goal_id) REFERENCES goals(id)
);

CREATE TABLE milestones (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    icon_data_code_point INT,
    timestamp_achieved INT,
    goal_id INT NOT NULL,
    FOREIGN KEY(goal_id) REFERENCES goals(id)
);

-- Insert test data
INSERT INTO goals (title, timestamp_created) VALUES ('Goal 1', 1739976773887);
INSERT INTO goals (title, description, timestamp_created) VALUES ('Goal 2', 'This is my goal 2 that I want to achieve', 1739979773887);
INSERT INTO daily_check_ins (name, goal_id) VALUES ('Do a thing', 1);
INSERT INTO daily_check_ins (name, description, goal_id) VALUES ('Do another thing', 'Very important to do daily', 2);
INSERT INTO milestones (name, goal_id) VALUES ('Achieve this', 1);
INSERT INTO milestones (name, timestamp_achieved, goal_id) VALUES ('Achieve that', 1739979773887, 1);

-- See if everything works
SELECT * FROM streak;
SELECT * FROM goals;
SELECT * FROM daily_check_ins;
SELECT * FROM milestones;
