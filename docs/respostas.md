# 1. Modelagem e Arquitetura

## SGBD Relacional
O PostgreSQL foi escolhido por ser um banco relacional que garante as propriedades ACID:

- Atomicidade: a transação ocorre por completo ou não ocorre
- Consistência: mantém integridade dos dados
- Isolamento: evita conflitos entre transações simultâneas
- Durabilidade: os dados não se perdem

Isso é essencial para sistemas acadêmicos.

## Uso de Schemas
O uso de schemas como academico e seguranca:

- Organiza o banco
- Evita poluição do schema public
- Facilita manutenção
- Permite controle de acesso


# 2. Modelo Lógico

## Entidades
- aluno (id, nome, email, ativo)
- professor (id, nome, email, ativo)
- disciplina (id, nome)
- turma (id, disciplina_id, professor_id, ciclo)
- matricula (id, aluno_id, turma_id, nota, ativo)

## Normalização
- 1FN: dados atômicos
- 2FN: sem dependência parcial
- 3FN: sem dependência transitiva


# 5. Concorrência

Quando dois usuários alteram o mesmo dado:
- O banco usa locks
- Uma transação executa por vez
- A outra espera

Isso garante o isolamento (ACID) e evita corrupção de dados.