// FitnessComponent.h
#ifndef FITNESSCOMPONENT_H
#define FITNESSCOMPONENT_H

#include <iostream>
#include <string>

using namespace std;

class FitnessComponent {
protected:
    string componentName;
public:
    FitnessComponent(string name) : componentName(name) {}
    virtual void display() const = 0;  // Pure virtual function (Point 3)
    virtual ~FitnessComponent() {}  // Virtual destructor (Point 9)
};

#endif // FITNESSCOMPONENT_H

