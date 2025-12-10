# Decay Protocol

**Decay Protocol** é uma reinterpretação contemporânea dos jogos do tipo **Multi-User Dungeon (MUD)**. O projeto combina comandos textuais, interface gráfica em **Unity** e narrativa interativa em um ambiente cliente–servidor desenvolvido em **C++**. A iniciativa dá continuidade ao projeto **UnMUD**, modernizando sua base e ampliando seu escopo técnico e conceitual.

## Objetivo

O projeto tem como objetivo explorar formas de modernizar MUDs clássicos, preservando sua essência textual, mas integrando elementos visuais, estruturais e narrativos adequados às expectativas de jogadores contemporâneos.  
Foi desenvolvido como Trabalho de Conclusão de Curso em Engenharia de Software na Universidade de Brasília (UnB), resultando em um protótipo funcional, avaliado tecnicamente e por meio de testes com usuários:contentReference[oaicite:0]{index=0}.

## Principais Funcionalidades

- **Cliente Unity e terminal textual integrado**  
  Interface gráfica minimalista com painel de saída, campo de comandos e indicadores de status. A comunicação com o servidor ocorre via **sockets TCP**, permitindo interação em tempo real:contentReference[oaicite:1]{index=1}.

- **Sistema de classes jogáveis**  
  Implementação de arquétipos com atributos distintos, proporcionando variação estratégica entre estilos de jogo.

- **Mecânica de corrupção por área**  
  Cada região do mundo possui um nível de corrupção que altera o comportamento de inimigos e a estabilidade do jogador:contentReference[oaicite:2]{index=2}.

- **Mapa em camadas e progressão regional**  
  Estrutura de mundo dividida em zonas, como Núcleo Inicial, Malha Urbana Estática, Setor Florestal Procedural e Núcleo Abissal, com ambientações e desafios progressivos.

- **Sistema de socialização (em desenvolvimento)**  
  Núcleo funcional de amizades entre jogadores, com estrutura prevista para grupos e clãs, visando ampliar a colaboração e a dimensão social da experiência:contentReference[oaicite:3]{index=3}.

## Arquitetura

A arquitetura é composta por três camadas principais:

**Servidor C++ (baseado no UnMUD)**  
Responsável pela lógica de jogo, persistência e comunicação em rede. O código foi modernizado, modularizado e adaptado às diretrizes atuais da linguagem:contentReference[oaicite:4]{index=4}.

**Cliente Unity (C#)**  
Responsável pela interface visual, interpretação de comandos e exibição do estado do jogo. Utiliza **TextMeshPro**, **Canvas** e scripts de gerenciamento de sessão e eventos:contentReference[oaicite:5]{index=5}.

**Banco de Dados PostgreSQL**  
Gerencia as entidades persistentes, incluindo jogadores, itens, inimigos, áreas e conexões de amizade. Os scripts SQL incluem tabelas, chaves estrangeiras e dados iniciais para testes.

## Tecnologias Utilizadas

- **Linguagens:** C++, C#  
- **Motor:** Unity  
- **Banco de dados:** PostgreSQL  
- **Infraestrutura:** Docker, Docker Compose  
- **Qualidade de código:** GoogleTest, Cppcheck, Clang-Tidy, SonarQube, GitHub Actions:contentReference[oaicite:6]{index=6}.

## Execução do Projeto

### Pré-requisitos

- Docker e Docker Compose instalados  
- Unity (versão compatível com o cliente do projeto)

### Inicialização

1. Clone o repositório:
   ```bash
   git clone https://github.com/MarianaPRio/Decay.git
   cd Decay

2. Abrir o cliente Unity, configurar o endereço IP e porta do servidor nos scripts de conexão (se necessário).

3. Executar a cena principal no Unity e interagir com o jogo por meio do terminal e da interface gráfica.

## Organização do Repositório

- `MUDGameProgramming/` – código do servidor em C++  
- `Unity/` – cliente gráfico do jogo em Unity (nome da pasta pode variar conforme sua organização local)  
- `SQL/` – scripts de criação e população do banco de dados  
- `docs/` – documentação complementar e notas técnicas  
- `Logs/` – registros de execução e depuração  


## Avaliação e Resultados

O protótipo foi utilizado em testes com jogadores, que percorreram o fluxo inicial de jogo (login, movimentação, combate e interação pela interface gráfica) e responderam a um questionário estruturado.

De forma geral, os resultados indicaram:

- boa aceitação da proposta de modernização de um MUD clássico;  
- clareza dos comandos e legibilidade da interface;  
- estabilidade técnica durante as sessões de teste;  
- interesse em maior aprofundamento narrativo, mais variedade de inimigos e mais feedbacks visuais.

Esses resultados reforçam o potencial do Decay Protocol como base para estudos e para evolução futura do sistema.

## Trabalhos Futuros

Entre as possibilidades de continuidade, destacam-se:

- expansão do conteúdo narrativo e das regiões do mapa;  
- implementação completa de grupos e clãs;  
- inclusão de novos inimigos, itens e mecânicas de progressão;  
- enriquecimento de feedbacks visuais e efeitos relacionados à corrupção por área;  
- disponibilização do servidor em ambiente público para testes com maior número de jogadores.

## Referência Acadêmica

Monografia:

**Decay Protocol: modernização de MUDs clássicos com cliente Unity e servidor em C++**  
Curso de Engenharia de Software – Universidade de Brasília (UnB), 2025.

O trabalho parte da base do projeto **UnMUD** e explora o Decay Protocol como estudo de caso em modernização de MUDs, integrando terminal textual, interface gráfica e novas mecânicas de jogo.
