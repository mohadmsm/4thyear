#include "Goal.h"
#include <iostream>

Goal::Goal(string name, string goalType, int target, int progress)
    : FitnessComponent(name), goalType(goalType), targetValue(target), currentProgress(progress) {}

bool Goal::operator==(const Goal& other) const {
    return this->targetValue == other.targetValue;
}

int Goal::getTargetValue() const { return targetValue; }
int Goal::getCurrentProgress() const { return currentProgress; }
void Goal::setCurrentProgress(int progress) { currentProgress = progress; }
string Goal::getGoalType() const { return goalType; }
string Goal::getComponentName() const { return componentName; }

void Goal::display() const {
    cout << "Goal: " << goalType << " | Target: " << targetValue << " | Current: " << currentProgress << endl;
}

Goal::~Goal() {
    cout << "Goal " << componentName << " is being deleted." << endl;
}

Goal operator+(const Goal& goal, int extraTarget) {
    int newTarget = goal.getTargetValue() + extraTarget;
    return Goal(goal.getComponentName(), goal.getGoalType(), newTarget, goal.getCurrentProgress());
}

void updateGoalProgress(Goal& goal, int increment) {
    goal.setCurrentProgress(goal.getCurrentProgress() + increment);
}

