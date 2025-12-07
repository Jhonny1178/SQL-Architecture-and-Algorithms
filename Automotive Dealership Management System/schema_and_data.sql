
DROP TABLE IF EXISTS Sprzedaz;
DROP TABLE IF EXISTS Samochod_Wyposazenie;
DROP TABLE IF EXISTS Samochod;
DROP TABLE IF EXISTS Model_Silnik;
DROP TABLE IF EXISTS Model_Dealer;
DROP TABLE IF EXISTS Model;
DROP TABLE IF EXISTS Silnik;
DROP TABLE IF EXISTS Marka;
DROP TABLE IF EXISTS Klient;
DROP TABLE IF EXISTS Dealer;
DROP TABLE IF EXISTS Wyposazenie;


CREATE TABLE Marka (
    nazwa VARCHAR(100) PRIMARY KEY,
    rok_zalozenia INT NOT NULL
);

CREATE TABLE Model (
    id_modelu INT PRIMARY KEY,
    nazwa VARCHAR(100) NOT NULL,
    rok_wprowadzenia INT NOT NULL,
    marka_nazwa VARCHAR(100) NOT NULL,
    poprzednik_id_modelu INT,
    CONSTRAINT model_marka_fk FOREIGN KEY (marka_nazwa) REFERENCES Marka(nazwa),
    CONSTRAINT model_poprzednik_fk FOREIGN KEY (poprzednik_id_modelu) REFERENCES Model(id_modelu)
);

CREATE TABLE Silnik (
    id_silnika INT PRIMARY KEY,
    rodzaj_paliwa VARCHAR(20) NOT NULL,
    parametry TEXT
);

CREATE TABLE Samochod (
    VIN VARCHAR(100) PRIMARY KEY,
    przebieg INT NOT NULL,
    rok_produkcji INT NOT NULL,
    skrzynia_biegow VARCHAR(20) NOT NULL, 
    kraj_pochodzenia VARCHAR(50) NOT NULL, 
    model_id_modelu INT NOT NULL,
    silnik_id_silnika INT NOT NULL,  
    CONSTRAINT samochod_model_fk FOREIGN KEY (model_id_modelu) REFERENCES Model(id_modelu),
    CONSTRAINT samochod_silnik_fk FOREIGN KEY (silnik_id_silnika) REFERENCES Silnik(id_silnika) 
);

CREATE TABLE Wyposazenie (
    nazwa VARCHAR(50) PRIMARY KEY
);

CREATE TABLE Dealer (
    nazwa VARCHAR(100) PRIMARY KEY,
    adres VARCHAR(100) NOT NULL
);

CREATE TABLE Klient (
    id_klienta INT PRIMARY KEY,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    numer_telefonu VARCHAR(20) 
);

CREATE TABLE Sprzedaz (
    id_sprzedazy INT PRIMARY KEY IDENTITY(1,1),
    data DATE NOT NULL,
    cena MONEY NOT NULL,
    dealer_nazwa VARCHAR(100) NOT NULL,
    samochod_VIN VARCHAR(100) NOT NULL,
    klient_id_klienta INT NOT NULL,
    CONSTRAINT sprzedaz_dealer_fk FOREIGN KEY (dealer_nazwa) REFERENCES Dealer(nazwa),
    CONSTRAINT sprzedaz_samochod_fk FOREIGN KEY (samochod_VIN) REFERENCES Samochod(VIN),
    CONSTRAINT sprzedaz_klient_fk FOREIGN KEY (klient_id_klienta) REFERENCES Klient(id_klienta)
);

CREATE TABLE Samochod_Wyposazenie (
    samochod_VIN VARCHAR(100),
    wyposazenie_nazwa VARCHAR(50),
    CONSTRAINT samochod_wyposazenie_pk PRIMARY KEY (samochod_VIN, wyposazenie_nazwa),
    CONSTRAINT samochod_wyposazenie_samochod_fk FOREIGN KEY (samochod_VIN) REFERENCES Samochod(VIN),
    CONSTRAINT samochod_wyposazenie_wyposazenie_fk FOREIGN KEY (wyposazenie_nazwa) REFERENCES Wyposazenie(nazwa)
);

