<?php require 'config.php'; ?>

<!DOCTYPE html>
<html>
<head>
    <title>Inscription</title>
</head>
<body>
    <?php
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $email = $_POST['email'];
        $password = password_hash($_POST['password'], PASSWORD_DEFAULT);
        $pseudo = $_POST['pseudo'];
        
        try {
            $stmt = $conn->prepare("INSERT INTO utilisateurs (email, mot_de_passe, pseudo) VALUES (?, ?, ?)");
            $stmt->execute([$email, $password, $pseudo]);
            header("Location: connexion.php?success=1");
        } catch(PDOException $e) {
            echo "<p style='color:red'>Erreur : " . $e->getMessage() . "</p>";
        }
    }
    ?>

    <h2>Inscription</h2>
    <form method="POST">
        <input type="email" name="email" placeholder="Email" required><br>
        <input type="password" name="password" placeholder="Mot de passe" required><br>
        <input type="text" name="pseudo" placeholder="Pseudo" required><br>
        <button type="submit">S'inscrire</button>
    </form>
    <p>Déjà inscrit ? <a href="connexion.php">Se connecter</a></p>
</body>
</html>