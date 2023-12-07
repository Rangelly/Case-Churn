-- Encontrando a data mais recente para descobrir quais clientes deram Churn.
-- Todos os clientes que transacionaram após o dia 30/10/2019 são considerados Churn.
SELECT
	*
FROM
	preditiva.db_churn.fato_churn
ORDER BY DataUltimaTransacao DESC
------------------------------------------------------------------------------------------

-- TRATAMENTO DOS DADOS, CRIANDO CONSULTA COM AS VARIÁVEIS DE INTERESSE -- 
SELECT 
clientid,
Estado,
Gênero,
Score_Credito AS S_Credito,
Gênero,
Idade,
Qte_Categorias AS Qte_Categ,
Usa_Crédito,
AnosDeCasa,
P_Fidelidade,
Pedidos_Acum,
CASE
        WHEN Churn = 'Churn' THEN 1
        ELSE 0
    END AS Churnbool
FROM
(
SELECT
	dim.clientid,
    dim.Estado,
    dim.Gênero,
    dim.Idade,
    dim.Tempo_Cliente AS AnosDeCasa,
    dim.Qte_Categorias,
    dim.Usa_Cartao_Credito AS Usa_Crédito,
    dim.Programa_Fidelidade AS P_Fidelidade,
    dim.Score_Credito,
    -- APLIQUEI UM DATEDIFF PARA SABER OS CLIENTES QUE NÃO TRANSACIONARAM A PARTIR DA DATA REFERÊNCIA--
    DATEDIFF(DAY, fato.DataUltimaTransacao, '2019-10-30') AS Dias,
    -- CLIENTES COM MAIS DE 30 DIAS SEM TRANSACIONAR SÃO CONSIDERADOS COM "CHURN"--
    --ABAIXO APLIQUEI UMA CONDIÇÃO PARA IDENTIFICAR OS CLIENTES QUE DERAM CHURN--
    CASE
        WHEN DATEDIFF(DAY, fato.DataUltimaTransacao, '2019-10-30') > 30 THEN 'Churn'
        ELSE 'Não Churn'
    END AS Churn,
    -- TRATANDO DADOS COM CASAS DECIMAIS INCORRETAS ABAIXO -- 
     ROUND(TRY_CAST(Sum_Pedidos_Acumulados AS FLOAT), 0) AS Pedidos_Acum
     FROM
    preditiva.db_churn.dim_clientes AS dim
    -- FIZ O JOIN PARA PEGAR A DATA DA ÚLTIMA COMPRA NA TABELA FATO --
INNER JOIN 
    preditiva.db_churn.fato_churn AS fato
ON 
    dim.ClientId = fato.ClientId
    ) AS Tabelatratada
ORDER BY AnosDeCasa DESC;




    
    












    
    


	


	




	

