const express = require('express');
const cors = require('cors');
require('dotenv').config();

const postsRoutes = require('./routes/posts');
const comentarisRoutes = require('./routes/comentaris');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Rutes
app.use('/api/posts', postsRoutes);
app.use('/api/comentaris', comentarisRoutes);

// Iniciar el servidor
app.listen(PORT, () => {
    console.log(`Servidor escoltant a http://localhost:${PORT}`);
});
