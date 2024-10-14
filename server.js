const express = require("express");
const bodyParser = require("body-parser");
const admin = require("firebase-admin");

// Initialisation du serveur Express
const app = express();
app.use(bodyParser.json());

// Initialisation de Firebase Admin SDK (vous devez avoir un fichier de clé privée pour Firebase)
admin.initializeApp({
  credential: admin.credential.cert(
    require("./path/to/your-service-account-file.json")
  ),
  databaseURL: "https://your-database-name.firebaseio.com", // Remplacez par l'URL de votre base de données
});

// Endpoint pour envoyer des notifications push
app.post("/send-notification", async (req, res) => {
  const { token, title, body } = req.body;

  const message = {
    notification: {
      title: title,
      body: body,
    },
    token: token, // Le token de l'appareil cible
  };

  try {
    await admin.messaging().send(message);
    res.status(200).send("Notification envoyée avec succès!");
  } catch (error) {
    console.error("Erreur lors de l'envoi de la notification:", error);
    res.status(500).send("Erreur lors de l'envoi de la notification.");
  }
});

// Lancer le serveur
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Serveur en cours d'exécution sur le port ${PORT}`);
});
