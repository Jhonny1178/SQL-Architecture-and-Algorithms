-- Sprawdzenie, czy tabela istnieje i ewentualne usuniêcie
IF OBJECT_ID('dbo.drzewo_sciezek', 'U') IS NOT NULL
    DROP TABLE dbo.drzewo_sciezek;

-- Tworzenie tabeli
CREATE TABLE drzewo_sciezek (
    id INT PRIMARY KEY,
    nazwa VARCHAR(255),
    sciezka VARCHAR(MAX)
);

-- Wype³nienie przyk³adowymi danymi
INSERT INTO drzewo_sciezek (id, nazwa, sciezka)
VALUES
    (1, 'Elektronika', '/1/'),
    (2, 'Telefony', '/1/2/'),
    (3, 'Komputery', '/1/3/'),
    (4, 'Smartfony', '/1/2/4/'),
    (5, 'Laptopy', '/1/3/5/'),
    (6, 'Tablety', '/1/3/6/');

GO 

-- Procedura dodawania wêz³a
ALTER PROCEDURE dodaj_wezel_sciezka
    @id_wezla INT,
    @nazwa_wezla VARCHAR(255),
    @id_rodzica INT = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM drzewo_sciezek WHERE id = @id_wezla) 
    BEGIN
        DECLARE @sciezka VARCHAR(MAX);
        IF @id_rodzica IS NULL
            SET @sciezka = CONCAT('/', @id_wezla, '/');
        ELSE
            SELECT @sciezka = CONCAT(sciezka, @id_wezla, '/') FROM drzewo_sciezek WHERE id = @id_rodzica;

        INSERT INTO drzewo_sciezek (id, nazwa, sciezka)
        VALUES (@id_wezla, @nazwa_wezla, @sciezka);
        PRINT 'Wêze³ dodany pomyœlnie.';
    END
    ELSE 
    BEGIN
        RAISERROR('Wêze³ o podanym ID ju¿ istnieje.', 16, 1);
    END
END

GO 

-- Procedura usuwania wêz³a
ALTER PROCEDURE usun_wezel_sciezka @id_wezla INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM drzewo_sciezek WHERE id = @id_wezla) 
    BEGIN
        DELETE FROM drzewo_sciezek WHERE sciezka LIKE CONCAT((SELECT sciezka FROM drzewo_sciezek WHERE id = @id_wezla), '%');
        PRINT 'Wêze³ i jego potomkowie usuniêci pomyœlnie.';
    END
    ELSE
    BEGIN
        RAISERROR('Wêze³ o podanym ID nie istnieje.', 16, 1);
    END
END

GO 

-- Funkcja odczytuj¹ca wszystkich potomków
ALTER FUNCTION pobierz_potomkow_sciezka(@id_wezla INT)
RETURNS TABLE
AS
RETURN
    SELECT *
    FROM drzewo_sciezek
    WHERE sciezka LIKE CONCAT((SELECT sciezka FROM drzewo_sciezek WHERE id = @id_wezla), '%')
      AND id <> @id_wezla;

GO 

-- Procedura przenoszenia wêz³a
ALTER PROCEDURE przenies_wezel_sciezka
    @id_wezla INT,
    @nowy_id_rodzica INT
AS
BEGIN
    DECLARE @stara_sciezka VARCHAR(MAX) = (SELECT sciezka FROM drzewo_sciezek WHERE id = @id_wezla);
    DECLARE @nowa_sciezka VARCHAR(MAX) = (SELECT sciezka FROM drzewo_sciezek WHERE id = @nowy_id_rodzica);

    IF @stara_sciezka IS NOT NULL AND @nowa_sciezka IS NOT NULL AND @stara_sciezka NOT LIKE CONCAT(@nowa_sciezka, '%')
    BEGIN
        UPDATE drzewo_sciezek
        SET sciezka = CONCAT(@nowa_sciezka, @id_wezla, '/', RIGHT(sciezka, LEN(sciezka) - LEN(@stara_sciezka)))
        WHERE sciezka LIKE CONCAT(@stara_sciezka, '%');
        PRINT 'Wêze³ przeniesiony pomyœlnie.';
    END
    ELSE
    BEGIN
        RAISERROR('Nieprawid³owy nowy rodzic lub wêze³.', 16, 1);
    END
END

GO 


EXEC dodaj_wezel_sciezka @id_wezla = 7, @nazwa_wezla = 'Akcesoria', @id_rodzica = 1;
EXEC dodaj_wezel_sciezka @id_wezla = 8, @nazwa_wezla = 'Telewizory', @id_rodzica = 1;
EXEC usun_wezel_sciezka @id_wezla = 2; 
SELECT * FROM dbo.pobierz_potomkow_sciezka(1);
EXEC przenies_wezel_sciezka @id_wezla = 8, @nowy_id_rodzica = 3; 


SELECT * FROM drzewo_sciezek;
