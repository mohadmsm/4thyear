// Goal.h
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
    void setGoal(string goalType, int target);
    bool operator==(const Goal& other) const;  // Operator Overloading (Point 11)
    void display() const override;
    ~Goal();
};

#endif // GOAL_H

