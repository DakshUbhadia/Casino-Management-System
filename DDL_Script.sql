CREATE TABLE IF NOT EXISTS Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(30) NOT NULL,
    Registration_Date DATE NOT NULL,
    Aadhar_No BIGINT UNIQUE NOT NULL CHECK (LENGTH(Aadhar_No::VARCHAR) = 12),
    Loyalty_Point INT DEFAULT 0 CHECK (Loyalty_Point >= 0),
    Wallet_Balance NUMERIC(10,2) DEFAULT 0.00 CHECK (Wallet_Balance >= 0),
    Phone_No VARCHAR(15) NOT NULL,
    Email_ID VARCHAR(50) NOT NULL,
    Address VARCHAR(100) NOT NULL
);


CREATE TABLE IF NOT EXISTS Employee (
    Employee_ID INT PRIMARY KEY,
    Employee_Type VARCHAR(50) NOT NULL CHECK (
        Employee_Type IN (
            'Dealer', 'Support Staff', 'Security', 'Software Engineers', 'DevOps Engineers',
            'Accountants / Finance Officers', 'Legal Advisors', 'Product Managers', 'Digital Marketing Specialists'
        )
    ),
    Name VARCHAR(50) NOT NULL,
    Salary NUMERIC(10,2) NOT NULL CHECK (Salary > 0),
    Shift_Start TIME,
    Shift_End TIME,
    Gender VARCHAR(10) NOT NULL CHECK (Gender IN ('Male', 'Female', 'Other')),
    DOB DATE NOT NULL,
    Address VARCHAR(100) NOT NULL
);


CREATE TABLE IF NOT EXISTS Games (
    Game_ID INT PRIMARY KEY,
    Game_Name VARCHAR(20) NOT NULL,
    Max_Players INT NOT NULL CHECK (Max_Players > 0),
    Min_Players INT NOT NULL DEFAULT 1 CHECK (Min_Players > 0),
    Payout_Rate NUMERIC(5,2) NOT NULL CHECK (Payout_Rate BETWEEN 0 AND 100)
);


CREATE TABLE IF NOT EXISTS Game_Type (
    Game_Type VARCHAR(20) NOT NULL CHECK (
        Game_Type IN (
            'Card Games', 'Table & Dice Games', 'Number Games',
            'Slot Games', 'Roulette', 'Baccarat', 'Board Games'
        )
    ),
    Game_ID INT NOT NULL,
    PRIMARY KEY (Game_Type, Game_ID),
    FOREIGN KEY (Game_ID) REFERENCES Games(Game_ID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Transactions (
    Transaction_ID INT PRIMARY KEY,
    Transaction_Type VARCHAR(20) NOT NULL CHECK (
        Transaction_Type IN (
            'Credit/Debit Cards', 'E-Wallets', 'Bank Transfers',
            'Cryptocurrencies', 'Mobile Payments'
        )
    ),
    Amount NUMERIC(10,2) NOT NULL CHECK (Amount > 0),
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Customer_ID INT NOT NULL,
    Deposit_Withdrawal VARCHAR(20) NOT NULL CHECK (Deposit_Withdrawal IN ('Deposit', 'Withdrawal')),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Participation_Table (
    Table_ID VARCHAR(3) NOT NULL CHECK (
        Table_ID IN (
            'T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12','T13','T14','T15',
            'T16','T17','T18','T19','T20','T21','T22','T23','T24','T25','T26','T27','T28','T29','T30',
            'T31','T32','T33','T34','T35','T36','T37','T38','T39','T40','T41','T42','T43','T44','T45',
            'T46','T47','T48','T49','T50'
        )
    ),
    Participant_ID INT NOT NULL,
    Bet_Amount NUMERIC(10,2) NOT NULL CHECK (Bet_Amount > 0),
    Start_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Customer_ID INT NOT NULL,
    Game_ID INT NOT NULL,
    Employee_ID INT NOT NULL,
    PRIMARY KEY (Table_ID, Participant_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE,
    FOREIGN KEY (Game_ID) REFERENCES Games(Game_ID) ON DELETE CASCADE,
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Game_Outcome_R1 (
    Table_ID VARCHAR(3) NOT NULL,
    Participant_ID INT NOT NULL,
    Amount INT NOT NULL,
    PRIMARY KEY (Table_ID, Participant_ID),
    FOREIGN KEY (Table_ID, Participant_ID) REFERENCES Participation_Table(Table_ID, Participant_ID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Game_Outcome_R2 (
    Transaction_ID INT PRIMARY KEY,
    Amount NUMERIC(10,2) NOT NULL CHECK (Amount > 0),
    FOREIGN KEY (Transaction_ID) REFERENCES Transactions(Transaction_ID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Customer_Support (
    Complain_ID INT PRIMARY KEY,
    Issue_Description TEXT NOT NULL,
    Status BOOLEAN DEFAULT FALSE,
    Employee_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID) ON DELETE CASCADE,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Issue (
    Complain_ID INT PRIMARY KEY,
    Issue_Type VARCHAR(20) NOT NULL CHECK (
        Issue_Type IN ('Payment', 'Game', 'Account', 'Cyberbullying', 'Other')
    ),
    FOREIGN KEY (Complain_ID) REFERENCES Customer_Support(Complain_ID) ON DELETE CASCADE
);
