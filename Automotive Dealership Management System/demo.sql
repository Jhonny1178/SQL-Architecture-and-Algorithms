-- Dodanie nowego samochodu
EXEC DodajSamochod 'VIN111222333444', 80000, 2022, 'Automatyczna', 'Niemcy', 2, 2, 'Autoland';

-- Sprzedaż istniejącego samochodu
EXEC SprzedajSamochod 'VIN123456789012345', '2024-06-24', 32000.00, 'Autoland', 1;

-- Wyświetlenie wszystkich sprzedanych samochodów
SELECT * FROM Sprzedaz;

-- Wyświetlenie wszystkich samochodów w bazie
SELECT * FROM Samochod;

-- Wyświetlenie wszystkich dealerów
SELECT * FROM Dealer;

-- Sprawdzenie, czy model o ID 2 jest osobowy
--DECLARE @CzyOsobowy BIT;
--SET @CzyOsobowy = dbo.CzyModelOsobowy(2);
--PRINT 'Czy model jest osobowy? ' + CASE WHEN @CzyOsobowy = 1 THEN 'Tak' ELSE 'Nie' END;

-- Wyświetlenie samochodów osobowych dostępnych u dealerów
SELECT * FROM WidokSamochodowOsobowychUDealerow;
