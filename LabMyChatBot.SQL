SHOW PARAMETERS LIKE 'CORTEX_ENABLED_CROSS_REGION' IN ACCOUNT;

ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';

-- Créer le WAREHOUSE
CREATE WAREHOUSE IF NOT EXISTS WH_LAB
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE
  COMMENT = 'Warehouse pour le lab de chat app';

-- Créer la DATABASE
CREATE DATABASE IF NOT EXISTS DB_LAB
  COMMENT = 'Database pour le lab de chat app';

-- Utiliser la database
USE DATABASE DB_LAB;

-- Créer le SCHEMA
CREATE SCHEMA IF NOT EXISTS CHAT_APP
  COMMENT = 'Schema pour l\'application de chat';

-- Utiliser le schema
USE SCHEMA CHAT_APP;

-- Vérifier l'accès à Snowflake Cortex (fonctions LLM)
-- Cette requête teste si vous avez accès aux fonctions Cortex
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'snowflake-arctic',
  'Bonjour, peux-tu me répondre en français ?'
) AS reponse;

-- Lister les modèles Cortex disponibles
SHOW FUNCTIONS LIKE 'COMPLETE' IN SCHEMA SNOWFLAKE.CORTEX;

CREATE STREAMLIT DB_LAB.CHAT_APP.CHAT_APP_LAB
  ROOT_LOCATION = '@DB_LAB.CHAT_APP.STREAMLIT_STAGE'
  MAIN_FILE = 'streamlit_app.py'
  QUERY_WAREHOUSE = WH_LAB
  COMMENT = 'Application de chat avec Snowflake Cortex';

  -- Vérifier le warehouse
SHOW WAREHOUSES LIKE 'WH_LAB';

-- Vérifier la database
SHOW DATABASES LIKE 'DB_LAB';

-- Vérifier le schema
USE DATABASE DB_LAB;
SHOW SCHEMAS LIKE 'CHAT_APP';

-- Définir le contexte de travail
USE WAREHOUSE WH_LAB;
USE DATABASE DB_LAB;
USE SCHEMA CHAT_APP;

