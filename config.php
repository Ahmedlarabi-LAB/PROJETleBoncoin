<?php
session_start();

$host = "localhost";
$dbname = "LeBonCoin";
$user = "root"; // Remplacez par votre utilisateur MySQL
$pass = "";     // Remplacez par votre mot de passe MySQL

try {
    $conn = new PDO("mysql:host=$host;dbname=$dbname", $user, $pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    die("Erreur de connexion : " . $e->getMessage());
}
?>