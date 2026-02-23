-- Création de la base de données
CREATE DATABASE IF NOT EXISTS LeBonCoin 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; -- Encodage UTF-8 pour gérer les caractères spéciaux
USE LeBonCoin;

-- Table utilisateurs
CREATE TABLE utilisateurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    pseudo VARCHAR(50) NOT NULL,
    telephone VARCHAR(20),
    ville VARCHAR(100),
    avatar_path VARCHAR(255) DEFAULT 'assets/default-avatar.jpg',
    role ENUM('user', 'admin') DEFAULT 'user',
    date_inscription DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_email_format CHECK (email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$')
) ENGINE=InnoDB;

-- Table catégories
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE,
    icone VARCHAR(50) -- Optionnel : pour afficher des icônes dans l'interface utilisateur
) ENGINE=InnoDB;

-- Table sous-catégories
CREATE TABLE sous_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    categorie_id INT NOT NULL,
    FOREIGN KEY (categorie_id) REFERENCES categories(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Table annonces
CREATE TABLE annonces (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    prix DECIMAL(10,2) NOT NULL CHECK (prix >= 0), -- Vérification pour garantir que le prix est positif
    categorie_id INT NOT NULL,
    sous_categorie_id INT NULL, -- NULL autorisé ici pour gérer les annonces sans sous-catégorie
    image_path VARCHAR(255),
    utilisateur_id INT NOT NULL,
    statut ENUM('active', 'vendu', 'supprime') DEFAULT 'active',
    date_publication DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,
    FOREIGN KEY (categorie_id) REFERENCES categories(id),
    FOREIGN KEY (sous_categorie_id) REFERENCES sous_categories(id) ON DELETE SET NULL,
    INDEX (categorie_id),
    INDEX (sous_categorie_id),
    INDEX (utilisateur_id)
) ENGINE=InnoDB;

-- Table messages
CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contenu TEXT NOT NULL,
    annonce_id INT NOT NULL,
    envoyeur_id INT NOT NULL,
    destinataire_id INT NOT NULL,
    lu BOOLEAN DEFAULT FALSE,
    date_envoi DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (annonce_id) REFERENCES annonces(id) ON DELETE CASCADE,
    FOREIGN KEY (envoyeur_id) REFERENCES utilisateurs(id),
    FOREIGN KEY (destinataire_id) REFERENCES utilisateurs(id),
    CONSTRAINT chk_envoyeur_destinataire CHECK (envoyeur_id != destinataire_id)
) ENGINE=InnoDB;

-- Table favoris
CREATE TABLE favoris (
    utilisateur_id INT NOT NULL,
    annonce_id INT NOT NULL,
    date_ajout DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (utilisateur_id, annonce_id),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE,
    FOREIGN KEY (annonce_id) REFERENCES annonces(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Table signalements
CREATE TABLE signalements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    annonce_id INT NOT NULL,
    utilisateur_id INT NOT NULL,
    raison ENUM('spam', 'inapproprié', 'arnaque', 'autre') NOT NULL,
    details TEXT,
    traite BOOLEAN DEFAULT FALSE,
    date_signalement DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (annonce_id) REFERENCES annonces(id) ON DELETE CASCADE,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
) ENGINE=InnoDB;

-- Insertion des catégories adaptées au thème de l'ingénierie
INSERT INTO categories (nom, icone) VALUES
('Livres d\'ingénierie', 'book'),
('Matériels informatiques', 'desktop'),
('Matériels électroniques', 'microchip');

-- Insertion des sous-catégories
INSERT INTO sous_categories (nom, categorie_id) VALUES
-- Livres
('Génie civil', 1),
('Génie électrique', 1),
('Informatique', 1),
-- Matériels informatiques
('Ordinateurs portables', 2),
('Composants PC', 2),
('Accessoires', 2),
('Périphériques', 2),
('Imprimantes', 2),
('Réseaux', 2),
-- Matériels électroniques
('Arduino/Raspberry', 3),
('Capteurs', 3),
('Circuits imprimés', 3),
('Composants électroniques', 3);