// User.cpp
#include "User.h"

User::User(string name, int age, int weight, int height)
    : userName(name), age(age), weight(weight), height(height) {}

void User::addWorkout(shared_ptr<Workout> workout) {
    workoutList.push_back(workout);
}

void User::addDiet(shared_ptr<Diet> diet) {
    dietList.push_back(diet);
}

void User::setGoal(shared_ptr<Goal> goal) {
    fitnessGoal = goal;
}

void User::displaySummary() const {
    cout << "User: " << userName << endl;
    cout << "Age: " << age << ", Weight: " << weight << "kg, Height: " << height << "cm" << endl;

    cout << "Workouts:" << endl;
    for (const auto& workout : workoutList) {
        workout->display();
    }

    cout << "Diet:" << endl;
    for (const auto& diet : dietList) {
        diet->display();
    }

    if (fitnessGoal) {
        cout << "Fitness Goal:" << endl;
        fitnessGoal->display();
    }
}

User::~User() {
    cout << "User " << userName << " is being deleted." << endl;
}

