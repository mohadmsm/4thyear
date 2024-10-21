// Tracker.h
#ifndef TRACKER_H
#define TRACKER_H

#include <vector>
#include <memory>
#include "User.h"

class Tracker {
private:
    vector<shared_ptr<User>> users;  // Vector container for users (Point 18)
    static int totalCaloriesBurned;  // Static member to track total calories (Point 17)

public:
    void addUser(shared_ptr<User> user);
    void displaySystemSummary() const;
    static void updateCaloriesBurned(int calories);  // Static method (Point 17)
};

#endif // TRACKER_H

