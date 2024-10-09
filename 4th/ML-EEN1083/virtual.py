import matplotlib
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

matplotlib.rcParams['figure.figsize'] = 11, 8

df = pd.read_csv('https://raw.githubusercontent.com/jbryer/CompStats/master/Data/titanic3.csv')
print(df.head()) #df.head()
# Plot a histogram of fares, ignoring missing values
fare = df['fare'].dropna()
r = hist(fare, bins=100)
xlabel('fare'); ylabel('count')

