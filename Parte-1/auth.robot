*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary 

*** Variables ***
${URL}         https://chips.qacoders-academy.com.br/api/login/
${MAIL}        sysadmin@qacoders.com
${PASSWORD}    1234@Test

#*** Keywords ***

*** Test Cases ***
Login com sucesso
    [Documentation]    Validar autenticação com sucesso
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=       Create Dictionary    mail=${MAIL}    password=${PASSWORD}

    Create Session    auth_session    ${URL}

    ${response}=         POST On Session    auth_session    /    json=${body}    headers=${headers}
    Log                  ${response}
    ${response_body}=    Evaluate           json.loads('''${response.content}''')  #converte a conteúdo do response em um objeto pyhton e atribuindo a variável 
                         #evalute permite executar uam expressão em python dentro de um script robot
    Log                  ${response_body}
    
    Log    response.status

    Should Be Equal As Integers    ${response.status_code}              200 
    Should Not Be Empty            ${response_body}[token]
    Should Be Equal As Strings     ${response_body}[user][mail]    ${MAIL}   