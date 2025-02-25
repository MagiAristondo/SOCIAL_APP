use social_db;

-- Inserir un missatge de prova
INSERT INTO missatges (text, data_hora, likes, dislikes, latitud, longitud) 
VALUES ('Aquest és un missatge de prova!', NOW(), 0, 0, 41.387, 2.169);

-- Obtenir l'ID del missatge acabat d'inserir
SET @id_missatge = LAST_INSERT_ID();

-- Inserir un comentari associat a aquest missatge
INSERT INTO comentaris (id_missatge, text, data_hora, likes, dislikes) 
VALUES (@id_missatge, 'Aquest és un comentari de prova!', NOW(), 0, 0);




-- Inserir un usuari
INSERT INTO usuaris (correu, contrasenya) VALUES ('usuari@example.com', 'contrasenya123');

-- Inserir un missatge
INSERT INTO missatges (text, latitud, longitud) VALUES ('Aquest és un missatge de prova!', 41.3874, 2.1686);

-- Inserir un like al missatge
INSERT INTO likes (id_usuari, id_post, tipus) VALUES (1, 1, 'like');

-- Canviar el like a dislike
UPDATE likes SET tipus = 'dislike' WHERE id_usuari = 1 AND id_post = 1;

-- Esborrar el dislike
DELETE FROM likes WHERE id_usuari = 1 AND id_post = 1;