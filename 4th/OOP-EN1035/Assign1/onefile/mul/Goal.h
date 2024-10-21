#ifndef GOAL_H
#define GOAL_H

#include "FitnessComponent.h"

class Goal : public FitnessComponent {
private:
    string goalType;
    int targetValue;
    int currentProgress;
public:
    Goal(string name, string goalType, int target, int progress);
    bool operator==(const Goal& other) const;
    int getTargetValue() const;
    int getCurrentProgress() const;
    void setCurrentProgress(int progress);
    string getGoalType() const;
    string getComponentName() const;
    void display() const override;
    ~Goal();
};

Goal operator+(const Goal& goal, int extraTarget);
void updateGoalProgress(Goal& goal, int increment);

#endif // GOAL_H

