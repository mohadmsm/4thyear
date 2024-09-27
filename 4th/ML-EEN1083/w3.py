
def A():
    import csv
    with open('t.csv') as f:
        r = csv.reader(f)
        for row in r:
            print(row[0], row[3])

#A() first task

def B():
    import csv
    import os
    with open('/tmp/output.csv', 'w') as f:
        w = csv.writer(f)
        w.writerow(['A', '1', 'Female', 'red'])
        f.close()
        os.system("cat /tmp/output.csv")

#B()

def C():
    import pandas as pd
    df = pd.read_csv('t.csv')
   # print(df.head())
   # print(df['pclass'].head())
    t1 = df.iloc[0:3]
    t1.to_csv('output_test.csv')
   # print(df.iloc[0:3])

#C()

def D():
    from tabulate import tabulate
    import pandas as pd
    df = pd.read_csv('t.csv')
    content = tabulate(
    df.values.tolist(),
    list(df.columns),
    tablefmt="plain")

    open('/tmp/titanic.fwf', 'w').write(content)

D()
def E():
    import pandas as pd
    df = pd.read_fwf('/tmp/titanic.fwf')
    print(df.tail())

E()
