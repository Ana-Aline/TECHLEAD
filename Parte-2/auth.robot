*** Settings ***
Resource    ./utils/resources.robot
Library    String

*** Test Cases ***
Login com sucesso
    [Documentation]    Validar autenticação com sucesso
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=       Create Dictionary    mail=${MAIL_SYSADMIN}    password=${PASSWORD_SYSADMIN}

    Create Session    auth_session    ${URL}${ENDPOINT_LOGIN}

    ${response}=         POST On Session    auth_session    /    json=${body}    headers=${headers}    verify=${True}
    Log                  ${response}
    ${response_body}=    Evaluate           json.loads('''${response.content}''')  #converte a conteúdo do response em um objeto pyhton e atribuindo a variável 
                         #evalute permite executar uam expressão em python dentro de um script robot
    Log                  ${response_body}
    
    Log    response.status

    Should Be Equal As Integers    ${response.status_code}              200 
    Should Not Be Empty            ${response_body}[token]
    Should Be Equal As Strings     ${response_body}[user][mail]    ${MAIL_SYSADMIN}   

Login senha invalida
    [Tags]    excecao
    [Documentation]    Validar mensagem de erro quando senha é inválida.
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=       Create Dictionary    mail=${MAIL_SYSADMIN}    password=${PASSWORD_INVALID}

    Create Session    auth_session    ${URL}${ENDPOINT_LOGIN}

    ${response}=    POST On Session    auth_session    /    json=${body}    headers=${headers}    verify=${True}    expected_status=400
    #By default this keyword fails if a status code with error values is returned in the response, this behavior can be modified using the expected_status and msg parameters, read more about it in Status Should Be keyword documentation. In order to disable this implicit assert mechanism you can pass as expected_status the values any or anything.

    Should Be Equal As Integers    ${response.status_code}    400
    Should Be Equal As Strings    ${response.json()}[alert]    E-mail ou senha informados são inválidos.