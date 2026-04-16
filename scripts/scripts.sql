-- 1. SCHEMAS
CREATE SCHEMA academico;
CREATE SCHEMA seguranca;

-- 2. TABELAS
CREATE TABLE academico.aluno (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    endereco VARCHAR(100),
    data_ingresso DATE,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE academico.professor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE academico.disciplina (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(10),
    nome VARCHAR(100),
    carga_horaria INT
);

CREATE TABLE academico.turma (
    id SERIAL PRIMARY KEY,
    disciplina_id INT REFERENCES academico.disciplina(id),
    professor_id INT REFERENCES academico.professor(id),
    ciclo VARCHAR(10)
);

CREATE TABLE academico.matricula (
    id SERIAL PRIMARY KEY,
    aluno_id INT REFERENCES academico.aluno(id),
    turma_id INT REFERENCES academico.turma(id),
    nota NUMERIC(4,2),
    ativo BOOLEAN DEFAULT TRUE
);

-- 3. INSERTS
-- ALUNOS
INSERT INTO academico.aluno (nome, email, endereco, data_ingresso) VALUES
('Ana Beatriz Lima','ana.lima@aluno.edu.br','Braganca Paulista/SP','2026-01-20'),
('Bruno Henrique Souza','bruno.souza@aluno.edu.br','Atibaia/SP','2026-01-21'),
('Camila Ferreira','camila.ferreira@aluno.edu.br','Jundiai/SP','2026-01-22'),
('Diego Martins','diego.martins@aluno.edu.br','Campinas/SP','2026-01-23'),
('Eduarda Nunes','eduarda.nunes@aluno.edu.br','Itatiba/SP','2026-01-24'),
('Felipe Araujo','felipe.araujo@aluno.edu.br','Louveira/SP','2026-01-25'),
('Gabriela Torres','gabriela.torres@aluno.edu.br','Nazare Paulista/SP','2025-08-05'),
('Helena Rocha','helena.rocha@aluno.edu.br','Piracaia/SP','2025-08-06'),
('Igor Santana','igor.santana@aluno.edu.br','Jarinu/SP','2025-08-07');

-- PROFESSORES
INSERT INTO academico.professor (nome) VALUES
('Prof. Carlos Mendes'),
('Profa. Juliana Castro'),
('Prof. Eduardo Pires'),
('Prof. Renato Alves'),
('Profa. Marina Lopes'),
('Prof. Ricardo Faria');

-- DISCIPLINAS
INSERT INTO academico.disciplina (codigo, nome, carga_horaria) VALUES
('ADS101','Banco de Dados',80),
('ADS102','Engenharia de Software',80),
('ADS103','Algoritmos',60),
('ADS104','Redes de Computadores',60),
('ADS105','Sistemas Operacionais',60),
('ADS106','Estruturas de Dados',80);

-- TURMAS
INSERT INTO academico.turma (disciplina_id, professor_id, ciclo) VALUES
(1,1,'2026/1'),
(2,2,'2026/1'),
(3,4,'2026/1'),
(4,5,'2026/1'),
(5,3,'2026/1'),
(6,6,'2026/1'),
(1,1,'2025/2'),
(2,2,'2025/2'),
(3,4,'2025/2'),
(4,5,'2025/2'),
(5,3,'2025/2'),
(6,6,'2025/2');

-- MATRÍCULAS
INSERT INTO academico.matricula (aluno_id, turma_id, nota) VALUES
(1,1,9.1),
(1,2,8.4),
(1,5,8.9),

(2,1,7.3),
(2,3,6.8),
(2,4,7.0),

(3,1,5.9),
(3,2,7.5),
(3,6,6.1),

(4,3,4.7),
(4,4,6.2),
(4,5,5.8),

(5,2,9.5),
(5,4,8.1),
(5,6,8.7),

(6,1,6.4),
(6,3,5.6),
(6,5,6.9),

(7,7,6.4),
(7,8,7.1),

(8,9,8.8),
(8,10,7.9),

(9,11,5.5),
(9,12,6.3);

-- 4. SEGURANÇA
CREATE ROLE professor_role;
CREATE ROLE coordenador_role;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA academico TO coordenador_role;

GRANT UPDATE (nota) ON academico.matricula TO professor_role;

REVOKE SELECT (email) ON academico.aluno FROM professor_role;

-- 5. QUERIES
-- Matriculados 2026/1
SELECT a.nome, d.nome, t.ciclo
FROM academico.matricula m
JOIN academico.aluno a ON m.aluno_id = a.id
JOIN academico.turma t ON m.turma_id = t.id
JOIN academico.disciplina d ON t.disciplina_id = d.id
WHERE t.ciclo = '2026/1';

-- Média < 6
SELECT d.nome, AVG(m.nota)
FROM academico.matricula m
JOIN academico.turma t ON m.turma_id = t.id
JOIN academico.disciplina d ON t.disciplina_id = d.id
GROUP BY d.nome
HAVING AVG(m.nota) < 6;

-- Professores (LEFT JOIN)
SELECT p.nome, d.nome
FROM academico.professor p
LEFT JOIN academico.turma t ON p.id = t.professor_id
LEFT JOIN academico.disciplina d ON t.disciplina_id = d.id;

-- Melhor nota em Banco de Dados
SELECT a.nome, m.nota
FROM academico.matricula m
JOIN academico.aluno a ON m.aluno_id = a.id
JOIN academico.turma t ON m.turma_id = t.id
JOIN academico.disciplina d ON t.disciplina_id = d.id
WHERE d.nome = 'Banco de Dados'
AND m.nota = (
    SELECT MAX(m2.nota)
    FROM academico.matricula m2
    JOIN academico.turma t2 ON m2.turma_id = t2.id
    JOIN academico.disciplina d2 ON t2.disciplina_id = d2.id
    WHERE d2.nome = 'Banco de Dados'
);