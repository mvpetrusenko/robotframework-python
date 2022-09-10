import docker
from selenium import webdriver
from selenium.webdriver.common.by import By
client = docker.from_env()
print(client.containers.get('hlm-proxy').logs())

logsFrom = client.containers.get('hlm-proxy').logs()

def get_logs():
    return logsFrom.decode('UTF-8')


driver = webdriver.Chrome()
driver.get("https://sha-test-app.herokuapp.com")


element = driver.find_element(By.XPATH, "//button[contains(@class,'default-btn')]")

def found_element():
    print("Element has been found")


def not_found_element():
    print("Not found element")

if (element):
    found_element()
else:
    not_found_element()

driver.quit()




## TODO: replace the container ID with container name or other way how to identify the "hlm-proxy" container for easier setup
## TODO: extract the sentence "Report available at http://..." from the log output and write it to RobotFW log.html file on the test suite level (on the top)
## TODO: try to write info about the healed locator in the RobotFW log.html file on the place where the element was used (on the test step level)