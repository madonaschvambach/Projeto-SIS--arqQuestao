      $set sourceformat"free"

      *>divisão de identificação do programa
       identification division.
       program-id. "P15SISC20".
       author. "Madona Schvambach".
       installation. "PC".
       date-written.  06/08/2020.
       date-compiled. 06/08/2020.



      *>divisão para configuração do ambiente
       environment division.
       configuration section.
           special-names. decimal-point is comma.


      *>declaração dos recursos externos
       input-output section.
       file-control.

       i-o-control.


      *>declaração de variáveis
       data division.

      *>variaveis de arquivos
       file section.


      *>----Variaveis de trabalho
       working-storage section.


       01  f-tela-questoes is external-form.       *>tela inicial para entrada de daos
           05  f-chave-questao.
               10  f-disciplina-id                 pic 9(03)   identified by "f-disciplina-id".
               10  f-questao-id                    pic 9(05)   identified by "f-questao-id".
           05  f-pergunta                          pic x(360)  identified by "f-pergunta".
           05  f-resposta-a                        pic x(360)  identified by "f-resposta-a".
           05  f-resposta-b                        pic x(360)  identified by "f-resposta-b".
           05  f-resposta-c                        pic x(360)  identified by "f-resposta-c".
           05  f-resposta-d                        pic x(360)  identified by "f-resposta-d".
           05  f-resposta-e                        pic x(360)  identified by "f-resposta-e".
           05  f-gabarito                          pic x(01)   identified by "f-gabarito".
           05  f-opcao-salvar                      pic x(02)   identified by "f-opcao-salvar".
           05  f-opcao-consultar                   pic x(02)   identified by "f-opcao-consultar".
           05  f-opcao-deletar                     pic x(02)   identified by "f-opcao-deletar".
           05  f-confirma                          pic x(06)   identified by "f-hd-confirma".
           05  f-msn1                              pic x(50)   identified by "f-hd-msn1".
           05  f-operacao                          pic x(02)   identified by "f-hd-operacao".
           05  f-msn2                              pic x(50)   identified by "f-hd-mens2".


       01  ws-tela-questoes.
           05  ws-chave-questao.
               10  ws-disciplina-id                pic 9(03).
               10  ws-questao-id                   pic 9(05).
           05  ws-pergunta                         pic x(360).
           05  ws-resposta-a                       pic x(360).
           05  ws-resposta-b                       pic x(360).
           05  ws-resposta-c                       pic x(360).
           05  ws-resposta-d                       pic x(360).
           05  ws-resposta-e                       pic x(360).
           05  ws-gabarito                         pic x(01).
           05  ws-opcao-salvar                     pic x(02).
           05  ws-opcao-consultar                  pic x(02).
           05  ws-opcao-deletar                    pic x(02).
           05  ws-confirma                         pic x(06).
           05  ws-msn1                             pic x(50).
           05  ws-operacao2                        pic x(02).
           05  ws-msn2                             pic x(50).


                                                   *> tela de retorno das variaveis de entrada
       01  f-r-tela-questoes-retorno               is external-form identified by "tela_cadastro_questoes_retorno.html".
           05  f-r-disciplina-id                   pic 9(03)   identified by "f-disciplina-id".
           05  f-r-questao-id                      pic 9(05)   identified by "f-questao-id".
           05  f-r-pergunta                        pic x(360)  identified by "f-pergunta".
           05  f-r-resposta-a                      pic x(360)  identified by "f-resposta-a".
           05  f-r-resposta-b                      pic x(360)  identified by "f-resposta-b".
           05  f-r-resposta-c                      pic x(360)  identified by "f-resposta-c".
           05  f-r-resposta-d                      pic x(360)  identified by "f-resposta-d".
           05  f-r-resposta-e                      pic x(360)  identified by "f-resposta-e".
           05  f-r-gabarito                        pic x(01)   identified by "f-gabarito".
           05  f-r-opcao-salvar                    pic x(02)   identified by "f-opcao-salvar".
           05  f-r-opcao-consultar                 pic x(02)   identified by "f-opcao-consultar".
           05  f-r-opcao-deletar                   pic x(02)   identified by "f-opcao-deletar".
           05  f-r-confirma                        pic x(06)   identified by "f-hd-confirma".
           05  f-r-msn1                            pic x(50)   identified by "f-hd-msn1".
           05  f-r-operacao2                       pic x(02)   identified by "f-hd-operacao".
           05  f-r-msn2                            pic x(50)   identified by "f-hd-mens2".



       01  ws-controle.
           05  ws-c-operacao                    pic x(02).
               88 ws-c-salvar                   value "SA".
               88 ws-c-consultar-um             value "CO".
               88 ws-c-consultar-varios         value "CN".
               88 ws-c-consultar-todos          value "CT".
               88 ws-c-excluir                  value "DE".
           05  ws-c-confirmacao                 pic x(06).
               88 ws-c-confirma                 value "?".
               88 ws-c-confirmado               value "S".
               88 ws-c-não-confirmado           value "N".
           05  ws-c-msn1                        pic x(50).
           05  ws-c-retorno.
               15  ws-c-msn-erro-pmg            pic x(09).
               15  ws-c-msn-erro-offset         pic 9(03).
               15  ws-c-return-code             pic 9(02).
               15  ws-c-msn-erro-cod            pic x(02).
               15  ws-c-msn-erro-text           pic x(50).


      *>----Variaveis para comunicação entre programas
       linkage section.




      *>----Declaração de tela
       screen section.


      *>declaração do corpo do programa
       procedure division.

       0000-controle section.


           perform 1000-inicializa.
           perform 2000-processamento.
           perform 3000-finaliza.


           .
       0000-controle-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Procedimentos de inicialização
      *>------------------------------------------------------------------------
       1000-inicializa section.

           .
       1000-inicializa-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Processamento principal
      *>------------------------------------------------------------------------
       2000-processamento section.


           accept  f-tela-questoes                 *>leitura da página

           if   f-confirma = "true" then           *>se botão da mensagem "confirmar..." for true
                move "S"                           to ws-c-confirmacao
                move f-operacao                    to ws-c-operacao
           else
                move "N"                           to ws-c-confirmacao
           end-if


           if   f-opcao-salvar = "SA" then
                move f-opcao-salvar                to ws-c-operacao
           end-if

           if   f-opcao-consultar = "CO" then
                move f-opcao-consultar             to ws-c-operacao
           end-if

           if   f-opcao-deletar = "DE" then
                move f-opcao-deletar               to ws-c-operacao
           end-if

           move    f-tela-questoes                 to ws-tela-questoes

           call "P05SISC20" using ws-tela-questoes,*>chama o programa que contém manipulação dos arquivos
                                   ws-c-operacao


           move    ws-c-msn-erro-text              to ws-msn2   *>move o conteúdo da P05 para as variaveis de trabalho deste programa
           move    ws-c-confirmacao                to ws-confirma
           move    ws-c-msn1(1:2)                  to ws-operacao2
           move    ws-c-msn1(4:46)                 to ws-msn1
           move    ws-tela-questoes                to f-r-tela-questoes-retorno *>move os conteúdos para a tela 2 (retorno)

           display f-r-tela-questoes-retorno


           .
       2000-processamento-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Finalização Normal
      *>------------------------------------------------------------------------
       3000-finaliza section.

           stop run.

           .
       3000-finaliza-exit.
           exit.
