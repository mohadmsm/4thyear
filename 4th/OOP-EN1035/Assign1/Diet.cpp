// Diet.cpp
#include "Diet.h"

Diet::Diet(string name, string mealType, int calories, string description)
    : FitnessComponent(name), mealType(mealType), calories(calories), description(description) {}

void Diet::display() const {
    cout << "Diet: " << componentName << " | Meal: " << mealType << " | Calories: " << calories << " | Description: " << description << endl;
}

Diet::~Diet() {
    cout << "Diet " << componentName << " is being deleted." << endl;
}

