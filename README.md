# Smartcoin on Heroku
Processando request do Smart Checkout no [Heroku](https://www.heroku.com/)

[Heroku](https://www.heroku.com/) é uma grande platform para hospedar projetos. Principalmente projetos open source, mas também é um boa opção para hospedar projetos da sua empresa. Viste [Heroku](https://www.heroku.com/) e saiba mais!

Este projeto demo permitira que você repasse o request do Smart Checkout para um servidor seu e configure a cobrança (transação) de forma a evitar falhas de segurança. Lembre-se que processar pagamentos no browser do cliente não é 100% seguro.

Vamos
1) Clone este projeto, entre na pasta criada (provavelmente smartcoin-heroku) e apague a pasta .git/ (rm -rf .git/). Agora sim você está pronto para personalizar o seu projeto.

2) O arquivo /lib/checkout.rb é onde o request do Smart Checkout é recebido e a cobrança (Charge) é realizando com uma chamada a API da Smartcoin.

````ruby
post '/' do
  SmartCoin.api_key('pk_test_407d1f51a61756')
  SmartCoin.api_secret('sk_test_86e4486a0078b2')

  #você pode fazer algo antes realizar a chamada para a cobrança na Smartcoin

  charge = SmartCoin::Charge.create(params)
  charge.to_json
end
````

O código é muito simples e permite a realização da cobrança. É importante notar que é possível configurar os paramêtros da chamada a API para a cobrança, antes desta acontecer. Como configurar o valor (amount) atráves de id do produto passado (product_id)

````ruby
post '/' do
  SmartCoin.api_key('pk_test_407d1f51a61756')
  SmartCoin.api_secret('sk_test_86e4486a0078b2')
  product_price = { 1: 1000, 2: 2000} #os valores (amount), tem que ser passado sempre em centavos.
  params[:amount] = product_price[params[:product_id]]
  params.delete(:product_id) #o elemento product_id precisa ser removido da lista de parâmetros, porque a API da Smartcoin aceitará apenas os parametros padrões.
  charge = SmartCoin::Charge.create(params)
  charge.to_json
end
````

Desta forma, você garante a criação de uma cobrança com o valor (amount) correto, evitando alguma falha de segurança.

### Plus
Na versão gratuita do Heroku, com apenas um Dynamon, o servidor, após alguns minutos de inatividade, irá dormir e voltará apenas a ativa quando um novo request for feito. Apesar do servidor processar normalmente essas chamada, como ele estava dormindo, esse tempo de acordar (alguns segundos), pode levar a um experiência ruim para o comprador (que teve que esperar alguns segundos a mais). Para evitar isso, basta seguir esses três passo abaixo e agendar com escalonador (scheduler) para realizar a tarefa dyno_ping:

**1)** Primeiro vá no seu projeto no Heroku, entre em configurações (Settings) e clique no botão 'Reveal Config Vars'.  Será exibida todas as variáveis de ambientes que forma configuras. Clique no botão 'Edit' e preencha os campos KEY com PING_URL e VALUE com https://sua_url_da_app_do_heroku/ping, por fim no botão + para salvar;

**2)** Feito isso vá para a seção 'Resources' e clique no link 'Get more addons...'. Na página com a lista de addons procure por 'Heroku Scheduler' e adicione esse addon no seu projeto;

**3)** Por fim, volte para a seção 'Resources' e entre no addon 'Heroku Scheduler', preencha o campo task com 'dyno_ping' e configure para tarefa para se realizada de hora em hora. Salve e pronto.

Agora, de hora em hora o Heroku irá fazer um ping na URL configurada e não deixará o servidor dormir, evitando que o comprador tenha que esperar alguns segundos a mais e melhorando a experiência de compra.