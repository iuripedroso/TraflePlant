## 🌿 Busca de Plantas

Interface simples para buscar informações sobre plantas a partir de um nome digitado pelo usuário.

## 📸 Estrutura da Página

A página contém:

- Cabeçalho com botão de voltar e título  
- Campo de busca  
- Botão de pesquisa com ícone  
- Área para exibir os resultados  
- Exemplo de item de planta listado  

## 🖼️ Imagens do Projeto

<div style="display: flex; gap: 10px;">
  <img src="https://raw.githubusercontent.com/iuripedroso/TraflePlant/refs/heads/main/trefle%2001.jfif" width="180">
  <img src="https://raw.githubusercontent.com/iuripedroso/TraflePlant/refs/heads/main/treflle%2002.jfif" width="180">
  <img src="https://raw.githubusercontent.com/iuripedroso/TraflePlant/refs/heads/main/trefle%2003.jfif" width="180">
  <img src="https://raw.githubusercontent.com/iuripedroso/TraflePlant/refs/heads/main/trefle%2004.jfif" width="180">
  <img src="https://raw.githubusercontent.com/iuripedroso/TraflePlant/refs/heads/main/trefle%2005.jfif" width="180">
</div>

## 🛠️ Detalhes da Implementação (Dart + Flutter + API Trefle)

A aplicação foi desenvolvida em **Flutter**, utilizando widgets como `Scaffold`, `AppBar`, `TextField`, `ListView.builder` e navegação com `Navigator.push`.  
A busca é realizada consumindo a **API do Trefle**, que retorna dados botânicos como nome científico, imagens e família.

### Principais pontos da implementação

- **Service em Dart (`trefle_service.dart`)**  
  - Utiliza `http` para fazer requisições GET.  
  - Monta a URL com token de acesso da API Trefle.  
  - Faz o parsing do JSON para modelos próprios.  

- **Modelo (`plant_model.dart`)**  
  - Converte os dados retornados pela API em objetos do tipo `Plant`.  
  - Facilita o uso das informações na interface.

- **Busca de plantas**  
  - O usuário digita o nome e aciona o botão de pesquisa.  
  - A função chama o service e retorna uma lista de plantas.  
  - Os resultados aparecem em cards com nome comum, nome científico e imagem.

- **Página de detalhes**  
  - Ao clicar em uma planta, o app abre outra tela com mais informações.  
  - Exibe imagem principal, família, gênero e demais dados recebidos da API.

- **Tratamento de erros**  
  - Mensagens caso a API não retorne resultados.  
  - Loading para melhorar a UX enquanto a requisição é feita.

