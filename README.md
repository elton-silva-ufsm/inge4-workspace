Universidade Federal de Santa Maria
Especialização em Microeletrônica
Ci Inovador

Elton Sóstenes Marques da Silva

Esse diretório apresenta detalhadamente os códigos-fonte de cada módulo utilizado no trabaçho de conclusão de curso.
O objetivo é avaliar a implementação de diferentes códigos de correção de erros para 1 e dois erros, com foco em timing.

A implementação foi feita com a biblioteca genérica de 45nm da Cadence.
Todos os módulos estudados foram implementados físicamente com o Innovus.
Os relatórios de timing foram gerados para o melhor e o pior caso.

A implementação dos principais componentes de multiplicação e divisão em GF(2^n) usam de referência o seguinte repositório:
https://github.com/Abhi04-og/BCH-15-7-2-

A implementação foi adaptada para systemVerilog, refeita para ser sintetizada em ASIC e expandida a tabela de Log e antilog para o polínomio de grau 5.
O cálculo do Berlekamp-Massey foi simplificado algebricamente para uma solução combinacional sintetizável.