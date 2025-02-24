const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtenir tots els missatges
router.get('/', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM missatges ORDER BY data_hora DESC');
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: 'Error obtenint els missatges' });
    }
});

// Crear un nou missatge
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

module.exports = router;
