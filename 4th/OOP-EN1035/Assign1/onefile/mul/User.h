#ifndef USER_H
#define USER_H

#include <string>
#include <vector>
#include <memory>
#include "Workout.h"
#include "Diet.h"
#include "Goal.h"

using namespace std;

class User {
private:
    string userName;
    int age, weight, height;
    vector<shared_ptr<Workout>> workoutList;  // Using smart pointers
    vector<shared_ptr<Diet>> dietList;
    shared_ptr<Goal> fitnessGoal;

public:
    User(string name, int age, int weight, int height);
    void addWorkout(shared_ptr<Workout> workout);
    void addDiet(shared_ptr<Diet> diet);
    void setGoal(shared_ptr<Goal> goal);
    void displaySummary() const;
    ~User();
};

#endif // USER_H

