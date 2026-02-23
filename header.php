<?php
// header.php
session_start(); // Seule ligne obligatoire si vous utilisez des sessions
$titre_page = $titre_page ?? "Le Bon Coin ECE"; // Titre par défaut
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><?= htmlspecialchars($titre_page) ?></title>
</head>
<body>
<!-- Rien d'autre ! -->