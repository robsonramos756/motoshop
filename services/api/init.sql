CREATE DATABASE IF NOT EXISTS motoshop;
USE motoshop;

CREATE TABLE IF NOT EXISTS motos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    marca VARCHAR(100) NOT NULL,
    cilindradas VARCHAR(50) NOT NULL,
    valor VARCHAR(50) NOT NULL,
    imagem VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS comentarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    moto_id INT NOT NULL,
    usuario VARCHAR(100) NOT NULL,
    comentario TEXT NOT NULL,
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (moto_id) REFERENCES motos(id) ON DELETE CASCADE
);

INSERT INTO motos (nome, marca, cilindradas, valor, imagem) VALUES
('BMW F750', 'BMW', '750cc', 'R$ 35.000','BMWF750.jpeg'),
('BMW F850', 'BMW', '850cc', 'R$ 37.000', 'BMWF850GS.jpeg'),
('BMW F1000', 'BMW', '1000cc', 'R$ 135.000','BWMS1000.jpeg'),
('HONDA CB1000R', 'HONDA', '1000cc', 'R$ 35.000','HondaCB1000R.jpeg'),
('HONDA CBR1000RR', 'HONDA', '1000cc', 'R$ 35.000', 'HondaCBR1000RRR.jpeg'),
('VERSYS 1000', 'KAWASAKI', '1000cc', 'R$ 35.000', 'KawasakiVersys1000.jpeg'),
('Z900', 'KAWASAKI', '900cc', 'R$ 38.000', 'Kawasakiz900.jpeg'),
('Z1000', 'KAWASAKI', '1000cc', 'R$ 39.000', 'KawasakiZ1000.jpeg'),
('GXSS', 'SUZUKI', '1000cc', 'R$ 40.000', 'SuzukiGXSS1000.jpeg'),
('VSTROM', 'SUZUKI', '1050cc', 'R$ 41.000', 'SuzukiVStrom1050.jpeg'),
('TRACER900', 'TRACER', '1000cc', 'R$ 42.000', 'Tracer900.jpeg'),
('TRIUMPH900', 'TRIUMPH', '1000cc', 'R$ 43.000', 'Triumph900.jpeg'),
('STREET', 'TRIUMPH', '1000cc', 'R$ 47.000', 'TriumphStreet.jpeg'),
('MT09', 'YAMAHA', '1000cc', 'R$ 42.000', 'YamahaMT09.jpeg');

