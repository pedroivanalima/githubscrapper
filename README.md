# README

Durante este teste tentei aplicar técnicas distintas para explorar recursos de programação diversos.

Optei por trabalhar com 3 modelos:

Perfil, armazenando as informações do perfil, da forma mais simples possível, campos fixos e o único mandatório é inserido pelo usuário.  A ideia principal é que cada pagina do github tenha um único perfil, isto é feito em uma relação 1:1 com link.

Link, que é o link do github com sua url original e sua versão encurtada.  Mesmo armazenando a versão curta que irá levar para a url_original, é necessário manter a informação da url_original no nosso banco.  Também diminui as falhas caso o serviço de url encurtada não esteja funcionando, nesse segundo caso o usuário poderia acessar os perfis na nossa página, mas não criar novos e nem clicar no link.  Mais sobre este assunto na sessão de url_curta.

Busca, o registro para busca em si.  Se relaciona com perfil numa relação 1 perfil : N buscas.  É relacionado ao Job que executa esta busca, guarda informações como última execução e status.  Permite também posteriormente ser trabalhado para ter ainda mais informações, como url buscada, tempo gasto em cada parte, etc.  É criada quando um novo perfil é criado, toda vez que a url_original é alterada e também por ação do usuário. 



URL_CURTA:
Tentei alguns sites como: bitly.com , l8.nu, free-url-shortener.  O que com facilidade tive sucesso gerando a url pelo console foi com o l8.nu, porém não consegui seguir a url de forma automática (caiu num anti-phishing).  O serviço é o padrão do sistema.  Sua URL está no .env como servico_encurtamento e deve ser https://l8.nu.  Para gerar uma falha automática, altere esta url e o programa irá para o seu default que é ele mesmo gerar uma url_curta para o site fretadissimo.com.

Não conheço bem o serviço da l8, e não sei o quanto confiar em serviços gratuitos, tanto em sua estabilidade como também nos avisos antes de mudanças, que podem fazer o programa quebrar.  Em especial este que a resposta é feita com um parse num .html que é mais sucetível a mudanças.

Conceitos/tecnologias utilizadas:

Serviço de Busca:

Para o serviço de busca implementei um serviço e chamei o job, permitindo que outras partes usem este serviço caso necessário, sem necessariamente depender do job.  O método job.perform irá performar bloqueando a chamada em desenvolvimento, mas o mesmo não ocorre em produção, indo para o serviço de filas, provavelmente redis + sidekiq.

Toda busca foi feita utilizando a api pública.  A parte de contribuições não foi encontrada na API pública e também não consegui buscar com curl/faraday.  Ignorei esta parte e é um dos TODOs, ou utilizar o github CLI com uma chave de aplicação (preferível) ou fazer um webscrapping utilizando alguma ferramenta que processe javascript (capybara talvez).

PerfilInteractor:

Para abstrair a complexidade de criação de novas buscas durante a criação do perfil, foi feito um interactor, evitando que uma atualização na classe link comece a executar callbacks para busca, o que pode levar a erros não esperados.

Callbacks em model/link.rb

Porém, links possui diversas callbacks relacionadas ao seu próprio funcionamento, garantindo a unicidade da url e também a criação da url_curta.  Callbacks podem dificultar a criação em massa de registros, devemos usar com parcimônia.  Outro cuidado, que apesar de não ser o caso, eventos after_save podem não ter sido executados imediatamente após a criação, podendo gerar falhas no sistema.

Helper para o front-end em buscas_helper.rb, dando o código da bolinha de status.

Specs:

Utilizei rspec com factory_bot.  Para não tornar o teste ainda mais extenso, testei 2 classes:
Modelo Link, é o modelo com mais lógica relacionada.
Perfil Controller, é o único controller utilizado na aplicação, testei get para o index, show/edit e o create.  Acho que com isso mostra o principal do que tem para ser utilizado em rspec, como utilização da factory, mocks, expect, assert, etc.

Para o front-end utilizei:
    partials
    Um javascript no edit do perfil, atualizando o texto embaixo do avatar ao modificar o nome
    um único arquivo .css, não achei-o tão grande a ponto de dividir em pedaços menores coerentes
    Ainda no css, para aspecto de tabelas fiz uso de display-flex e também display-table, onde se encaixaram melhor
    o javascript ficou como <script> no final da tela mesmo, não é o mais elegante mas também uma alternativa de solução e movê-lo é o mesmo que com o .css
    Confirmação de delete foi feita com o turbo
    Coloquei um asset do snoopy, que inclusive acho que está em uso público devido a idade.

O que melhorar (vulgos TODOs)
- Aplicação foi majoritariamente gerada com scaffold e não limpei os arquivos não utilizados.  Inclusive, os arquivos de migração foram alterados sem migrações de alteração, então algumas áreas do scaffold poderão nem funcionar
- URL já cadastrada retorna um erro de unicidade.  Poderia retornar o perfil a qual ela é relacionada
- Não tem usuários, então todo mundo pode alterar todos os registros.  Poderiamos ter usuários, com toda ação que altera (tanto perfil quanto busca) somente podendo ser feita pelo usuário dono do registro
- Buscas tem controller gerado pelo scaffold mas não toquei nele, e é um que faz sentido ter pelo menos algumas funcionalidades como index e show
- Busca tem apenas 1 status de execução 'processando', uma atividade mais demorada aceitaria vários passos
- Buscar a informação de contribuições
- ApplicationRecord está forçando timezone -3, com certeza existe uma solução melhor para isto
- Perfil.procurar poderia utilizar pg_search com tsvector e tsarray, tem um custo maior de armazenamento e processamento da inserção/atualização mas é um índice que funciona muito bem
- Mensagens de erro estão variadas em inglês, ou português