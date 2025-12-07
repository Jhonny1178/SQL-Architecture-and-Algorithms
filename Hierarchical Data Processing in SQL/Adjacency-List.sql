-- Sprawdzenie, czy tabela istnieje i ewentualne usuniêcie
IF OBJECT_ID('dbo.tree_adjacency', 'U') IS NOT NULL
    DROP TABLE dbo.tree_adjacency;

-- Tworzenie tabeli
CREATE TABLE tree_adjacency (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES tree_adjacency(id)
);

-- Wype³nienie przyk³adowymi danymi
INSERT INTO tree_adjacency (id, name, parent_id)
VALUES
    (1, 'Elektronika', NULL),
    (2, 'Telefony', 1),
    (3, 'Komputery', 1),
    (4, 'Smartfony', 2),
    (5, 'Laptopy', 3),
    (6, 'Tablety', 3);

GO 

-- Procedura dodawania wêz³a
ALTER PROCEDURE add_node_adjacency
    @node_id INT,
    @node_name VARCHAR(255),
    @parent_id INT = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM tree_adjacency WHERE id = @node_id) 
    BEGIN
        INSERT INTO tree_adjacency (id, name, parent_id)
        VALUES (@node_id, @node_name, @parent_id);
        PRINT 'Wêze³ dodany pomyœlnie.';
    END
    ELSE 
    BEGIN
        RAISERROR('Wêze³ o podanym ID ju¿ istnieje.', 16, 1);
    END
END

GO 

-- Procedura usuwania wêz³a
ALTER PROCEDURE delete_node_adjacency 
    @node_id INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM tree_adjacency WHERE id = @node_id) 
    BEGIN
        WITH descendants AS (
            SELECT id FROM tree_adjacency WHERE id = @node_id
            UNION ALL
            SELECT t.id FROM tree_adjacency t
            INNER JOIN descendants d ON t.parent_id = d.id
        )
        DELETE FROM tree_adjacency WHERE id IN (SELECT id FROM descendants);
        PRINT 'Wêze³ i jego potomkowie usuniêci pomyœlnie.';
    END
    ELSE
    BEGIN
        RAISERROR('Wêze³ o podanym ID nie istnieje.', 16, 1);
    END
END

GO

-- Funkcja odczytuj¹ca wszystkich potomków 
ALTER FUNCTION get_descendants_adjacency(@node_id INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @descendants VARCHAR(MAX) = '';

    WITH descendants AS (
        SELECT id, name FROM tree_adjacency WHERE id = @node_id
        UNION ALL
        SELECT t.id, t.name FROM tree_adjacency t
        INNER JOIN descendants d ON t.parent_id = d.id
    )
    SELECT @descendants = @descendants + CAST(id AS VARCHAR(10)) + ' - ' + name + ', '
    FROM descendants WHERE id <> @node_id;

    RETURN LEFT(@descendants, LEN(@descendants) - 1); 
END

GO 

-- Procedura przenoszenia wêz³a
ALTER PROCEDURE move_node_adjacency
    @node_id INT,
    @new_parent_id INT
AS
BEGIN
    -- Sprawdzenie, czy nowy rodzic istnieje i nie jest potomkiem przenoszonego wêz³a
    IF EXISTS (SELECT 1 FROM tree_adjacency WHERE id = @new_parent_id) 
       AND NOT EXISTS (
            SELECT 1 
            FROM tree_adjacency AS parent
            JOIN tree_adjacency AS child ON parent.id = child.parent_id
            WHERE parent.id = @node_id AND child.id = @new_parent_id
        )
    BEGIN
        UPDATE tree_adjacency
        SET parent_id = @new_parent_id
        WHERE id = @node_id;
        PRINT 'Wêze³ przeniesiony pomyœlnie.';
    END
    ELSE
    BEGIN
        RAISERROR ('Nieprawid³owy nowy rodzic lub wêze³.', 16, 1); 
    END
END

GO 



EXEC add_node_adjacency @node_id = 7, @node_name = 'Akcesoria', @parent_id = 1;
EXEC add_node_adjacency @node_id = 8, @node_name = 'Telewizory', @parent_id = 1;
EXEC delete_node_adjacency @node_id = 2; 
SELECT dbo.get_descendants_adjacency(1); --funckja wyczytujaca potomków 1
EXEC move_node_adjacency @node_id = 8, @new_parent_id = 3; 


SELECT * FROM tree_adjacency;
