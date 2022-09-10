*** Settings ***
Library   SeleniumLibrary
Library   String
Library    ../src/healenium_log.py

Suite Setup  Open web application    ${url}    firefox    ${selenium_grid_url}
Suite Teardown  Close browser

*** Variables ***
${url}                  https://sha-test-app.herokuapp.com
${selenium_grid_url}    http://localhost:8085
${click_me_btn}         //button[contains(@class,'default-btn')]
${generate_markup_btn}  //*[@id='markup-generation-button']
${button}               //button[contains(@class,'default-btn')]



*** Test Cases ***
Click me button test
    [Documentation]  Simple smoke test that should always pass
    Click Element   ${click_me_btn}
    Handle Alert    action=ACCEPT

Click me button test with healing
    [Documentation]  Test the selfhealing functionality of Healenium
    Click Element   ${generate_markup_btn}  # generate new layout -> locators going to change
    Click Element   ${click_me_btn}  # should be healed
    ${logs}=   Get Logs
    ${healed_locator}=   Get Lines Containing String  ${logs}   Using healed locator   False
    ${info_healed_locator}=   Get Line  ${healed_locator}   -1
    Log   ${info_healed_locator}
    Handle Alert    action=ACCEPT


Logging in the file
    ${logs}=   Get Logs
    BuiltIn.Log    ${logs}
    ${link}=   Get Line  ${logs}   -1
    Log   ${link}   WARN   True   True   DEPRECATED   str



*** Keywords ***
Open web application
    [Arguments]  ${url}  ${browser}    ${selenium_grid_url}
    # for chrome browser, sandbox need to be turned off
    IF    "${browser}" == "chrome" or "${browser}" == "googlechrome" or "${browser}" == "gc" or "${browser}" == "headlesschrome" 
        ${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
        Call Method    ${chrome_options}   add_argument    --no-sandbox
        ${options}=     Call Method     ${chrome_options}    to_capabilities
        Open Browser  url=${url}  browser=${browser}  remote_url=${selenium_grid_url}  desired_capabilities=${options}
    ELSE
        Open Browser  url=${url}  browser=${browser}  remote_url=${selenium_grid_url}
    END