CREATE TABLE Model_Silnik (
    model_id_modelu INT,
    silnik_id_silnika INT,
    CONSTRAINT model_silnik_pk PRIMARY KEY (model_id_modelu, silnik_id_silnika),
    CONSTRAINT model_silnik_model_fk FOREIGN KEY (model_id_modelu) REFERENCES Model(id_modelu),
    CONSTRAINT model_silnik_silnik_fk FOREIGN KEY (silnik_id_silnika) REFERENCES Silnik(id_silnika)
);

CREATE TABLE Model_Dealer (
    model_id_modelu INT,
    dealer_nazwa VARCHAR(100), 
    CONSTRAINT model_dealer_pk PRIMARY KEY (model_id_modelu, dealer_nazwa),
    CONSTRAINT model_dealer_model_fk FOREIGN KEY (model_id_modelu) REFERENCES Model(id_modelu),
    CONSTRAINT model_dealer_dealer_fk FOREIGN KEY (dealer_nazwa) REFERENCES Dealer(nazwa)
);



INSERT INTO Marka (nazwa, rok_zalozenia) VALUES
('Toyota', 1937),   
('Volkswagen', 1937),
('Ford Motor Company', 1903);
    
INSERT INTO Silnik (id_silnika, rodzaj_paliwa, parametry) VALUES
(1, 'Benzyna', '1.6L, 120KM'),
(2, 'Diesel', '2.0L, 150KM'),
(3, 'Elektryczny', '150kW, 400Nm');

INSERT INTO Model (id_modelu, nazwa, rok_wprowadzenia, marka_nazwa) VALUES
(1, 'Corolla', 1966, 'Toyota'),
(2, 'Golf', 1974, 'Volkswagen'),
(3, 'Focus', 1998, 'Ford Motor Company');



INSERT INTO Dealer (nazwa, adres) VALUES
('Autoland', 'ul. Warszawska 1, Poznañ'),
('CarMax', 'ul. Krakowska 2, Wroc³aw'),
('Superauta', 'ul. Gdañska 3, Gdañsk'); 

INSERT INTO Klient (id_klienta, imie, nazwisko,numer_telefonu) VALUES
(1, 'Jan', 'Kowalski',123456789),
(2, 'Anna', 'Nowak',12326789),
(3, 'Piotr', 'Wiœniewski',53456789);

INSERT INTO Samochod (VIN, przebieg, rok_produkcji, skrzynia_biegow, kraj_pochodzenia, model_id_modelu, silnik_id_silnika) VALUES
('VIN123456789012345', 50000, 2020, 'Automatyczna', 'Japonia', 1, 1),
('VIN987654321098765', 80000, 2018, 'Manualna', 'Niemcy', 2, 2),
('VIN111222333444555', 30000, 2022, 'Automatyczna', 'USA', 3, 3);

INSERT INTO Wyposazenie (nazwa) VALUES
('Klimatyzacja'),
('Nawigacja'),
('Skórzane fotele');

INSERT INTO Samochod_Wyposazenie (samochod_VIN, wyposazenie_nazwa) VALUES
('VIN123456789012345', 'Klimatyzacja'),
('VIN123456789012345', 'Nawigacja'),
('VIN987654321098765', 'Skórzane fotele');

INSERT INTO Sprzedaz (data, cena, dealer_nazwa, samochod_VIN, klient_id_klienta) VALUES
('2023-05-15', 25000.00, 'Autoland', 'VIN123456789012345', 1),
('2023-06-20', 32000.00, 'CarMax', 'VIN987654321098765', 2),
('2023-07-10', 40000.00, 'Superauta', 'VIN111222333444555', 3);

INSERT INTO Model_Silnik (model_id_modelu, silnik_id_silnika) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Model_Dealer (model_id_modelu, dealer_nazwa) VALUES
(1, 'Autoland'),
(2, 'CarMax'),
(3, 'Superauta');





SELECT * FROM Sprzedaz;
SELECT * FROM Samochod_Wyposazenie;
SELECT * FROM Samochod;
SELECT * FROM Model_Silnik;
SELECT * FROM Model_Dealer;
SELECT * FROM Model;
SELECT * FROM Silnik;
SELECT * FROM Marka;
SELECT * FROM Klient;
SELECT * FROM Dealer;
SELECT * FROM Wyposazenie;