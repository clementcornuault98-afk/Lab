# 💬 Chat Application avec Streamlit in Snowflake & Snowflake Cortex

---

# 1. Description du projet

Ce projet consiste à concevoir une application web de type **ChatGPT**, développée avec **Streamlit** et déployée directement dans **Snowflake via Streamlit in Snowflake**.

L’application permet à un utilisateur de dialoguer avec un modèle LLM supporté par **Snowflake Cortex**, sans utiliser de clé OpenAI externe.

L’ensemble de l’architecture repose exclusivement sur l’écosystème Snowflake :

* Interface : Streamlit in Snowflake
* LLM : Snowflake Cortex
* Stockage : Tables Snowflake
* Exécution : Warehouse Snowflake

---

# 2. Architecture technique

## 🧱 Vue d’ensemble

Utilisateur
⬇
Streamlit in Snowflake
⬇
Appel SQL / Snowpark
⬇
Snowflake Cortex (LLM)
⬇
Réponse affichée dans le chat
⬇
Persistance dans une table Snowflake

---

## 🔹 Frontend

* Streamlit in Snowflake
* Composants utilisés :

  * `st.title()`
  * `st.chat_message()`
  * `st.chat_input()`
  * `st.sidebar`
  * `st.session_state`

---

## 🔹 Backend

* Appel aux fonctions Cortex via SQL :

```sql
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'nom_du_modele',
    'prompt'
);
```

## 🔹 Base de données

Table de persistance des conversations :

```sql
CREATE TABLE CHAT_HISTORY (
    conversation_id STRING,
    timestamp TIMESTAMP,
    role STRING,
    content STRING
);
```

# 3. Étapes de déploiement

## 🔹 Pré-requis

Les étudiants doivent disposer :

* D’un compte Snowflake avec :

  * Accès à un WAREHOUSE
  * Droits de création DATABASE et SCHEMA
  * Accès à Streamlit in Snowflake
  * Accès à Snowflake Cortex

* Connaissances :

  * Python
  * Streamlit
  * SQL
  * Notions de LLM & prompt engineering

## 🔹 Activation de Cortex

Vérifier l’activation :

```sql
SHOW PARAMETERS LIKE 'CORTEX_ENABLED_CROSS_REGION' IN ACCOUNT;
```

Activer si nécessaire :

```sql
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';
```

## 🔹 Mise en place de l’environnement

```sql
CREATE WAREHOUSE WH_LAB
WITH WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE;

CREATE DATABASE DB_LAB;
CREATE SCHEMA DB_LAB.CHAT_APP;

USE WAREHOUSE WH_LAB;
USE DATABASE DB_LAB;
USE SCHEMA CHAT_APP;
```

Créer l’application Streamlit in Snowflake via l’interface Snowflake.


# 4. Intégration avec Snowflake Cortex

L’application :

1. Construit un prompt dynamique basé sur :

   * Une instruction système
   * L’historique de conversation
2. Transmet :

   * Le modèle sélectionné
   * La température choisie
   * Le prompt complet
3. Appelle Cortex via SQL
4. Affiche la réponse dans l’interface


## Exemple de construction du prompt

Structure interne des messages :

```python
{
    "role": "user" | "assistant" | "system",
    "content": "..."
}
```

⚠️ Le message `system` n’est pas affiché dans l’interface.



# 5. Choix du modèle

L’application permet de sélectionner dynamiquement un modèle Cortex depuis la sidebar.

Exemples de modèles supportés :

* mistral-large
* llama3-70b
* snowflake-arctic

Critères de sélection :

* Compatibilité Cortex
* Qualité des réponses
* Coût d’inférence
* Latence

Aucune clé OpenAI n’est utilisée.



# 6. Gestion de l’historique

## 🔹 En session (temps réel)

Utilisation de :

```python
st.session_state["messages"]
```

Structure :

```python
[
  {"role": "system", "content": "..."},
  {"role": "user", "content": "..."},
  {"role": "assistant", "content": "..."}
]
```

Fonctionnalités :

* Nouveau Chat → reset session_state
* Non affichage du rôle system
* Conservation de la conversation pendant la session


## 🔹 Persistance Snowflake

Table :

```sql
CREATE TABLE CHAT_HISTORY (
    conversation_id STRING,
    timestamp TIMESTAMP,
    role STRING,
    content STRING
);
```

Fonctionnalités :

* Génération d’un `conversation_id`
* Insertion automatique des messages
* Stockage horodaté
* (Optionnel) Reload d’une conversation existante

---

# 7. Instructions d’exécution

## Depuis Streamlit in Snowflake

1. Ouvrir Snowflake
2. Accéder à Streamlit
3. Lancer l’application
4. Sélectionner :

   * Modèle
   * Température
5. Commencer la conversation



# 8. Réponses aux questions de validation

## ❓ Comment le modèle est-il appelé ?

Via Snowflake Cortex, en SQL ou Snowpark, sans API externe.


## ❓ Comment la sécurité est-elle assurée ?

* Aucun secret en dur
* Aucun appel API externe
* Gestion via rôles Snowflake


## ❓ Comment la persistance est-elle gérée ?

* Table Snowflake dédiée
* conversation_id unique
* Horodatage automatique


## ❓ Comment la scalabilité est-elle assurée ?

* Snowflake gère le compute via le Warehouse
* Auto suspend / auto resume
* Possibilité d’augmenter la taille du Warehouse


## ❓ Comment le prompt est-il construit ?

* Ajout d’une instruction système
* Ajout de l’historique
* Transmission au modèle via Cortex



# 👤 Projet 

Projet réalisé dans le cadre d’un laboratoire Snowflake & LLM
Date : 2026
Auteur : Clément Cornuault 
