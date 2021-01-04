# PLOG 2020/2021  

## Grupo T3_Gold_Star_1

| Name             | Number    | E-Mail             |
| ---------------- | --------- | ------------------ |
| Daniel Garcia Lima Sarmento da Silva    | 201806524 |up201806524@fe.up.pt|
| Mariana Almeida Truta    | 201806543 |up201806543@fe.up.pt|

[Exemplos do puzzle Gold Star](https://erich-friedman.github.io/puzzle/star/)

----

## Instalação e Execução

### Instalação SICStus Prolog

* [Linux](https://sicstus.sics.se/download4.html#unix)
* [Windows](https://sicstus.sics.se/download4.html#win32)

### Execução

Primeiro é necessário:

* Executar SICStus Prolog;
* Ir para `File > Consult` e selecionar o ficheiro [main.pl](main.pl)
* *Alternativamente*: escrever na consola `consult('path\to\main.pl')`.

Para testar a resolução de puzzles Gold Star, existem os seguintes predicados:

* *findSolution/1*: sendo fornecido o número de pontas do puzzle (3 a 6 pontas), este predicado gera um puzzle aleatório, resolve-o e escreve na consola do SICStus a solução encontrada. Exemplo: *findSolution(3)*;
* *solveStar/3*: este predicado encontra para uma determinada lista de operadores uma ou mais soluções. É necessário fornecer, por esta ordem, o número de pontas do puzzle, a lista de operadores do puzzle e um número que indica se se pretende uma só solução ou todas as que forem possíveis (1 ou 0, respetivamente). Exemplo: *solveStar(3, [-,/,+,+,-,-], 1)*.
