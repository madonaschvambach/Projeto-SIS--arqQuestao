      $set sourceformat"free"
      *>----Divisão de identificação do programa
       identification division.
       program-id. "P05SISC20".
       author. "Madona Schvambach".
       installation.  "PC".
       date-written.  03/08/2020.
       date-compiled. 03/08/2020.

      *>----Divisão para configuração do ambiente
       environment division.
       configuration section.
       special-names.
       decimal-point is comma.

      *>----Declaração dos recursos externos
       input-output section.
       file-control.


           select arq-questao assign to "arq-questao.txt"
           organization is indexed
           access mode is dynamic
           lock mode is automatic *>manual with lock on multiple records
           record key is fl-chave-questao
           alternate key is fl-id-disci with duplicates
           file status is ws-fs-arqQuestao.


       i-o-control.


      *>----Declaração de variáveis
       data division.

      *>----Variáveis de arquivos
       file section.

       fd  arq-questao.
       01  fl-questao.

           05  fl-chave-questao.
               10  fl-id-questao                   pic 9(05).
               10  fl-id-disci                     pic 9(03).
           05  fl-pergunta                         pic x(360).
           05  fl-resposta-a                       pic x(360).
           05  fl-resposta-b                       pic x(360).
           05  fl-resposta-c                       pic x(360).
           05  fl-resposta-d                       pic x(360).
           05  fl-resposta-e                       pic x(360).
           05  fl-gabarito                         pic x(01).


      *>----Variáveis de trabalho
       working-storage section.

       77  ws-fs-arqQuestao                        pic x(02).
       77  ws-opcao-entrada                        pic x(02).

       01  ws-questao.
           05  ws-chave-questao.
               10  ws-id-questao                   pic 9(05).
               *>10  ws-chave-id-disciplina.
               10  ws-id-disc                      pic 9(03).
           05  ws-pergunta                         pic x(360).
           05  ws-resposta-a                       pic x(360).
           05  ws-resposta-b                       pic x(360).
           05  ws-resposta-c                       pic x(360).
           05  ws-resposta-d                       pic x(360).
           05  ws-resposta-e                       pic x(360).
           05  ws-gabarito                         pic x(01).


       01  ws-controle.
           05  ws-operacao                         pic x(02).
               88 ws-salvar                        value "SA".
               88 ws-consultar-um                  value "C1".
               88 ws-consultar-varios              value "CN".
               88 ws-consultar-todos               value "CT".
               88 ws-excluir                       value "DE".
           05  ws-confirmacao                      pic x(06).
               88 ws-confirmar                     value "?".
               88 ws-confirmado                    value "S".
               88 ws-não-confirmado                value "N".
           05  ws-msn1                             pic x(50).
           05  ws-retorno.
               10  ws-msn-erro-pmg                 pic x(09).
               10  ws-msn-erro-offset              pic 9(03).
               10  ws-return-code                  pic 9(02).
               10  ws-msn-erro-cod                 pic x(02).
               10  ws-msn-erro-text                pic x(50).



       *>como chamar o copy_var... : copy (nome do arquivo).

      *>----Variáveis para comunicação entre programas
       linkage section.


       01  lnk-tela-questoes.                      *>linkage tela entrada dados questoes
           05  lnk-chave-questao.
               10  lnk-disciplina-id               pic 9(03).
               10  lnk-questao-id                  pic 9(05).
           05  lnk-pergunta                        pic x(360).
           05  lnk-resposta-a                      pic x(360).
           05  lnk-resposta-b                      pic x(360).
           05  lnk-resposta-c                      pic x(360).
           05  lnk-resposta-d                      pic x(360).
           05  lnk-resposta-e                      pic x(360).
           05  lnk-gabarito                        pic x(01).

       01  lnk-controle.
           05  lnk-operacao                        pic x(02).
           05  lnk-confirmacao                     pic x(06).
           05  lnk-msn1                            pic x(50).
           05  lnk-retorno.
               10  lnk-msn-erro-pmg                pic x(09).
               10  lnk-msn-erro-offset             pic 9(03).
               10  lnk-return-code                 pic 9(02).
               10  lnk-msn-erro-cod                pic x(02).
               10  lnk-msn-erro-text               pic x(50).

       *>------------------------------------------------------------------------
       *> controle
       *>---------------------------------------------------------------------
       procedure division using lnk-tela-questoes,
                                lnk-controle.

       0000-controle section.


           perform 1000-inicializa
           perform 2000-processamento
           perform 3000-finaliza


           .
       0000-controle-exit.
           exit.


      *>------------------------------------------------------------------------
      *> inicializacao normal
      *>------------------------------------------------------------------------
       1000-inicializa section.


           open i-o arq-questao                    *> open i-o abre o arquivo para leitura e escrita
           if   ws-fs-arqQuestao  <> 00 and ws-fs-arqQuestao <> "05" then
                move "P5SISC20"                         to ws-msn-erro-pmg
                move 1                                  to ws-msn-erro-offset
                move ws-fs-arqQuestao                   to ws-msn-erro-cod
                move "Erro ao incicializar arqQuestao"  to ws-msn-erro-text
                perform 9000-finaliza-anormal
           end-if

                                                   *>move as variaveis entre comuniçação dos programas, paras de variaveis deste
           move lnk-controle                       to ws-controle
           move lnk-tela-questoes                  to ws-questao

           .
       1000-inicializa-exit.
           exit.



      *>------------------------------------------------------------------------
      *> processamento normal
      *>------------------------------------------------------------------------
       2000-processamento section.

           evaluate ws-operacao
               when = "SA"
                   perform 2100-salvar-dados
               when = "CO"
                   perform 2200-b-um-registro
               when = "CN"
                   perform 2300-b-varios-registros
               when = "CT"
                   perform 2400-b-todos-registros
               when = "DE"
                   perform 2500-deletar-dados
               when other
                   move "Voce inseriu uma operacao invalida, tente novamente" to ws-msn1
           end-evaluate

           .
       2000-processamento-exit.
           exit.


       *>------------------------------------------------------------------------
       *>  Salvar dados
       *>------------------------------------------------------------------------
       2100-salvar-dados section.


           write fl-questao                        from ws-questao *>salvo no arquivo o conteudo de ws-questao
           if   ws-fs-arqQuestao = "00" or ws-fs-arqQuestao = "02" then  *>não retornou erro de gravação no arquivo
                   move ws-fs-arqQuestao             to ws-msn-erro-cod
                   move "Registro salvo com sucesso!" to ws-msn-erro-text
           else
                if   ws-fs-arqQuestao = 22 then    *>registro já existe
                     if   ws-confirmacao = "S" then
                          move "N"                 to ws-confirmacao
                          rewrite fl-questao       from ws-questao *>sobreescreve os dados no arquivo
                          if   ws-fs-arqQuestao = "00" then
                               move ws-fs-arqQuestao                   to ws-msn-erro-cod
                               move "Registro alterado com sucesso!"   to ws-msn-erro-text
                          else
                               move "P5SISC20"                 to ws-msn-erro-pmg
                               move 1                          to ws-msn-erro-offset
                               move ws-fs-arqQuestao           to ws-msn-erro-cod
                               move "Erro ao alterar registro" to ws-msn-erro-text
                               perform 9000-finaliza-anormal
                          end-if
                     else
                          move "?"                                    to ws-confirmacao
                          move "SA-Confirma a Alteracao de cadastro?" to ws-msn1
                     end-if
               else
                    move "P5SISC20"                    to ws-msn-erro-pmg
                    move 2                             to ws-msn-erro-offset
                    move ws-fs-arqQuestao              to ws-msn-erro-cod
                    move "Erro ao escrever registro!"  to ws-msn-erro-text
                    perform 9000-finaliza-anormal
               end-if
           end-if


           .
       2100-salvar-dados-exit.
           exit.



       *>------------------------------------------------------------------------
       *>  Buscar um registro
       *>------------------------------------------------------------------------
       2200-b-um-registro section.


           move ws-chave-questao                   to fl-chave-questao
           start arq-questao key = fl-chave-questao
           read  arq-questao
           if   ws-fs-arqQuestao = "00"
                move fl-questao                    to ws-questao
                move ws-fs-arqQuestao              to ws-msn-erro-cod
                move "Registro lido com sucesso!"  to ws-msn-erro-text
                move fl-questao to ws-questao
           else
                if   ws-fs-arqQuestao = 23
                     move ws-fs-arqQuestao         to ws-msn-erro-cod
                     move "Codigo inexistente!"    to ws-msn-erro-text
               else
                    move "P5SISC20"                to ws-msn-erro-cod
                    move 3                         to ws-msn-erro-offset
                    move ws-fs-arqQuestao          to ws-msn-erro-cod
                    move "Erro ao ler registro!"   to ws-msn-erro-text
                    perform 9000-finaliza-anormal
               end-if
           end-if


           .
       2200-b-um-registro-exit.
           exit.


       *>------------------------------------------------------------------------
       *>  Buscar varios registros
       *>------------------------------------------------------------------------
       2300-b-varios-registros section. *>BUSCAR TODOS OS REGISTROS DA QUESTAO E DISCIPLINA
                                        *>pode acontecer de fazer a mesma prova da disciplina várias vezes para recuperar/
                                        *>tirar uma nota maior


           move lnk-chave-questao                  to fl-chave-questao
           start arq-questao key = fl-chave-questao
           read  arq-questao
           if   ws-fs-arqQuestao = "00"
                perform until ws-fs-arqQuestao <> "10" or fl-id-disci > "002" *>chave de entrada
                     read arq-questao next
                     if   ws-fs-arqQuestao = "00" or ws-fs-arqQuestao = "02" then
                          move fl-questao to ws-questao
                          *>correspondente (definir uma tabela interna)
                     else
                          if   ws-fs-arqQuestao <> "10"
                               move "P5SISC20"             to lnk-msn-erro-pmg
                               move 4                      to lnk-msn-erro-offset
                               move ws-fs-arqQuestao       to lnk-msn-erro-cod
                               move "Erro ao ler registro" to lnk-msn-erro-text
                               perform 9000-finaliza-anormal
                          end-if
                     end-if
               end-perform
           else
                if   ws-fs-arqQuestao = "23"
                     move "Codigo Inexistente!"    to lnk-msn-erro-text
                     move ws-fs-arqQuestao         to lnk-msn-erro-cod
                else
                     move "P5SISC20"               to lnk-msn-erro-pmg
                     move 5                        to lnk-msn-erro-offset
                     move ws-fs-arqQuestao         to lnk-msn-erro-cod
                     move "Erro ao Ler Registro!"  to lnk-msn-erro-text
                     perform 9000-finaliza-anormal
                end-if
           end-if


           .
       2300-b-varios-registros-exit.
           exit.


       *>------------------------------------------------------------------------
       *>  Buscar todos os registros
       *>------------------------------------------------------------------------
       2400-b-todos-registros section.


           perform until ws-fs-arqQuestao = "10"
                read arq-questao next
                if   ws-fs-arqQuestao = "00"
                     move fl-questao to ws-questao
                     *>correspondente (definir uma tabela interna)
                     *>move fl-questao                 to lnk-tb-usuario(ws-ind)
                else
                     if   ws-fs-arqQuestao <> "10"
                          move "P5SISC20"              to lnk-msn-erro-pmg
                          move 6                       to lnk-msn-erro-offset
                          move ws-fs-arqQuestao        to lnk-msn-erro-cod
                          move "Erro ao ler registro"  to lnk-msn-erro-text
                          perform 9000-finaliza-anormal
                     end-if
                end-if
           end-perform


           .
       2400-b-todos-registros-exit.
           exit.


       *>------------------------------------------------------------------------
       *>  Deletar dados
       *>------------------------------------------------------------------------
       2500-deletar-dados section.

           move lnk-chave-questao                  to fl-chave-questao
           read arq-questao into fl-chave-questao  *>leitura indexada
           if   ws-fs-arqQuestao = "00" then
                if   ws-confirmacao = "S"
                     move "N"                      to ws-confirmacao
                     delete arq-questao            *>deletar o conteúdo do arquivo
                     if   ws-fs-arqQuestao = "00" then
                          move ws-fs-arqQuestao                   to ws-msn-erro-cod
                          move "Registro deletado com sucesso!"   to ws-msn-erro-text
                     else
                          move "P5SISC20"                 to ws-msn-erro-pmg
                          move 7                          to ws-msn-erro-offset
                          move ws-fs-arqQuestao           to ws-msn-erro-cod
                          move "Erro ao deletar registro" to ws-msn-erro-text
                          perform 9000-finaliza-anormal
                     end-if
                else
                     move "?"                                   to ws-confirmacao
                     move "DE-Confirma a exclusao do registro?" to ws-msn1
                end-if
           else
                if   ws-fs-arqQuestao = "23"
                     move ws-fs-arqQuestao         to ws-msn-erro-cod
                     move "Codigo inexistente!"    to ws-msn-erro-text
                else
                     move "P5SISC20"               to ws-msn-erro-pmg
                     move 8                        to ws-msn-erro-offset
                     move ws-fs-arqQuestao         to ws-msn-erro-cod
                     move "Erro ao ler registro!"  to ws-msn-erro-text
                    perform 9000-finaliza-anormal
                end-if
           end-if

           .
       2500-deletar-dados-exit.
           exit.


       *>------------------------------------------------------------------------
       *>  Finalização  Anormal
       *>------------------------------------------------------------------------
       9000-finaliza-anormal section.


           move lnk-msn-erro-cod                   to lnk-msn-erro-cod
           move 12                                 to ws-msn-erro-offset
           display ws-retorno
           stop run


           .
       9000-finaliza-anormal-exit.
           exit.


       *>------------------------------------------------------------------------
       *>  Finalização Normal
       *>------------------------------------------------------------------------
       3000-finaliza section.


           close arq-questao
           if   ws-fs-arqQuestao <> "00" then
                move "P5SISC20"                        to lnk-msn-erro-pmg
                move 9                                 to lnk-msn-erro-offset
                move ws-fs-arqQuestao                  to lnk-msn-erro-cod
                move "Erro ao finalizar arqQuestao!"   to lnk-msn-erro-text
                perform 9000-finaliza-anormal
           else
                move 00                            to ws-msn-erro-offset
           end-if

           move ws-controle                        to lnk-controle
           move ws-confirmacao                     to lnk-confirmacao
           move ws-questao                         to lnk-tela-questoes

           exit program


           .
       3000-finaliza-exit.
           exit.
