#include<iostream>
using namespace std;


class student{
	private:
		string name;
		int id;
        public:
		Student(string, int );
		void display();
};

Student::Student(string n, int i){
	this->name = n;
	this->id = i;
}
