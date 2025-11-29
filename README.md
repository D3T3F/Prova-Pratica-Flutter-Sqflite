# 📝 PROVA PRÁTICA: Cadastro de Tarefas Profissionais

## Descrição do Projeto

Este projeto é uma **Prova Prática** desenvolvida em **Flutter** com o objetivo de demonstrar a implementação de um **CRUD (Create, Read, Update, Delete) completo** para o gerenciamento de tarefas profissionais. O aplicativo utiliza o banco de dados **SQLite** através do pacote `sqflite` para persistência de dados local.

O tema central é o **Cadastro de Tarefas Profissionais**, onde cada tarefa possui um conjunto de atributos obrigatórios e um campo extra personalizado, conforme os requisitos da avaliação.

---

## Dados do Aluno
| | |
| :--- | :--- |
| Nome | David Teixeira Ferraz |
| RA | 202310115 |

---

## Dificuldade Encontrada

A única dificuldade encontrada foi realizar a extração do arquivo .db de dentro dos arquivos do aplicativo no emulador android. Tirando esse processo, não encontrei nenhuma outra dificuldade.

---

## Requisitos Técnicos

O desenvolvimento seguiu os seguintes requisitos técnicos:

| Requisito Técnico | Status | Observações |
| :--- | :--- | :--- |
| Uso obrigatório de `sqflite` | ✅ Implementado | Pacote essencial para a persistência de dados. |
| Uso obrigatório de `path_provider` | ✅ Implementado | Utilizado para determinar o caminho correto para o arquivo do banco de dados. |
| CRUD Completo | ✅ Implementado | Funções de Inserir, Listar, Editar e Excluir tarefas. |
| Listagem com `ListView.builder` | ✅ Implementado | A lista de tarefas é construída dinamicamente e atualizada após operações de CRUD. |
| Nome do Banco de Dados | ⚠️ Placeholder | O arquivo do banco de dados deve conter o RA, decidi criar como: `prova_pratica_202310115.db`. |

---

## Estrutura do Banco de Dados

A tabela principal de tarefas (`tarefas`) foi estruturada para armazenar as informações essenciais e o campo personalizado.

| Campo | Tipo | Descrição |
| :--- | :--- | :--- |
| `id` | `INTEGER` | Chave primária e auto-incremento. |
| `titulo` | `TEXT` | Título breve da tarefa. |
| `descricao` | `TEXT` | Descrição detalhada da tarefa. |
| `prioridade` | `INTEGER` | Nível de prioridade da tarefa (mapeado a partir de um `enum`). |
| `criadoEm` | `TEXT` | Data e hora de criação da tarefa (armazenado como string ISO 8601). |
| `nivelUrgencia` | `INTEGER` | **Campo Personalizado:** Nível de urgência da tarefa (mapeado a partir de um `enum`). |

---

## Funcionalidades

- **Criação de Tarefa:** Formulário para inserção de novas tarefas com validação de campos.
- **Listagem de Tarefas:** Exibição de todas as tarefas cadastradas em uma lista dinâmica (`ListView.builder`). Além de opção para filtrar por data, urgência e prioridade.
- **Edição de Tarefa:** Opção para modificar os dados de uma tarefa existente.
- **Exclusão de Tarefa:** Remoção permanente de uma tarefa do banco de dados.

---

## Instalação e Execução

Para rodar este projeto localmente, siga os passos abaixo:

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/D3T3F/Prova-Pratica-Flutter-Sqflite
    cd Prova-Pratica-Flutter-Sqflite
    ```

2.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```

3.  **Execute o aplicativo:**
    ```bash
    flutter run
    ```

---
