const express = require('express');
const cors = require('cors');
require('dotenv').config();

const postsRoutes = require('./routes/posts');
const comentarisRoutes = require('./routes/comentaris');
const usersRoutes = require('./routes/users');
const likesRoutes = require('./routes/likes');
const { swaggerDocs, swaggerUi } = require('./swagger');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Documentació Swagger
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));

// Rutes
app.use('/api/posts', postsRoutes);
app.use('/api/comentaris', comentarisRoutes);
app.use('/api/usuaris', usersRoutes);
app.use('/api/likes', likesRoutes);

// Iniciar el servidor
app.listen(PORT, () => {
    console.log(`Servidor escoltant a http://localhost:${PORT}`);
    console.log(`Documentació Swagger disponible a http://localhost:${PORT}/api-docs`);
});