#The first line contains the number of students who have subscribed to the English newspaper.
#The second line contains the space separated list of student roll numbers who have subscribed to the English newspaper.
#The third line contains the number of students who have subscribed to the French newspaper.
#The fourth line contains the space separated list of student roll numbers who have subscribed to the French newspaper.
# Enter your code here. Read input from STDIN. Print output to STDOUT


E,EL = int(input()), set(map(int,input().split()))
F,FL = int(input()), set(map(int,input().split()))
print(len(EL^FL))
