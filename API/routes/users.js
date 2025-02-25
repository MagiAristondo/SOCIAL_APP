const express = require('express');
const router = express.Router();
const db = require('../db');
const bcrypt = require('bcrypt');

// Registrar un nou usuari
router.post('/register', async (req, res) => {
    const { correu, contrasenya } = req.body;
    if (!correu || !contrasenya) {
        return res.status(400).json({ error: 'Falten camps obligatoris' });
    }
    try {
        const hashedPassword = await bcrypt.hash(contrasenya, 10);
        const [result] = await db.query(
            'INSERT INTO usuaris (correu, contrasenya_hash) VALUES (?, ?)',
            [correu, hashedPassword]
        );
        res.status(201).json({ id: result.insertId, correu });
    } catch (error) {
        res.status(500).json({ error: 'Error registrant l\'usuari' });
    }
});

// Iniciar sessió
router.post('/login', async (req, res) => {
    const { correu, contrasenya } = req.body;
    if (!correu || !contrasenya) {
        return res.status(400).json({ error: 'Falten camps obligatoris' });
    }
    try {
        const [users] = await db.query('SELECT * FROM usuaris WHERE correu = ?', [correu]);
        if (users.length === 0) {
            return res.status(401).json({ error: 'Usuari no trobat' });
        }
        const user = users[0];
        const match = await bcrypt.compare(contrasenya, user.contrasenya_hash);
        if (!match) {
            return res.status(401).json({ error: 'Contrasenya incorrecta' });
        }
        res.json({ id: user.id, correu: user.correu });
    } catch (error) {
        res.status(500).json({ error: 'Error iniciant sessió' });
    }
});

module.exports = router;
