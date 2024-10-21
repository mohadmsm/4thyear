// main.cpp
#include <iostream>
#include <memory>
#include "User.h"
#include "Workout.h"
#include "Diet.h"
#include "Goal.h"
#include "Tracker.h"

using namespace std;

int main() {
    // Point 15: Copy Constructor example
    Workout workout1("Morning Run", "Cardio", 30, 300);
    Workout workout2 = workout1;  // Invokes copy constructor
    workout2.display();  // Show that workout2 is a copy of workout1

    // Point 12: Assignment Operator Overloading
    Workout workout3("Evening Run", "Cardio", 25, 250);
    workout3 = workout1;  // Copy state from workout1 to workout3
    workout3.display();  // Verify that workout3 has the same state as workout1

    // Point 17: Static States & Methods
    Tracker::updateCaloriesBurned(600);
    cout << "Total Calories Burned (Static): " << Tracker::totalCaloriesBurned << endl;

    // Point 13: Demonstrating Non-member operator overloading
    cout << workout1 << endl;

    // Point 4: Use of new and delete for dynamic memory management
    User* dynamicUser = new User("Alice", 25, 65, 170);
    dynamicUser->displaySummary();
    delete dynamicUser;  // Proper cleanup, calls destructor

    // Example of using smart pointers and adding users to the tracker
    shared_ptr<Tracker> fitnessTracker = make_shared<Tracker>();
    shared_ptr<User> user1 = make_shared<User>("Bob", 28, 75, 180);
    shared_ptr<User> user2 = make_shared<User>("Carol", 22, 55, 160);

    // Adding workouts and diets to users
    user1->addWorkout(make_shared<Workout>("Cycling", "Cardio", 45, 500));
    user1->addDiet(make_shared<Diet>("Salad", "Lunch", 200, "Green vegetables and chicken"));

    user2->addWorkout(make_shared<Workout>("Yoga", "Flexibility", 60, 180));
    user2->setGoal(make_shared<Goal>("Lose Weight", "Weight Loss", 70, 75));

    fitnessTracker->addUser(user1);
    fitnessTracker->addUser(user2);
    fitnessTracker->displaySystemSummary();  // Display tracker system summary

    // Point 11: Demonstrate operator overloading
    Workout combinedWorkout = workout1 + workout3;  // Combine two workouts
    combinedWorkout.display();  // Check combined details

    // Point 16: Explicit Cast
    float totalDuration = 75.6;
    int roundedDuration = static_cast<int>(totalDuration);  // Explicit cast from float to int
    cout << "Rounded Workout Duration: " << roundedDuration << " mins" << endl;

    // Point 18: Using vector container
    vector<shared_ptr<User>> userArray;
    userArray.push_back(user1);
    userArray.push_back(user2);

    // Point 19: Use of for_each algorithm
    cout << "Summary of All Users:" << endl;
    for_each(userArray.begin(), userArray.end(), [](shared_ptr<User>& user) {
        user->displaySummary();
    });

    // Point 20: Shared Pointer usage
    shared_ptr<Diet> sharedDiet = make_shared<Diet>("Protein Shake", "Breakfast", 250, "Milk, banana, and protein powder");
    cout << "Use count of sharedDiet: " << sharedDiet.use_count() << endl;
    
    {
        shared_ptr<Diet> dietPtrCopy = sharedDiet;
        cout << "Use count after creating dietPtrCopy: " << sharedDiet.use_count() << endl;
    }

    cout << "Use count after dietPtrCopy goes out of scope: " << sharedDiet.use_count() << endl;

    // Static method usage (static state)
    cout << "Final Total Calories Burned: " << Tracker::totalCaloriesBurned << endl;

    return 0;
}

