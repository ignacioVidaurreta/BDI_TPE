CREATE TABLE UserTP (
        Id INT,
        Reputation INT,
        CreationDate TIMESTAMP NOT NULL,
        DisplayName TEXT NOT NULL,
        LastAccessDate TIMESTAMP NOT NULL,
        WebsiteURL TEXT,
        UserLocation TEXT,
        AboutMe TEXT,
        Views INT DEFAULT 0,
        UpVotes INT DEFAULT 0,
        DownVotes INT DEFAULT 0,
        AccountID INT,
        PRIMARY KEY(Id)
);

CREATE TABLE Badges (
        Id INT,
        UserId INT NOT NULL,
        BadgeName TEXT NOT NULL,
        BadgeDate TIMESTAMP NOT NULL,
        BadgeClass INT NOT NULL,
        TagBased BOOLEAN NOT NULL,
        PRIMARY KEY(Id),
        FOREIGN KEY(UserId) REFERENCES UserTP ON DELETE CASCADE
);