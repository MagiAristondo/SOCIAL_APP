const express = require('express');
const router = express.Router();
const db = require('../db');

// Afegir un like o dislike
router.post('/', async (req, res) => {
    const { id_usuari, id_post, tipus } = req.body;
    if (!id_usuari || !id_post || !tipus) {
        return res.status(400).json({ error: 'Falten camps obligatoris' });
    }
    try {
        await db.query(
            'INSERT INTO likes (id_usuari, id_post, tipus) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE tipus = ?',
            [id_usuari, id_post, tipus, tipus]
        );
        res.status(200).json({ message: 'Like/dislike registrat correctament' });
    } catch (error) {
        res.status(500).json({ error: 'Error registrant el like/dislike' });
    }
});

// Obtenir el recompte de likes i dislikes per un post
router.get('/:id_post', async (req, res) => {
    const { id_post } = req.params;
    try {
        const [likes] = await db.query(
            'SELECT tipus, COUNT(*) as total FROM likes WHERE id_post = ? GROUP BY tipus',
            [id_post]
        );
        res.json(likes);
    } catch (error) {
        res.status(500).json({ error: 'Error obtenint els likes/dislikes' });
    }
});

module.exports = router;
