const express = require('express');
const router = express.Router();
const db = require('../db');

// Obtenir comentaris d'un missatge
router.get('/:id_missatge', async (req, res) => {
    const { id_missatge } = req.params;
    try {
        const [rows] = await db.query('SELECT * FROM comentaris WHERE id_missatge = ? ORDER BY data_hora ASC', [id_missatge]);
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: 'Error obtenint els comentaris' });
    }
});

// Afegir un comentari a un missatge
router.post('/', async (req, res) => {
    const { id_missatge, text } = req.body;
    if (!id_missatge || !text) {
        return res.status(400).json({ error: 'Falten camps obligatoris' });
    }
    try {
        const [result] = await db.query(
            'INSERT INTO comentaris (id_missatge, text) VALUES (?, ?)',
            [id_missatge, text]
        );
        res.status(201).json({ id: result.insertId, id_missatge, text });
    } catch (error) {
        res.status(500).json({ error: 'Error afegint el comentari' });
    }
});

// Esborrar un comentari
router.delete('/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const [result] = await db.query('DELETE FROM comentaris WHERE id = ?', [id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Comentari no trobat' });
        }
        res.json({ message: 'Comentari eliminat correctament' });
    } catch (error) {
        res.status(500).json({ error: 'Error eliminant el comentari' });
    }
});

module.exports = router;
