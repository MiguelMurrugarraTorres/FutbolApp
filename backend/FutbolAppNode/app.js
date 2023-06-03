// Importa las dependencias necesarias
const express = require('express');

// Crea una instancia de Express
const app = express();

// Configura el puerto en el que se ejecutará el servidor
const PORT = process.env.PORT || 3000;

// Define las rutas y lógica del servidor aquí

// Inicia el servidor
app.listen(PORT, () => {
  console.log(`Servidor Express escuchando en el puerto ${PORT}`);
});

const axios = require('axios');

// Ruta para obtener los datos de las noticias de fútbol
app.get('/api/football-data', async (req, res) => {
  try {
    const response = await axios.get('https://api.football-data.org/v2/news', {
      headers: {
        'X-Auth-Token': 'de264f0609cb4493ab59dd276dc5a546'
      }
    });

    const news = response.data.articles;
    res.json(news);
  } catch (error) {
    console.error('Error al obtener los datos de las noticias:', error);
    res.status(500).json({ error: 'Error al obtener los datos de las noticias' });
  }
});
