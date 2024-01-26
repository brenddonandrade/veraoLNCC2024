import parsl
from parsl import python_app

parsl.load()

# Map function that returns double the input integer
@python_app
def app_random():
    import random

    return random.random()


results = []
apps = []
for i in range(0, 10):
    x = app_random()
    results.append((i, x))
    apps.append(x)

#for r in results:
#    print(f" Id={r[0]} -> {r[1].result()}")

# Barreira de Sincronizacao
for t in apps:
    t.result()
