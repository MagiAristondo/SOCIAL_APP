CREATE DATABASE IF NOT EXISTS social_db;
USE social_db;

CREATE TABLE IF NOT EXISTS usuaris (
    id INT AUTO_INCREMENT PRIMARY KEY,
    correu VARCHAR(255) UNIQUE NOT NULL,
    contrasenya VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS missatges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    text VARCHAR(280) NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    likes INT DEFAULT 0,
    dislikes INT DEFAULT 0,
    latitud DECIMAL(9,6) NOT NULL,
    longitud DECIMAL(9,6) NOT NULL
);

CREATE TABLE IF NOT EXISTS comentaris (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_missatge INT NOT NULL,
    text VARCHAR(280) NOT NULL,
    likes INT DEFAULT 0,
    dislikes INT DEFAULT 0,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_missatge) REFERENCES missatges(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS likes (
    id_usuari INT NOT NULL,
    id_post INT NOT NULL,
    tipus ENUM('like', 'dislike') NOT NULL,
    PRIMARY KEY (id_usuari, id_post),
    FOREIGN KEY (id_usuari) REFERENCES usuaris(id) ON DELETE CASCADE,
    FOREIGN KEY (id_post) REFERENCES missatges(id) ON DELETE CASCADE
);

DELIMITER //

CREATE TRIGGER afegir_like_dislike
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    IF NEW.tipus = 'like' THEN
        UPDATE missatges
        SET likes = likes + 1
        WHERE id = NEW.id_post;
    ELSEIF NEW.tipus = 'dislike' THEN
        UPDATE missatges
        SET dislikes = dislikes + 1
        WHERE id = NEW.id_post;
    END IF;
END;

//

DELIMITER ;

DELIMITER //

CREATE TRIGGER update_like_dislike
AFTER UPDATE ON likes
FOR EACH ROW
BEGIN
    -- Si abans era 'like' i ara és 'dislike'
    IF OLD.tipus = 'like' AND NEW.tipus = 'dislike' THEN
        UPDATE missatges
        SET likes = likes - 1, dislikes = dislikes + 1
        WHERE id = NEW.id_post;
    
    -- Si abans era 'dislike' i ara és 'like'
    ELSEIF OLD.tipus = 'dislike' AND NEW.tipus = 'like' THEN
        UPDATE missatges
        SET likes = likes + 1, dislikes = dislikes - 1
        WHERE id = NEW.id_post;
    END IF;
END;

//

DELIMITER ;

DELIMITER //

CREATE TRIGGER delete_like_dislike
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    -- Si s'esborra un 'like'
    IF OLD.tipus = 'like' THEN
        UPDATE missatges
        SET likes = likes - 1
        WHERE id = OLD.id_post;

    -- Si s'esborra un 'dislike'
    ELSEIF OLD.tipus = 'dislike' THEN
        UPDATE missatges
        SET dislikes = dislikes - 1
        WHERE id = OLD.id_post;
    END IF;
END;

//

DELIMITER ;
