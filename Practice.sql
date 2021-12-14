# Используя базу данных Publishing:
USE Publishing;

# 1. Используя транзакцию добавьте несколько записей в любую из таблиц.
START TRANSACTION;

INSERT INTO Country(NameCountry) VALUE ('Japan');

INSERT INTO Country(NameCountry) VALUE ('USA');

COMMIT;

# 2. Используя транзакцию добавьте несколько записей в любую из таблиц, а потом откатите ее.
START TRANSACTION;

INSERT INTO Themes(NameTheme) VALUE ('Drama');

INSERT INTO Themes(NameTheme) VALUE ('Fantasy');

ROLLBACK;

# 3. Используя транзакцию создайте точку, к кторой необходимо будет откатить транзакцию,
# добавьте несколько записей в любую из таблиц, а потом откатите ее до этой точки.
START TRANSACTION;

INSERT INTO Authors(firstname, lastname, id_country) VALUE ('Mike', 'Omer', 12);

SAVEPOINT mike;

INSERT INTO Authors(firstname, lastname, id_country) VALUE ('Nikolay', 'Gogol', 5);

ROLLBACK TO mike;

COMMIT;

# 4. Создайте триггер, который при удалении книги, копирует данные о ней в отдельную таблицу "DeletedBooks".

CREATE TABLE DeletedBooks AS (SELECT *
                              FROM Books);
DELETE
FROM DeletedBooks;

ALTER TABLE DeletedBooks
    AUTO_INCREMENT = 1;

DELIMITER |
CREATE TRIGGER backupBookData
    BEFORE DELETE
    ON Books
    FOR EACH ROW
BEGIN
    INSERT INTO DeletedBooks(ID_BOOK, NameBook, ID_THEME, ID_AUTHOR, Price, DrawingOfBook, Pages)
    SELECT *
    FROM Books
    WHERE Books.ID_BOOK = OLD.ID_BOOK;
END;
|

DELETE
FROM Books
WHERE ID_BOOK = 15;