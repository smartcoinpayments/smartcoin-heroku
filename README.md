# Smartcoin com Heroku
Como enviar cobranças do Smart Checkout para a [Smartcoin](https://smartcoin.com.br/) via [Heroku](https://www.heroku.com/)

Este projeto demo permitirá que você repasse o request do Smart Checkout para o seu servidor e envia a cobrança (transação), de forma segurança, para a Smartcoin.

### Passos:
**1)** Clone este projeto, entre na pasta criada (provavelmente smartcoin-heroku) e apague a pasta .git/ (rm -rf .git/).

**2)** O arquivo ./lib/checkout.rb é onde o request do Smart Checkout é recebido e a cobrança (Charge) é enviada para a Smartcoin via biblioteca Ruby (veja código exemplo abaixo):

````ruby
post '/' do
  SmartCoin.api_key('pk_test_407d1f51a61756')
  SmartCoin.api_secret('sk_test_86e4486a0078b2')

  #você pode fazer algo antes realizar a chamada para a cobrança na Smartcoin
  charge = SmartCoin::Charge.create(params)
  #você pode verificar se a cobrança foi aceito

  charge.to_json
end
````

### Plus
Na versão gratuita do Heroku, com apenas um Dyno, o servidor, após alguns minutos de inatividade, irá dormir e voltará apenas a ativa quando um novo request for feito. Apesar do servidor processar normalmente essas chamada, como ele estava dormindo, esse tempo de acordar (alguns segundos), pode levar a um experiência ruim para o comprador (que teve que esperar alguns segundos a mais). Para evitar isso, basta seguir esses três passo abaixo e agendar com escalonador (scheduler) para realizar a tarefa dyno_ping:

**1)** Primeiro vá no seu projeto no Heroku, entre em configurações (Settings) e clique no botão 'Reveal Config Vars'.  Será exibida todas as variáveis de ambientes que forma configuras. Clique no botão 'Edit' e preencha os campos KEY com PING_URL e VALUE com https://sua_url_da_app_do_heroku/ping, por fim no botão + para salvar;

**2)** Feito isso vá para a seção 'Resources' e clique no link 'Get more addons...'. Na página com a lista de addons procure por 'Heroku Scheduler' e adicione esse addon no seu projeto;

**3)** Por fim, volte para a seção 'Resources' e entre no addon 'Heroku Scheduler', preencha o campo task com 'rake dyno_ping' e configure para tarefa para se realizada de hora em hora. Salve e pronto.

Agora, de hora em hora o Heroku irá fazer um ping na URL configurada e não deixará o servidor dormir, evitando que o comprador tenha que esperar alguns segundos a mais e melhorando a experiência de compra.
