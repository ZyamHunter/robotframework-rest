*** Settings ***
Documentation       Validação automatizada das rotas de postagens -> /posts

Library             FakerLibrary
Library             REST
Resource            ../Resources/Posts.robot
Resource            ../Resources/Comments.robot
Resource            ../Component/Validate_Dict.robot


*** Keywords ***
Get all posts
    ${RESPONSE}    GET    
    ...    endpoint=${ENVS['BASE_API']}/posts
    ...    timeout=3    
    ...    loglevel=INFO

    Should Be Equal As Strings    ${RESPONSE['status']}    200
    Should Be Equal As Strings    ${RESPONSE['reason']}    OK

    FOR    ${element}    IN    @{RESPONSE['body']}
        Validate Dict    ${element}    ${POSTS}
    END

    Set Suite Variable    ${POST_ID}    ${RESPONSE['body'][0]['id']}

Get one post
    ${RESPONSE}    GET
    ...    endpoint=${ENVS['BASE_API']}/posts/${POST_ID}
    ...    timeout=3    
    ...    loglevel=INFO

    Should Be Equal As Strings    ${RESPONSE['status']}    200
    Should Be Equal As Strings    ${RESPONSE['reason']}    OK
    Validate Dict    ${RESPONSE['body']}    ${POSTS}

Get comments of one post
    ${RESPONSE}    GET
    ...    endpoint=${ENVS['BASE_API']}/posts/${POST_ID}/comments
    ...    timeout=3    
    ...    loglevel=INFO

    Should Be Equal As Strings    ${RESPONSE['status']}    200
    Should Be Equal As Strings    ${RESPONSE['reason']}    OK

    FOR    ${element}    IN    @{RESPONSE['body']}
        Validate Dict    ${element}    ${COMMENTS_LIST}
    END

Creat post
    ${title}    FakerLibrary.Text
    ${body}    FakerLibrary.Texts

    ${POST_ITEM}    Create Dictionary
    ...    title=${title}
    ...    body=${body}
    ...    userId=1

    ${RESPONSE}    POST
    ...    endpoint=${ENVS['BASE_API']}/posts
    ...    body=${POST_ITEM}
    ...    timeout=3    
    ...    loglevel=INFO

    Should Be Equal As Strings    ${RESPONSE['status']}    201
    Should Be Equal As Strings    ${RESPONSE['reason']}    Created

    Validate Dict    ${RESPONSE['body']}    ${POSTS}
    Dictionary Should Contain Item    ${RESPONSE['body']}    title    ${title}
    Dictionary Should Contain Item    ${RESPONSE['body']}    body    ${body}
    Dictionary Should Contain Item    ${RESPONSE['body']}    userId    1

Update post completely
    ${title}    FakerLibrary.Text
    ${body}    FakerLibrary.Texts

    ${POST_ITEM}    Create Dictionary
    ...    title=${title}
    ...    body=${body}
    ...    userId=1

    ${RESPONSE}    PUT
    ...    endpoint=${ENVS['BASE_API']}/posts/${POST_ID}
    ...    body=${POST_ITEM}
    ...    timeout=3    
    ...    loglevel=INFO

    Should Be Equal As Strings    ${RESPONSE['status']}    200
    Should Be Equal As Strings    ${RESPONSE['reason']}    OK

    Validate Dict    ${RESPONSE['body']}    ${POSTS}
    Dictionary Should Contain Item    ${RESPONSE['body']}    title    ${title}
    Dictionary Should Contain Item    ${RESPONSE['body']}    body    ${body}
    Dictionary Should Contain Item    ${RESPONSE['body']}    userId    1

Update item in post
    ${title}    FakerLibrary.Text

    ${POST_ITEM}    Create Dictionary
    ...    title=${title}

    ${RESPONSE}    PATCH
    ...    endpoint=${ENVS['BASE_API']}/posts/${POST_ID}
    ...    body=${POST_ITEM}
    ...    timeout=3    
    ...    loglevel=INFO

    Should Be Equal As Strings    ${RESPONSE['status']}    200
    Should Be Equal As Strings    ${RESPONSE['reason']}    OK

    Validate Dict    ${RESPONSE['body']}    ${POSTS}
    Dictionary Should Contain Item    ${RESPONSE['body']}    title    ${title}

Delete post
    ${RESPONSE}    DELETE
    ...    endpoint=${ENVS['BASE_API']}/posts/${POST_ID}
    ...    timeout=3    
    ...    loglevel=INFO

    Should Be Equal As Strings    ${RESPONSE['status']}    200
    Should Be Equal As Strings    ${RESPONSE['reason']}    OK