#include "Workout.h"
#include "Diet.h"
#include "Goal.h"
#include "User.h"
#include "Tracker.h"
int main() {

    // Point 4: Use of new and delete for dynamic memory management
    User* dynamicUser = new User("Mohammed", 25, 65, 170);
    dynamicUser->displaySummary();
    delete dynamicUser;
    // Point 5:
    Workout w1("Morning Yoga", "Flexibility", 60, 250);  // Less than 300 calories
    Workout w2("Evening Run", "Cardio", 45, 350);  // More than 300 calories

    cout << "Original Workouts:" << endl;
    w1.display();  // Original workout1
    w2.display();  // Original workout2

    // Pass workout1 by value (copy) and workout2 by reference (original)
    adjustCalories(w1, w2);

    cout << "After Function Call:" << endl;
    w1.display();  // Should be unchanged
    w2.display();  // Should reflect the modification

    // Point 6:calling const qualified method
    const Workout workout("Morning Yoga", "Flexibility", 60, 180);
    workout.display();  // Can be called on a const objec
    showWorkoutDetails(workout); // Passing by constant reference
    // point 8 : array of pointers to objects
    Workout* workouts[] = {new Workout("Morning Run", "Flexibility", 60, 180),
                           new Workout("Evening Yoga", "Flexibility", 60, 180),
                           new Workout("Strength Training", "Strength", 45, 400)};
    displayWorkouts(workouts, 3);

    //point 9 : Destructor with Basic Functionality Demonstrated in Two Ways
    Diet diet1("Salad", "Lunch", 200, "Green vegetables"); // Automatic Destruction when out of scope
    Diet* diet2 = new Diet("Rice", "Lunch", 200, "White rice");
    delete diet2;  // Manual Destruction calling the destructor

    // point 10 : Dynamic bindings
    // Pointers to base class, but pointing to derived class objects
    FitnessComponent* fc1 = new Workout("Morning Run", "Cardio", 30, 300);
    FitnessComponent* fc2 = new Diet("Salad", "Lunch", 200, "Green vegetables");
    fc1->display();
    fc2->display();
    delete fc1;
    delete fc2;

    // point 11 : Operator overloading
    // Demonstrating the `+` operator with Workout
    Workout workout1("Morning Run", "Cardio", 30, 300);
    Workout workout2("Evening Yoga", "Flexibility", 60, 180);
    Workout combinedWorkout = workout1 + workout2;  // Uses overloaded `+` operator
    combinedWorkout.display();  // Displays combined workout details

    // Demonstrating the `==` operator with Goal
    Goal goal1("Weight Loss", "Lose Weight", 70, 65);
    Goal goal2("Fitness Maintenance", "Lose Weight", 70, 68);

    if (goal1 == goal2) {  // Uses overloaded `==` operator
        cout << "The goals have the same target value." << endl;
    } else {
        cout << "The goals have different target values." << endl;
    }

    // point 12 : Assignment Operator Overloading
    // Demonstrating the `=` operator with Workout
    Workout workout3("Evening Swim", "Swimming", 30, 300);
    workout3 = workout1 = workout2;  // Uses overloaded `=` operator
    workout3.display();
    // point 13 : Demonstrating Non-member operator overloading
    Goal fitnessGoal("Weight Loss", "Lose Weight", 70, 65);
    fitnessGoal = fitnessGoal + 5;  // Increase the target by 5
    fitnessGoal.display();
    // point 14 : object passing itself to a function (that is not part of a class)
     updateGoalProgress(fitnessGoal, 10);//this not part of the Goal class
     fitnessGoal.display();

    // Point 15: Copy Constructor example + point 7: calling a friend function
    Workout workoutcopy = workout1;  // Invokes copy constructor
    workout2.display();  // Show that workout2 is a copy of workout1
    modifyWorkoutDuration(workout1, 60);  // Change the duration of workout1
    workout1.display();  // Verify that workout1 is modified

    // Point 16: Explicit Cast
    float totalDuration = 75.6;
    int roundedDuration = static_cast<int>(totalDuration);  // Explicit cast from float to int
    cout << "Rounded Workout Duration: " << roundedDuration << " mins" << endl;

    // Point 17: Static States & Methods
    Tracker::updateCaloriesBurned(600);
    cout << "Total Calories Burned (Static): " << Tracker::getTotalCaloriesBurned << endl;

    // Example of using smart pointers and adding users to the tracker
    shared_ptr<Tracker> fitnessTracker = make_shared<Tracker>();
    shared_ptr<User> user1 = make_shared<User>("Salim", 28, 75, 180);
    shared_ptr<User> user2 = make_shared<User>("Ali", 22, 55, 160);

    // Adding workouts and diets to users
    user1->addWorkout(make_shared<Workout>("Cycling", "Cardio", 45, 500));
    user1->addDiet(make_shared<Diet>("Salad", "Lunch", 200, "Green vegetables and chicken"));
    user2->addWorkout(make_shared<Workout>("Swimming", "Flexibility", 60, 180));
    user2->setGoal(make_shared<Goal>("Lose Weight", "Weight Loss", 70, 75));

    fitnessTracker->addUser(user1);
    fitnessTracker->addUser(user2);
    fitnessTracker->displaySystemSummary();  // Display tracker system summary

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
    cout << "Final Total Calories Burned: " << Tracker::getTotalCaloriesBurned << endl;

    return 0;
}

