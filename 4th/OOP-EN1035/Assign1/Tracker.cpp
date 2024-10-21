// Tracker.cpp
#include "Tracker.h"

int Tracker::totalCaloriesBurned = 0;  // Initialize static member

void Tracker::addUser(shared_ptr<User> user) {
    users.push_back(user);
}

void Tracker::displaySystemSummary() const {
    cout << "Total Users: " << users.size() << endl;
    cout << "Total Calories Burned by All Users: " << totalCaloriesBurned << " cal" << endl;
}

void Tracker::updateCaloriesBurned(int calories) {
    totalCaloriesBurned += calories;
}

