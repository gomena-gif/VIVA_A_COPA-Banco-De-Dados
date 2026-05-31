-- =========================================
-- BANCO DE DADOS - VIVA A COPA 2026
-- =========================================

CREATE DATABASE viva_a_copa
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE viva_a_copa;

-- =========================================
-- TABELA USUÁRIOS
-- =========================================

CREATE TABLE usuarios (

    id INT AUTO_INCREMENT PRIMARY KEY,

    nome VARCHAR(150) NOT NULL,

    email VARCHAR(180) UNIQUE NOT NULL,

    senha VARCHAR(255) NOT NULL,

    telefone VARCHAR(20),

    cpf VARCHAR(20),

    data_nascimento DATE,

    foto_perfil VARCHAR(255),

    pais VARCHAR(100),

    cidade VARCHAR(100),

    idioma VARCHAR(50) DEFAULT 'Português',

    tipo_usuario ENUM(
        'cliente',
        'admin'
    ) DEFAULT 'cliente',

    status ENUM(
        'ativo',
        'inativo',
        'bloqueado'
    ) DEFAULT 'ativo',

    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

-- =========================================
-- TABELA CIDADES DA COPA
-- =========================================

CREATE TABLE cidades (

    id INT AUTO_INCREMENT PRIMARY KEY,

    nome VARCHAR(120) NOT NULL,

    pais VARCHAR(100) NOT NULL,

    descricao TEXT,

    imagem VARCHAR(255),

    estadio_principal VARCHAR(150),

    moeda VARCHAR(50),

    idioma VARCHAR(50),

    clima VARCHAR(100)

);


-- TABELA ESTÁDIOS


CREATE TABLE estadios (

    id INT AUTO_INCREMENT PRIMARY KEY,

    cidade_id INT NOT NULL,

    nome VARCHAR(150) NOT NULL,

    capacidade INT,

    endereco VARCHAR(255),

    imagem VARCHAR(255),

    FOREIGN KEY (cidade_id)
    REFERENCES cidades(id)
    ON DELETE CASCADE

);


-- TABELA SELEÇÕES


CREATE TABLE selecoes (

    id INT AUTO_INCREMENT PRIMARY KEY,

    nome VARCHAR(100) NOT NULL,

    grupo VARCHAR(5),

    bandeira VARCHAR(255),

    tecnico VARCHAR(100)

);


-- TABELA JOGOS


CREATE TABLE jogos (

    id INT AUTO_INCREMENT PRIMARY KEY,

    estadio_id INT NOT NULL,

    selecao_casa_id INT NOT NULL,

    selecao_fora_id INT NOT NULL,

    data_jogo DATETIME NOT NULL,

    fase VARCHAR(100),

    status_jogo ENUM(
        'agendado',
        'ao_vivo',
        'encerrado'
    ) DEFAULT 'agendado',

    placar_casa INT DEFAULT 0,

    placar_fora INT DEFAULT 0,

    FOREIGN KEY (estadio_id)
    REFERENCES estadios(id),

    FOREIGN KEY (selecao_casa_id)
    REFERENCES selecoes(id),

    FOREIGN KEY (selecao_fora_id)
    REFERENCES selecoes(id)

);


-- TABELA HOTÉIS


CREATE TABLE hoteis (

    id INT AUTO_INCREMENT PRIMARY KEY,

    cidade_id INT NOT NULL,

    nome VARCHAR(150) NOT NULL,

    endereco VARCHAR(255),

    estrelas INT,

    preco_noite DECIMAL(10,2),

    descricao TEXT,

    imagem VARCHAR(255),

    telefone VARCHAR(30),

    site VARCHAR(255),

    FOREIGN KEY (cidade_id)
    REFERENCES cidades(id)

);


-- TABELA VOOS


CREATE TABLE voos (

    id INT AUTO_INCREMENT PRIMARY KEY,

    origem VARCHAR(120),

    destino VARCHAR(120),

    companhia VARCHAR(120),

    data_saida DATETIME,

    data_chegada DATETIME,

    preco DECIMAL(10,2),

    classe ENUM(
        'econômica',
        'executiva',
        'primeira_classe'
    ) DEFAULT 'econômica'

);


-- TABELA INGRESSOS


CREATE TABLE ingressos (

    id INT AUTO_INCREMENT PRIMARY KEY,

    jogo_id INT NOT NULL,

    setor VARCHAR(100),

    preco DECIMAL(10,2),

    quantidade_disponivel INT,

    tipo ENUM(
        'inteira',
        'meia',
        'vip'
    ) DEFAULT 'inteira',

    FOREIGN KEY (jogo_id)
    REFERENCES jogos(id)
    ON DELETE CASCADE

);


-- TABELA RESERVAS DE HOTÉIS


CREATE TABLE reservas_hotel (

    id INT AUTO_INCREMENT PRIMARY KEY,

    usuario_id INT NOT NULL,

    hotel_id INT NOT NULL,

    checkin DATE,

    checkout DATE,

    quantidade_pessoas INT,

    valor_total DECIMAL(10,2),

    status_reserva ENUM(
        'pendente',
        'confirmada',
        'cancelada'
    ) DEFAULT 'pendente',

    data_reserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (usuario_id)
    REFERENCES usuarios(id),

    FOREIGN KEY (hotel_id)
    REFERENCES hoteis(id)

);


-- TABELA COMPRA DE INGRESSOS


CREATE TABLE compras_ingressos (

    id INT AUTO_INCREMENT PRIMARY KEY,

    usuario_id INT NOT NULL,

    ingresso_id INT NOT NULL,

    quantidade INT DEFAULT 1,

    valor_total DECIMAL(10,2),

    status_pagamento ENUM(
        'pendente',
        'pago',
        'cancelado'
    ) DEFAULT 'pendente',

    data_compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (usuario_id)
    REFERENCES usuarios(id),

    FOREIGN KEY (ingresso_id)
    REFERENCES ingressos(id)

);


-- TABELA PACOTES DE VIAGEM


CREATE TABLE pacotes (

    id INT AUTO_INCREMENT PRIMARY KEY,

    titulo VARCHAR(200),

    descricao TEXT,

    cidade_id INT,

    hotel_id INT,

    preco DECIMAL(10,2),

    dias INT,

    imagem VARCHAR(255),

    inclui_voo BOOLEAN DEFAULT TRUE,

    inclui_hotel BOOLEAN DEFAULT TRUE,

    inclui_ingresso BOOLEAN DEFAULT TRUE,

    FOREIGN KEY (cidade_id)
    REFERENCES cidades(id),

    FOREIGN KEY (hotel_id)
    REFERENCES hoteis(id)

);


-- TABELA RESERVA DE PACOTES


CREATE TABLE reservas_pacotes (

    id INT AUTO_INCREMENT PRIMARY KEY,

    usuario_id INT,

    pacote_id INT,

    quantidade_pessoas INT,

    valor_total DECIMAL(10,2),

    status ENUM(
        'pendente',
        'confirmado',
        'cancelado'
    ) DEFAULT 'pendente',

    data_reserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (usuario_id)
    REFERENCES usuarios(id),

    FOREIGN KEY (pacote_id)
    REFERENCES pacotes(id)

);


-- TABELA PONTOS TURÍSTICOS


CREATE TABLE pontos_turisticos (

    id INT AUTO_INCREMENT PRIMARY KEY,

    cidade_id INT,

    nome VARCHAR(150),

    descricao TEXT,

    endereco VARCHAR(255),

    imagem VARCHAR(255),

    categoria VARCHAR(100),

    FOREIGN KEY (cidade_id)
    REFERENCES cidades(id)

);


-- TABELA AVALIAÇÕES


CREATE TABLE avaliacoes (

    id INT AUTO_INCREMENT PRIMARY KEY,

    usuario_id INT,

    hotel_id INT NULL,

    pacote_id INT NULL,

    nota INT CHECK(nota >= 1 AND nota <= 5),

    comentario TEXT,

    data_avaliacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (usuario_id)
    REFERENCES usuarios(id),

    FOREIGN KEY (hotel_id)
    REFERENCES hoteis(id),

    FOREIGN KEY (pacote_id)
    REFERENCES pacotes(id)

);


-- TABELA FAVORITOS


CREATE TABLE favoritos (

    id INT AUTO_INCREMENT PRIMARY KEY,

    usuario_id INT,

    cidade_id INT NULL,

    hotel_id INT NULL,

    jogo_id INT NULL,

    pacote_id INT NULL,

    FOREIGN KEY (usuario_id)
    REFERENCES usuarios(id),

    FOREIGN KEY (cidade_id)
    REFERENCES cidades(id),

    FOREIGN KEY (hotel_id)
    REFERENCES hoteis(id),

    FOREIGN KEY (jogo_id)
    REFERENCES jogos(id),

    FOREIGN KEY (pacote_id)
    REFERENCES pacotes(id)

);


-- TABELA NOTIFICAÇÕES


CREATE TABLE notificacoes (

    id INT AUTO_INCREMENT PRIMARY KEY,

    usuario_id INT,

    titulo VARCHAR(200),

    mensagem TEXT,

    visualizada BOOLEAN DEFAULT FALSE,

    data_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (usuario_id)
    REFERENCES usuarios(id)

);


-- TABELA SUPORTE


CREATE TABLE suporte (

    id INT AUTO_INCREMENT PRIMARY KEY,

    usuario_id INT,

    assunto VARCHAR(200),

    mensagem TEXT,

    status ENUM(
        'aberto',
        'respondido',
        'fechado'
    ) DEFAULT 'aberto',

    data_abertura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (usuario_id)
    REFERENCES usuarios(id)

);


-- TABELA PAGAMENTOS


CREATE TABLE pagamentos (

    id INT AUTO_INCREMENT PRIMARY KEY,

    usuario_id INT,

    metodo_pagamento ENUM(
        'pix',
        'cartao_credito',
        'boleto'
    ),

    valor DECIMAL(10,2),

    status ENUM(
        'pendente',
        'aprovado',
        'recusado'
    ) DEFAULT 'pendente',

    transacao_id VARCHAR(255),

    data_pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (usuario_id)
    REFERENCES usuarios(id)

);


-- DADOS INICIAIS


INSERT INTO cidades (
    nome,
    pais,
    estadio_principal,
    moeda,
    idioma
)

VALUES

(
    'Nova York',
    'Estados Unidos',
    'MetLife Stadium',
    'Dólar',
    'Inglês'
),

(
    'Toronto',
    'Canadá',
    'BMO Field',
    'Dólar Canadense',
    'Inglês'
),

(
    'Cidade do México',
    'México',
    'Estadio Azteca',
    'Peso Mexicano',
    'Espanhol'
);


-- ADMIN PADRÃO
-- senha: $2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi


INSERT INTO usuarios (

    nome,
    email,
    senha,
    tipo_usuario

)

VALUES (

    'Administrador',
    'admin@vivaacopa.com',
    MD5('$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'),
    'admin'

);


