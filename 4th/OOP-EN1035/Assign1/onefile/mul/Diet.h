#ifndef DIET_H
#define DIET_H

#include "FitnessComponent.h"

class Diet : public FitnessComponent {
private:
    string mealType;
    int calories;
    string description;
public:
    Diet(string name, string mealType, int calories, string description);
    void display() const override;
    ~Diet();
};

#endif // DIET_H

