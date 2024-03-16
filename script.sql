-- Criando a tabela
create table institutos (
	tipo_unidade VARCHAR(300),
	unidade VARCHAR(100),
	sexo VARCHAR(50),
	categoria VARCHAR(100),
	subcategoria VARCHAR(100),
	total NUMERIC
);

-- Importando os dados do .csv
copy institutos(tipo_unidade, unidade, sexo, categoria, subcategoria, total) from 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PostgreSQL 16\databases\T2.csv' delimiter ';' CSV HEADER ENCODING 'LATIN1';

-- Calculando o total de estudantes por unidade
SELECT unidade, SUM(total) AS total_alunos
FROM institutos
WHERE tipo_unidade = 'A - Ensino e Pesquisa' AND subcategoria = 'Graduação'
GROUP BY unidade;

-- Calculando o total de alunas por unidade
SELECT unidade, SUM(total) AS total_alunas
FROM institutos
WHERE tipo_unidade = 'A - Ensino e Pesquisa' AND subcategoria = 'Graduação' AND sexo = 'Feminino'
GROUP BY unidade;

-- Calculando a participação feminina por unidade (%)
SELECT distinct i.unidade,
       ROUND((t2.total_alunas / t1.total_alunos) * 100,2) AS participacao_feminina
FROM institutos AS i
JOIN (
    SELECT unidade, SUM(total) AS total_alunos
    FROM institutos
    WHERE tipo_unidade = 'A - Ensino e Pesquisa' AND subcategoria = 'Graduação'
    GROUP BY unidade
) AS t1 ON i.unidade = t1.unidade
JOIN (
    SELECT unidade, SUM(total) AS total_alunas
    FROM institutos
    WHERE tipo_unidade = 'A - Ensino e Pesquisa' AND subcategoria = 'Graduação' AND sexo = 'Feminino'
    GROUP BY unidade
) AS t2 ON i.unidade = t2.unidade
ORDER BY participacao_feminina DESC;
