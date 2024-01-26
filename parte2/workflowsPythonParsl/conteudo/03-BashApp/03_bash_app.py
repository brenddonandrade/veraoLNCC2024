import parsl
from parsl import python_app, bash_app

parsl.load()


@bash_app
def hello_bash(message, stdout="hello-stdout"):
    return 'echo "Hello %s"' % message

@bash_app
def limpa_diretorio():
    return 'make'

# invoke the Bash app and read the result from a file
hello_bash("World (Bash)").result()

with open("hello-stdout", "r") as f:
    print(f.read())

limpa_diretorio().result()
