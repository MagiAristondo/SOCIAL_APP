const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtenir tots els missatges
/**
 * @swagger
 * /api/posts:
 *   get:
 *     summary: Obté tots els missatges
 *     tags: 
 *       - Posts
 *     responses:
 *       200:
 *         description: Llista de missatges retornada correctament
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: integer
 *                   text:
 *                     type: string
 *                   latitud:
 *                     type: number
 *                   longitud:
 *                     type: number
 *                   likes:
 *                     type: integer
 *                   dislikes:
 *                     type: integer
 *                   data_hora:
 *                     type: string
 *                     format: date-time
 */
router.get('/', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM missatges ORDER BY data_hora DESC');
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: 'Error obtenint els missatges' });
    }
});

// Crear un nou missatge
/**
 * @swagger
 * /api/posts:
 *   post:
 *     summary: Crear un nou missatge
 *     tags:
 *       - Posts
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               text:
 *                 type: string
 *               latitud:
 *                 type: number
 *               longitud:
 *                 type: number
 *     responses:
 *       201:
 *         description: Missatge creat correctament
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: integer
 *                 text:
 *                   type: string
 *                 latitud:
 *                   type: number
 *                 longitud:
 *                   type: number
 */
router.post('/', async (req, res) => {
    const { text, latitud, longitud } = req.body;
    if (!text || latitud === undefined || longitud === undefined || latitud === null || longitud === null) {
        return res.status(400).json({ error: 'Falten camps obligatoris' });
    }
    try {
        const [result] = await db.query(
            'INSERT INTO missatges (text, latitud, longitud, likes, dislikes, data_hora) VALUES (?, ?, ?, 0, 0, NOW())',
            [text, latitud, longitud]
        );
        res.status(201).json({ id: result.insertId, text, latitud, longitud });
    } catch (error) {
        res.status(500).json({ error: 'Error creant el missatge' });
    }
});

// Esborrar un missatge
/**
 * @swagger
 * /api/posts/{id}:
 *   delete:
 *     summary: Esborra un missatge
 *     tags:
 *       - Posts
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Missatge eliminat correctament
 *       404:
 *         description: Missatge no trobat
 */
router.delete('/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const [result] = await db.query('DELETE FROM missatges WHERE id = ?', [id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Missatge no trobat' });
        }
        res.json({ message: 'Missatge eliminat correctament' });
    } catch (error) {
        res.status(500).json({ error: 'Error eliminant el missatge' });
    }
});

// Afegir un like
/**
 * @swagger
 * /api/posts/{id}/like:
 *   post:
 *     summary: Afegeix un like a un missatge
 *     tags:
 *       - Posts
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Like afegit correctament
 *       404:
 *         description: Missatge no trobat
 */
router.post('/:id/like', async (req, res) => {
    try {
        const { id } = req.params;

        const [result] = await db.query(
            'UPDATE missatges SET likes = likes + 1 WHERE id = ?',
            [id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Missatge no trobat' });
        }

        res.status(200).json({ message: 'Like afegit correctament' });
    } catch (error) {
        res.status(500).json({ error: 'Error actualitzant el like' });
    }
});

// Afegir un dislike
/**
 * @swagger
 * /api/posts/{id}/dislike:
 *   post:
 *     summary: Afegeix un dislike a un missatge
 *     tags:
 *       - Posts
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Dislike afegit correctament
 *       404:
 *         description: Missatge no trobat
 */
router.post('/:id/dislike', async (req, res) => {
    try {
        const { id } = req.params;

        const [result] = await db.query(
            'UPDATE missatges SET dislikes = dislikes + 1 WHERE id = ?',
            [id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Missatge no trobat' });
        }

        res.status(200).json({ message: 'Dislike afegit correctament' });
    } catch (error) {
        res.status(500).json({ error: 'Error actualitzant el dislike' });
    }
});

module.exports = router;
