README - Projeto Product App
📋 Sobre o Projeto
Este é um aplicativo Flutter que consome a API Fake Store API para exibir uma lista de produtos e seus detalhes. O projeto foi desenvolvido como parte do aprendizado sobre navegação entre telas, passagem de parâmetros e gerenciamento de estado.

❓ Perguntas e Respostas
1. Qual era a estrutura do seu projeto antes da inclusão das novas telas?
Antes da inclusão das novas telas, o projeto possuía uma estrutura simples com apenas uma tela principal (HomePage). A estrutura era:

text
lib/
├── main.dart
├── presentation/
│   ├── pages/
│   │   └── home_page.dart
│   └── viewmodels/
│       └── product_viewmodel.dart
├── data/
│   ├── datasources/
│   │   ├── product_remote_datasource.dart
│   │   └── product_cache_datasource.dart
│   └── repositories/
│       └── product_repository_imp.dart
└── domain/
    └── models/
        └── product_model.dart
Características:

Apenas uma tela (HomePage)

Sem navegação entre telas

Tudo era exibido em uma única página

Não havia passagem de parâmetros entre telas

O botão home não existia

2. Como ficou o fluxo da aplicação após a implementação da navegação?
Após a implementação da navegação, o fluxo da aplicação ficou da seguinte forma:

text
Tela Inicial (HomePage)
    ↓ (clica no botão "Abrir lista de itens")
    ↓
Lista de Produtos (ProductPage)
    ↓ (clica em um produto específico)
    ↓
Detalhes do Produto (ProductDetailPage)
    ↓ (clica no botão voltar ou no botão home)
    ↓
Retorna para a tela anterior ou para a HomePage
Fluxo de navegação:

HomePage → ProductPage: Navegação para listar todos os produtos

ProductPage → ProductDetailPage: Navegação para ver detalhes de um produto específico

ProductDetailPage → HomePage: Retorno direto para a tela inicial (via botão home)

ProductDetailPage → ProductPage: Retorno para a lista de produtos (via botão voltar)

3. Qual é o papel do Navigator.push() no seu projeto?
O Navigator.push() é responsável por adicionar uma nova tela ao topo da pilha de navegação, permitindo a transição entre telas.

No projeto, o Navigator.push() é utilizado em dois momentos principais:

HomePage → ProductPage:

dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductPage(viewModel: viewModel),
  ),
);
ProductPage → ProductDetailPage:

dart
Navigator.pushNamed(
  context,
  '/product-detail',
  arguments: {
    'productName': product.title,
    'price': product.price,
    // ... outros parâmetros
  },
);
Funções:

Empilha as telas, mantendo o histórico de navegação

Permite ao usuário voltar para telas anteriores

Gerencia a transição animada entre telas

4. Qual é o papel do Navigator.pop() no seu projeto?
O Navigator.pop() remove a tela atual do topo da pilha e retorna para a tela anterior, fechando a tela atual.

No projeto, o Navigator.pop() é utilizado em dois contextos:

Botão voltar da AppBar:

dart
leading: IconButton(
  icon: const Icon(Icons.arrow_back_ios),
  onPressed: () => Navigator.pop(context), // Volta para ProductPage
),
Botão home personalizado:

dart
FloatingActionButton(
  onPressed: () {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false, // Remove todas as telas anteriores
    );
  },
  child: const Icon(Icons.home),
)
Funções:

Remove a tela atual da memória

Libera recursos da tela fechada

Retorna o usuário para a tela anterior

Mantém a pilha de navegação consistente

5. Como os dados do produto selecionado foram enviados para a tela de detalhes?
Os dados do produto selecionado foram enviados através de parâmetros de rota, utilizando o método pushNamed com o parâmetro arguments.

Envio dos dados (ProductPage):

dart
onTap: () {
  Navigator.pushNamed(
    context,
    '/product-detail',
    arguments: {
      'productName': product.title,
      'price': product.price,
      'description': product.description,
      'image': product.image,
      'category': product.category,
      'rate': product.rate,
      'ratingCount': product.ratingCount,
    },
  );
}
Recepção dos dados (main.dart):

dart
onGenerateRoute: (settings) {
  if (settings.name == '/product-detail') {
    final args = settings.arguments as Map<String, dynamic>;
    return MaterialPageRoute(
      builder: (context) {
        return ProductDetailPage(
          productName: args['productName'],
          price: args['price'],
          description: args['description'],
          image: args['image'],
          category: args['category'],
          rate: args['rate'],
          ratingCount: args['ratingCount'],
        );
      },
    );
  }
  return null;
}
Alternativa utilizada inicialmente:

dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductDetailPage(
      productName: product.title,
      price: product.price,
      // ... outros parâmetros
    ),
  ),
);
6. Por que a tela de detalhes depende das informações da tela anterior?
A tela de detalhes depende das informações da tela anterior por questões de arquitetura e boas práticas de desenvolvimento:

Princípios aplicados:

Single Responsibility Principle (SRP):

Cada tela tem uma única responsabilidade

A ProductDetailPage é responsável apenas por exibir dados, não por buscá-los

Separation of Concerns:

Separa a obtenção dos dados (ProductPage) da exibição dos detalhes (ProductDetailPage)

Evita que a tela de detalhes precise fazer novas requisições à API

Performance:

Evita uma segunda chamada à API

Os dados já foram carregados na tela anterior

Consistência:

Garante que o detalhe exibido corresponde exatamente ao produto selecionado

Se o produto fosse buscado novamente, poderia haver inconsistências

Reusabilidade:

A ProductDetailPage pode ser reutilizada com qualquer produto

Não precisa conhecer a fonte dos dados (API, cache, etc.)

7. Quais foram as principais mudanças feitas no projeto original?
Aspecto	Antes	Depois
Número de telas	1 tela (HomePage)	3 telas (Home, Products, Detail)
Navegação	Nenhuma	Navigator.push/pop/pushNamed
Rotas	Navegação direta	Rotas nomeadas com onGenerateRoute
Passagem de dados	Não existia	Parâmetros via arguments
Botão home	Não existia	FloatingActionButton transparente
Arquitetura	Simples	Camadas bem definidas (pages, viewmodels, widgets)
Arquivos adicionados:

text
lib/presentation/pages/
├── home_page.dart (refatorado)
├── product_page.dart (novo)
└── product_detail_page.dart (novo)

lib/presentation/widgets/
└── floating_home_button.dart (novo)
Arquivos modificados:

main.dart: Adicionadas rotas nomeadas e configuração de navegação

product_viewmodel.dart: Mantido para gerenciamento de dados

8. Quais dificuldades você encontrou durante a adaptação do projeto para múltiplas telas?
Dificuldade 1: Gerenciamento do ViewModel

Problema: O ViewModel estava sendo recriado em cada tela

Solução: Criar o ViewModel uma única vez no main.dart e passar como parâmetro para as telas

Dificuldade 2: Passagem de dados entre telas

Problema: Como enviar objetos complexos de uma tela para outra

Solução: Utilizar o parâmetro arguments do Navigator.pushNamed e converter para Map

Dificuldade 3: Botão home aparecer em todas as telas

Problema: Precisava replicar o botão home em cada tela

Solução: Criar um widget reutilizável (FloatingHomeButton) usado em todas as telas

Dificuldade 4: Navegação com limpeza da pilha

Problema: Como voltar para a home e limpar todo o histórico de navegação

Solução: Usar pushNamedAndRemoveUntil com predicado (route) => false

Dificuldade 5: Tratamento de erros em imagens

Problema: Imagens que não carregavam quebravam o layout

Solução: Adicionar errorBuilder no Image.network para mostrar ícone de fallback

Dificuldade 6: Layout responsivo

Problema: Layout quebrava em diferentes tamanhos de tela

Solução: Utilizar Expanded, Flexible e SingleChildScrollView para adaptação

Dificuldade 7: Posicionamento do FloatingActionButton

Problema: Botão home não aparecia porque estava dentro do Column

Solução: Colocar o FloatingActionButton como parâmetro direto do Scaffold

Dificuldade 8: Botão home transparente

Problema: Botão home tinha fundo padrão com sombra

Solução: Configurar backgroundColor: Colors.transparent e elevation: 0

🎯 Conclusão
A implementação da navegação entre múltiplas telas trouxe uma estrutura mais profissional e escalável para o projeto. As principais lições aprendidas foram:

Planejamento é essencial: Definir a arquitetura de navegação antes de começar

Widgets reutilizáveis: Economizam tempo e mantêm consistência visual

Tratamento de erros: Fundamental para uma boa experiência do usuário

Organização de rotas: Rotas nomeadas facilitam a manutenção

Desacoplamento: Separar responsabilidades entre as telas torna o código mais limpo

🛠️ Tecnologias Utilizadas
Flutter: Framework para desenvolvimento mobile

Dart: Linguagem de programação

Provider/Riverpod: Gerenciamento de estado

HTTP: Cliente para requisições à API

Fake Store API: API de produtos utilizada no projeto

📱 Funcionalidades
✅ Listagem de produtos da API

✅ Visualização de detalhes de cada produto

✅ Navegação entre telas com histórico

✅ Botão home para retorno rápido

✅ Exibição de avaliações (estrelas e quantidade)
