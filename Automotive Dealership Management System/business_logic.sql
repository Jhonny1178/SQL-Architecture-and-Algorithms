ALTER PROCEDURE DodajSamochod (
    @VIN VARCHAR(100),
    @Przebieg INT,
    @RokProdukcji INT,
    @SkrzyniaBiegow VARCHAR(20),
    @KrajPochodzenia VARCHAR(50),
    @ModelId INT,
    @SilnikId INT,
    @DealerNazwa VARCHAR(100)
)
AS
BEGIN
    -- Sprawdzenie, czy model samochodu istnieje
    IF NOT EXISTS (SELECT 1 FROM Model WHERE id_modelu = @ModelId)
    BEGIN
        RAISERROR('Model samochodu nie istnieje.', 16, 1);
        RETURN;
    END

    -- Sprawdzenie, czy silnik jest kompatybilny z modelem
    IF NOT EXISTS (SELECT 1 FROM Model_Silnik WHERE model_id_modelu = @ModelId AND silnik_id_silnika = @SilnikId)
    BEGIN
        RAISERROR('Silnik nie jest kompatybilny z modelem samochodu.', 16, 1);
        RETURN;
    END

    -- Sprawdzenie, czy dealer istnieje
    IF NOT EXISTS (SELECT 1 FROM Dealer WHERE nazwa = @DealerNazwa)
    BEGIN
        RAISERROR('Dealer nie istnieje.', 16, 1);
        RETURN;
    END

    MERGE INTO Samochod AS target
    USING (VALUES (@VIN, @Przebieg, @RokProdukcji, @SkrzyniaBiegow, @KrajPochodzenia, @ModelId, @SilnikId))
        AS source (VIN, przebieg, rok_produkcji, skrzynia_biegow, kraj_pochodzenia, model_id_modelu, silnik_id_silnika)
    ON (target.VIN = source.VIN)
    WHEN MATCHED THEN
        UPDATE SET 
            przebieg = source.przebieg,
            rok_produkcji = source.rok_produkcji,
            skrzynia_biegow = source.skrzynia_biegow,
            kraj_pochodzenia = source.kraj_pochodzenia,
            model_id_modelu = source.model_id_modelu,
            silnik_id_silnika = source.silnik_id_silnika
    WHEN NOT MATCHED THEN
        INSERT (VIN, przebieg, rok_produkcji, skrzynia_biegow, kraj_pochodzenia, model_id_modelu, silnik_id_silnika)
        VALUES (source.VIN, source.przebieg, source.rok_produkcji, source.skrzynia_biegow, source.kraj_pochodzenia, source.model_id_modelu, source.silnik_id_silnika);

    MERGE INTO Model_Dealer AS target
    USING (VALUES (@ModelId, @DealerNazwa))
        AS source (model_id_modelu, dealer_nazwa)
    ON (target.model_id_modelu = source.model_id_modelu AND target.dealer_nazwa = source.dealer_nazwa)
    WHEN NOT MATCHED THEN
        INSERT (model_id_modelu, dealer_nazwa)
        VALUES (source.model_id_modelu, source.dealer_nazwa);

    PRINT 'Samochód zosta³ dodany/zaktualizowany w ofercie dealera.';
END;
GO

ALTER PROCEDURE SprzedajSamochod(
    @VIN VARCHAR(100),
    @Data DATE,
    @Cena MONEY,
    @DealerNazwa VARCHAR(100),
    @KlientId INT
)
AS
BEGIN
    -- Sprawdzenie, czy samochód istnieje
    IF NOT EXISTS (SELECT 1 FROM Samochod WHERE VIN = @VIN)
    BEGIN
        RAISERROR('Samochód nie istnieje.', 16, 1);
        RETURN;
    END

    -- Sprawdzenie, czy dealer istnieje
    IF NOT EXISTS (SELECT 1 FROM Dealer WHERE nazwa = @DealerNazwa)
    BEGIN
        RAISERROR('Dealer nie istnieje.', 16, 1);
        RETURN;
    END

    -- Sprawdzenie, czy klient istnieje
    IF NOT EXISTS (SELECT 1 FROM Klient WHERE id_klienta = @KlientId)
    BEGIN
        RAISERROR('Klient nie istnieje.', 16, 1);
        RETURN;
    END

    -- Dodanie sprzeda¿y do tabeli Sprzedaz
    INSERT INTO Sprzedaz (data, cena, dealer_nazwa, samochod_VIN, klient_id_klienta)
    VALUES (@Data, @Cena, @DealerNazwa, @VIN, @KlientId);
    

    PRINT 'Samochód zosta³ sprzedany.';
END;
GO

-- Funkcja do sprawdzania, czy model jest osobowy
ALTER FUNCTION CzyOsobowy(@ModelId INT)
RETURNS BIT
AS
BEGIN
    DECLARE @Typ VARCHAR(20);
    SELECT @Typ = typ FROM Model WHERE id_modelu = @ModelId;

    RETURN CASE WHEN @Typ = 'osobowy' THEN 1 ELSE 0 END;
END;
GO

-- Widok pokazuj¹cy samochody osobowe dostêpne u dealerów
ALTER VIEW WidokSamochodowOsobowychUDealerow AS
SELECT S.VIN, S.przebieg, S.rok_produkcji, S.skrzynia_biegow, 
       S.kraj_pochodzenia, M.nazwa AS model, MD.dealer_nazwa
FROM Samochod S
JOIN Model M ON S.model_id_modelu = M.id_modelu
JOIN Model_Dealer MD ON M.id_modelu = MD.model_id_modelu
WHERE M.typ = 'osobowy';
