CREATE DATABASE IF NOT EXISTS sistema_epi
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE sistema_epi;

CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    perfil ENUM('ADMINISTRADOR', 'SEGURANCA', 'ALMOXARIFADO') NOT NULL DEFAULT 'SEGURANCA',
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS colaboradores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    matricula VARCHAR(50) NOT NULL UNIQUE,
    cargo VARCHAR(100) NOT NULL,
    setor VARCHAR(100) NOT NULL,
    email VARCHAR(150) NULL,
    telefone VARCHAR(30) NULL,
    status ENUM('ATIVO', 'INATIVO') NOT NULL DEFAULT 'ATIVO',
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_colaborador_nome (nome),
    INDEX idx_colaborador_status (status)
);

CREATE TABLE IF NOT EXISTS epis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    tipo VARCHAR(100) NOT NULL,
    ca VARCHAR(50) NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    validade DATE NULL,
    status ENUM('ATIVO', 'INATIVO') NOT NULL DEFAULT 'ATIVO',
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (quantidade_estoque >= 0)
);

CREATE TABLE IF NOT EXISTS emprestimos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    colaborador_id INT NOT NULL,
    usuario_id INT NULL,
    data_emprestimo DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_devolucao DATETIME NULL,
    status ENUM('ABERTO', 'DEVOLVIDO', 'CANCELADO') NOT NULL DEFAULT 'ABERTO',
    observacao VARCHAR(500) NULL,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_emprestimo_colaborador
        FOREIGN KEY (colaborador_id) REFERENCES colaboradores(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_emprestimo_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
        ON UPDATE CASCADE ON DELETE SET NULL,

    INDEX idx_emprestimo_colaborador (colaborador_id),
    INDEX idx_emprestimo_status (status)
);

CREATE TABLE IF NOT EXISTS emprestimo_itens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    emprestimo_id INT NOT NULL,
    epi_id INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    data_devolucao DATETIME NULL,

    CONSTRAINT fk_item_emprestimo
        FOREIGN KEY (emprestimo_id) REFERENCES emprestimos(id)
        ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT fk_item_epi
        FOREIGN KEY (epi_id) REFERENCES epis(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CHECK (quantidade > 0)
);

-- Usuário inicial apenas para desenvolvimento/testes.
-- Em produção, use senha com hash e variáveis de ambiente.
INSERT INTO usuarios (nome, email, senha_hash, perfil)
SELECT 'Administrador', 'admin@empresa.com', 'ALTERAR_ESTA_SENHA', 'ADMINISTRADOR'
WHERE NOT EXISTS (
    SELECT 1 FROM usuarios WHERE email = 'admin@empresa.com'
);