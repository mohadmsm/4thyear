// Goal.cpp
#include "Goal.h"

Goal::Goal(string name, string goalType, int target, int progress)
    : FitnessComponent(name), goalType(goalType), targetValue(target), currentProgress(progress) {}

bool Goal::operator==(const Goal& other) const {
    return this->targetValue == other.targetValue;
}

void Goal::display() const {
    cout << "Goal: " << goalType << " | Target: " << targetValue << " | Current: " << currentProgress << endl;
}

Goal::~Goal() {
    cout << "Goal " << componentName << " is being deleted." << endl;
}

