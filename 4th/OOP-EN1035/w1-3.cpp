#include<iostream>
using namespace std;
double sumdouble(double a, double b){
	if (a != b)
	return a+b;
	else
	return 2*(a+b);
}
string helloName(string name){
	return "Hello "+name+"!";
}
bool monkyTrouble(bool a, bool b){
	if (!a != !b) //xor operator
	return true;
	else
	return false;
}
int main()
{
/***	double a, b;
	cout<<"Enter two numbers: ";
	cin>>a>>b;
	cout<<sumdouble(a,b)<<endl;
	string name;
	cout<<"Enter your name: ";
	cin>>name;
	cout<<helloName(name)<<endl;*/
	bool c, d;
	cout<<"Enter two booleans monkey: ";
	cin>>c>>d;
	if (monkyTrouble(c,d))
	cout<<"We are in trouble"<<endl;
	else
	cout<<"We are not in trouble"<<endl;
	return 0;
}
