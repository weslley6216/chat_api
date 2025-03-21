# Chat Web API

API RESTful para a aplicação de chat em tempo real.

## Funcionalidades 🚀

* Gerenciamento de usuários
* Gerenciamento de conversas
* Gerenciamento de mensagens
* Autenticação via JWT
* Comunicação em tempo real via WebSockets (Action Cable)

## Tecnologias 💻

* Ruby 3.4.2
* Rails 8.0.1
* RSpec
* PostgreSQL
* Action Cable
* Solid Cable

## Documentação de Endpoints 📚

| Endpoint                  | Método | Descrição                                        |
| :------------------------ | :----- | :------------------------------------------------- |
| `/users`                  | GET    | Retorna a lista de todos os usuários.          |
| `/users`                  | POST   | Cria um novo usuário.                             |                    |
| `/conversations`          | GET    | Retorna a lista de todas as conversas do usuário. |
| `/conversations/:id`      | GET    | Retorna uma conversa específica.                |
| `/conversations`          | POST   | Cria uma nova conversa.                            |
| `/conversations/:conversation_id/messages` | GET    | Retorna a lista de mensagens de uma conversa.   |
| `/conversations/:conversation_id/messages`              | POST   | Cria uma nova mensagem.                           |
| `/login`                  | POST   | Autentica um usuário e retorna um token JWT.       |

## Detalhes Adicionais ℹ️

* A autenticação é feita via JWT, com tokens sendo enviados no header `Authorization` no formato `Bearer <token>`.
* A comunicação em tempo real é implementada usando Action Cable para WebSockets, com Solid Cable como uma camada de abstração para facilitar a interação com o Action Cable no frontend.

## Testes 🧪

* Os testes são escritos usando RSpec.
* Para executar os testes, utilize o comando `docker compose exec chat_api rspec` no diretório raiz do projeto.

## Funcionalidades Futuras 🔮

* Suporte ao envio de arquivos (permitindo anexos como imagens e documentos pequenos).
* Implementação de paginação na listagem de mensagens para melhor desempenho.
* Criação de um endpoint de métricas (`/metrics`) com estatísticas sobre mensagens enviadas e usuários ativos.
* Processamento assíncrono de mensagens utilizando fila de tarefas (exemplo: Redis + Sidekiq).
* Melhorias na segurança e escalabilidade da API.
