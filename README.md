# transport_app

Novo projeto de app para transporte de encomendas.

## SETUP


### 1 Lefthook

Utilizado para configurar Git Hooks no projeto. Realiza algumas checagens antes de commits ou pushes.

Documentação com manual de instalação [aqui.](https://github.com/evilmartians/lefthook/blob/master/docs/full_guide.md)

Após a instalação, acessar a raiz do projeto e executar:

```bash
lefthook install -f
```

### 2 Scripts

Para facilitar algumas ações rotineiras, como por exemplo a execução de testes, foi criado um script para auxiliar na execução de algums comandos em todos os Micro Apps.

Basta executar o arquivo `scripts.sh` para ter acesso à lista de comandos disponíveis.

Alguns comandos requerem a instalação de programas adicionais, como por exemplo coverage e lcov:

```bash
pub global activate coverage
brew install lcov
```

Para instalar o lcov no Windows utilizar

```bash
choco install lcov
```

Após clonar o projeto e rodar o script acima, pode ser executado um pub get através desse script:

```bash
./scripts.sh --get
```

Para mais comandos úteis:
```bash
./scripts.sh --help
```

## **3. Executando o projeto**

Para executar, levar em consideração os flavors `dev`, `hml` e `prod`.  

Cada flavor possui um arquivo de configurações dentro da pasta `base_app/.env`.  

Executar sempre da seguinte maneira:  

```bash
cd base_app
flutter run -t lib/main-<flavor>.dart --flavor <flavor> 
```

[Mais detalhes sobre a integração com AllowMe aqui](flutter_allowme_plugin/README.md)

### 3.1 Criando/editando flavors

Para a criação dos flavors, foi utilizado o package [flutter_flavorizr](https://github.com/AngeloAvv/flutter_flavorizr).

Seguir sua documentação para adição/edição dos flavors.


## **4. Testes**

Para manter a organização, cada arquivo de teste deve ser criado na mesma estrutura de pastas do arquivo sendo testado. Exemplo:

```bash
# Implementação
/lib
  /domain
    /usecases
      /remote_auth.dart

# Teste
/test
  /domain
    /usecases
      /remote_auth_test.dart
```

## **5. Padronização e boas práticas**

Projeto configurado com o package [Flutter Lints](https://pub.dev/packages/flutter_lints).

As regras foram centralizadas no pacote `shared`, no arquivo `lib/linter_rules.yaml`.  
Cada package (microApp) deve possuir um arquivo `analysis_options.yaml` com uma estrutura básica referenciando o package core (e podendo conter regras específicas):

```yaml
include: package:shared/linter_rules.yaml

# Regras específicas do módulo abaixo do include...
```

### 5.1 Commits

Deve ser mantida uma padronização quanto às mensagens de commits. Deve-se seguir o padrão especificado em [Conventional Commits.](https://www.conventionalcommits.org/pt-br/v1.0.0/)

É obrigatório sempre ter um tipo na mensagem de commit.  
*Essa validação é feita automaticamente pelo Lefthook no momento do commit.*

```
<tipo>[escopo opcional]: <descrição>

[corpo opcional]

[rodapé(s) opcional(is)]
```

Prefixos aceitos: build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test