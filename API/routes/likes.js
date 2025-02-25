const express = require('express');
const router = express.Router();
const db = require('../db');

// Afegir un like o dislike
/**
 * @swagger
 * /api/likes:
 *   post:
 *     summary: Afegeix un like o dislike
 *     tags:
 *       - Likes
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               id_usuari:
 *                 type: integer
 *               id_post:
 *                 type: integer
 *               tipus:
 *                 type: string
 *     responses:
 *       200:
 *         description: Like/dislike registrat correctament
 *       400:
 *         description: Falten camps obligatoris
 *       500:
 *         description: Error registrant el like/dislike
 */
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
/**
 * @swagger
 * /api/likes/{id_post}:
 *   get:
 *     summary: Obté el recompte de likes i dislikes per un post
 *     tags:
 *       - Likes
 *     parameters:
 *       - in: path
 *         name: id_post
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Recompte de likes i dislikes retornat correctament
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   tipus:
 *                     type: string
 *                   total:
 *                     type: integer
 *       500:
 *         description: Error obtenint els likes/dislikes
 */
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
