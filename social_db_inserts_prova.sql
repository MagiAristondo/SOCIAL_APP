use social_db;

-- Inserir un missatge de prova
INSERT INTO missatges (text, data_hora, likes, dislikes, latitud, longitud) 
VALUES ('Aquest és un missatge de prova!', NOW(), 0, 0, 41.387, 2.169);

-- Obtenir l'ID del missatge acabat d'inserir
SET @id_missatge = LAST_INSERT_ID();

-- Inserir un comentari associat a aquest missatge
INSERT INTO comentaris (id_missatge, text, data_hora, likes, dislikes) 
VALUES (@id_missatge, 'Aquest és un comentari de prova!', NOW(), 0, 0);