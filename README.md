Este trabalho foi desafiador e ao mesmo tempo prazeroso de fazer. Desafiador
porque trabalhar no SQL Developer me deu muita dor de cabeça, desde tentar
conectar no servidor sparta da PUCRS pela minha rede remota(inúmeras idas a
mesa da professora e perguntas), limitações que nós como usuários tínhamos e
problemas com dados que muitas vezes não existiam, ou de forma rasa, sendo um
ou nenhum voo em certa região. Prazeroso pois desde o primeiro semestre do curso
venho gostando bastante das disciplinas de banco de dados, então poder trabalhar
mais com isso, tem sido bem interessante. Enfim, tentei realizar as consultas de
forma mais otimizada possível, desde a primeira etapa do trabalho, então na etapa 4
quando tínhamos que de fato otimizar o código para obter menor custo na operação,
foi bem mais complicado do que deveria ser. Um exemplo que fiquei surpreso de
forma positiva, foi a consulta C, na primeira vez que realizei a consulta(etapa 2),
obtive o seguinte custo em ordem: 233, 181, 34. Após o SQL tuning, esse custo
baixou para 90, 90 e 39. Utilizei para isso, dois índices para otimizar a junção de
reservas com os voos.

--Trabalho todo realizado no Oracle SQL Developer com acesso ao servior privado Sparta da Universidade PUCRS, ou seja, aqui estão apenas as minhas consultas que utilizei para obter os dados disponibilizados do servidor!