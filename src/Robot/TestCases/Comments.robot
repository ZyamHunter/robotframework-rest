*** Settings ***
Documentation       Validação automatizada das rotas de postagens -> /posts

Library             REST
Resource            ../Resources/Comments.robot
Resource            ../Component/Validate_Dict.robot


*** Keywords ***
Get all comments
    ${params}    Create Dictionary
    ...    postId=${POST_ID}

    ${RESPONSE}    GET    
    ...    endpoint=${ENVS['BASE_API']}/comments
    ...    query=${params}    
    ...    timeout=3    
    ...    loglevel=INFO

    Should Be Equal As Strings    ${RESPONSE['status']}    200
    Should Be Equal As Strings    ${RESPONSE['reason']}    OK

    FOR    ${element}    IN    @{RESPONSE['body']}
        Validate Dict    ${element}    ${COMMENTS_LIST}
    END