<h1> Projeto de arquitetura de computadores 4° ciclo
 </h1> 

## Descrição do Projeto
O projeto denominado "Burguer FEI" consiste em uma hamburgueria de conceito simples, onde os clientes podem fazer suas escolhas de itens do cardápio e efetuar pedidos de forma prática. Para facilitar essa interação, as opções de compra serão exibidas em um visor LCD 16x2. O menu com as opções de produtos será acessado após o cliente pressionar o botão correspondente ao número 8 no teclado.

Após o menu ser apresentado, os clientes poderão selecionar seus pedidos. Visto que a hamburgueria oferece apenas seis produtos, o cliente deve inserir o número correspondente (de 1 a 6) no teclado para selecionar o produto desejado. Assim que a escolha for feita, o produto escolhido será exibido no visor e o cliente terá a opção de retornar ao menu para escolher outros itens.

As escolhas feitas pelos clientes serão armazenadas na memória, permitindo que eles visualizem seu pedido a qualquer momento. Além disso, durante a execução do programa, um motor estará em funcionamento para indicar visualmente ao cliente que o menu está operando corretamente e em pleno funcionamento.

## Fluxograma / Diagrama
![image](https://github.com/user-attachments/assets/39e0dca4-906b-4b18-ab4f-8c5a9d3719a8)

## Desenhos esquemáticos
![image](https://github.com/user-attachments/assets/3e8dfda2-3e10-40f5-9562-d83061932611)

## Imagens da simulação realizada na IDE

# Na fase inicial do projeto, a tela do display permanece vazia, uma vez que o usuário ainda não pressiona nenhuma tecla. No entanto, já é visível o funcionamento do motor.
![image](https://github.com/user-attachments/assets/2c9af236-312f-4c9a-a601-6800b7f61656)

# Após o usuário pressionar uma tecla, o display exibe a tela inicial, solicitando que o usuário faça o seu pedido.
![image](https://github.com/user-attachments/assets/110e28af-383b-4c46-b6d4-22c21c7b51c8)

# Dois pedidos que aparecem logo embaixo para o usuário escolher.
![image](https://github.com/user-attachments/assets/eeb1b32b-de2b-49f4-9dca-802a755f23e3)

# Esta é a etapa final dos pedidos, após a qual o processo reinicia desde o início.
![image](https://github.com/user-attachments/assets/2a9d53b0-c779-4dcd-9231-9f601ce5747c)

# Demonstração de como os produtos são armazenados na memória, com a linha de endereço de 20 a 70, contendo os 6 produtos representados de acordo com a tabela ASCII em hexadecimal.
![image](https://github.com/user-attachments/assets/82a20a7f-4270-4d1f-86a2-2b829421dcf6)

# Os endereços 2FH, 3FH, 4FH, 5FH, 6FH e 7FH são utilizados para armazenar a quantidade de produtos comprados de cada tipo pelo indivíduo. No caso específico apresentado, a pessoa adquiriu 2 X-burgers (2FH), 1 X-salada (3FH), 1 suco natural (6FH) e 2 refrigerantes Coca-Cola (7FH).
![image](https://github.com/user-attachments/assets/6c38bed2-ce95-493c-b6d8-17cc1f1c7902)

# Exemplo de como fica o programa com a tela cheia.
![image](https://github.com/user-attachments/assets/e7b0adac-d983-49fc-9222-240fab7197bf)


## Ferramentas utilizadas:
<h3><a href="https://edsim51.com/">EDSIM51</a></h3>
