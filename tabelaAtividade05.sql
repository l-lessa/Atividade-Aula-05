-- Tabela Clientes
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    email VARCHAR(100),
    telefone VARCHAR(20),
    endereco VARCHAR(255)
);

-- Tabela Produtos
CREATE TABLE Produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    descricao TEXT,
    preco DECIMAL(10, 2)
);

-- Tabela Vendas
CREATE TABLE Vendas (
    id_venda INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    data_venda DATE,
    valor_total DECIMAL(10, 2),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

-- Tabela Estoque
CREATE TABLE Estoque (
    id_produto INT PRIMARY KEY,
    quantidade INT,
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

-- View com uma subquery como uma nova coluna
CREATE VIEW VendasDetalhadas AS
SELECT v.*, c.nome AS nome_cliente,
(SELECT COUNT(*) FROM Vendas WHERE id_cliente = v.id_cliente) AS total_compras_cliente
FROM Vendas v
JOIN Clientes c ON v.id_cliente = c.id_cliente;

-- Subquery com filtro em uma consulta
SELECT * FROM Produtos WHERE id_produto IN (SELECT id_produto FROM Estoque WHERE quantidade > 0);

-- Trigger para atualizar o estoque após uma venda
DELIMITER $$
CREATE TRIGGER AtualizarEstoqueAposVenda AFTER INSERT ON Vendas
FOR EACH ROW
BEGIN
    UPDATE Estoque SET quantidade = quantidade - 1 WHERE id_produto = NEW.id_produto;
END$$
DELIMITER ;