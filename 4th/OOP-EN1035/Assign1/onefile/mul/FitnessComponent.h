#ifndef FITNESSCOMPONENT_H
#define FITNESSCOMPONENT_H

#include <string>
using namespace std;

class FitnessComponent {
protected:
    string componentName;
public:
    FitnessComponent(string name);
    virtual void display() const = 0;
    virtual ~FitnessComponent();
};

#endif // FITNESSCOMPONENT_H

