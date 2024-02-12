*** Settings ***
Library     ../../Helpers/Get_Envs.py


*** Keywords ***
Criar conexão
    ${ENVS}    Get Enviroment Variables
    Set Global Variable    ${ENVS}    ${ENVS}

Encerrar conexão
    Log To Console    Requisição finalizada
