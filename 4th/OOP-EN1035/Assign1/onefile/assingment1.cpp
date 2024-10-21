#include <iostream>
#include <vector>
#include <memory>
#include <algorithm>
#include <string>

using namespace std;

// Base Class: FitnessComponent
class FitnessComponent {
protected:
    string componentName;
public:
    FitnessComponent(string name) : componentName(name) {}
    virtual void display() const = 0;  // Pure virtual function (Point 3)
    virtual ~FitnessComponent() {}  // Virtual destructor (Point 9)
};

// Workout Class
class Workout : public FitnessComponent {
private:
    int duration;  // Minutes
    int caloriesBurned;
        // Declare friend function
    friend void modifyWorkoutDuration(Workout& w, int newDuration);
protected:
    string type;// ie. cardio, strength
public:
    Workout(string name, string type, int duration, int calories)
        : FitnessComponent(name), type(type), duration(duration), caloriesBurned(calories) {}
    Workout(const Workout& other)  // Copy Constructor (Point 15)
        : FitnessComponent(other.componentName), type(other.type), duration(other.duration), caloriesBurned(other.caloriesBurned) 
    {cout << "Workout copy constructor called. Creating a copy of " << other.componentName << endl;}
    Workout& operator=(const Workout& other) {  // Assignment Operator (Point 12)
        if (this != &other) {
            componentName = other.componentName;
            type = other.type;
            duration = other.duration;
            caloriesBurned = other.caloriesBurned;
        }
        return *this;
    }
    Workout operator+(const Workout& other) {  // Operator Overloading (Point 11)
        return Workout("Combined Workout", "Mixed", this->duration + other.duration, this->caloriesBurned + other.caloriesBurned);
    }

    void display() const override {
        cout << "Workout: " << componentName << " | Type: " << type << " | Duration: " << duration << " mins | Calories: " << caloriesBurned << endl;
    }
     friend void adjustCalories(Workout workoutByValue, Workout& workoutByReference);  
};


void showWorkoutDetails(const Workout& w) {
    w.display();  // Can only call const-qualified methods on 'w'
}
//point 5
void adjustCalories(Workout workoutByValue, Workout& workoutByReference) {
    cout << "Adjusting calories if below 300..." << endl;

    // Modify the copied workout (passed by value)
    if (workoutByValue.caloriesBurned < 300) {
        workoutByValue.caloriesBurned = 300;  // Only modifies the copy
    }
    workoutByValue.display();  // Shows modified copy (original remains unchanged)

    // Modify the referenced workout (passed by reference)
    if (workoutByReference.caloriesBurned < 300) {
        workoutByReference.caloriesBurned = 300;  // Modifies the original workout
    }
    workoutByReference.display();  // Shows modified original workout
}

// Modifier function
void modifyWorkoutDuration(Workout& w, int newDuration) {
    w.duration = newDuration;
}
// Diet Class
class Diet : public FitnessComponent {
private:
    string mealType;  // Breakfast, Lunch, etc.
    int calories;
    string description;

public:
    Diet(string name, string mealType, int calories, string description)
        : FitnessComponent(name), mealType(mealType), calories(calories), description(description) {}
    void display() const override {
        cout << "Diet: " << componentName << " | Meal: " << mealType << " | Calories: " << calories << " | Description: " << description << endl;
    }
    ~Diet() {
        cout << "Diet " << componentName << " is being deleted." << endl;
    }
};

// Goal Class
class Goal : public FitnessComponent {
private:
    string goalType;
    int targetValue;
    int currentProgress;

public:
    Goal(string name, string goalType, int target, int progress)
        : FitnessComponent(name), goalType(goalType), targetValue(target), currentProgress(progress) {}
    bool operator==(const Goal& other) const {  // Operator Overloading (Point 11)
        return this->targetValue == other.targetValue;
    }
    // Getter methods for private members for point 13 friend function can be used as well
    int getTargetValue() const { return targetValue; }
    int getCurrentProgress() const  { return currentProgress; }
    void setCurrentProgress(int progress) { currentProgress = progress; } // point 14:mutator method to be called in a function and change the object state.
    string getGoalType() const { return goalType; }
    string getComponentName() const { return componentName; }
    void display() const override {
        cout << "Goal: " << goalType << " | Target: " << targetValue << " | Current: " << currentProgress << endl;
    }
    ~Goal() {
        cout << "Goal " << componentName << " is being deleted." << endl;
    }
};

// Non-member operator function to adjust target value
Goal operator+(const Goal& goal, int extraTarget) {
    int newTarget = goal.getTargetValue() + extraTarget;
    return Goal(goal.getComponentName(), goal.getGoalType(), newTarget,goal.getCurrentProgress());
}

// Define the external function that modifies the state of the Goal object
void updateGoalProgress(Goal& goal, int increment) {
    goal.setCurrentProgress(goal.getCurrentProgress() + increment);// point 14 modify the object state
}

// User Class
class User {
private:
    string userName;
    int age, weight, height;
    vector<shared_ptr<Workout>> workoutList;  // Using smart pointers (Point 20)
    vector<shared_ptr<Diet>> dietList;
    shared_ptr<Goal> fitnessGoal;

public:
    User(string name, int age, int weight, int height)
        : userName(name), age(age), weight(weight), height(height) {}
    void addWorkout(shared_ptr<Workout> workout) {
        workoutList.push_back(workout);
    }
    void addDiet(shared_ptr<Diet> diet) {
        dietList.push_back(diet);
    }
    void setGoal(shared_ptr<Goal> goal) {
        fitnessGoal = goal;
    }
    void displaySummary() const {
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
    ~User() {
        cout << "User " << userName << " is being deleted." << endl;
    }
};

// Tracker Class
class Tracker {
private:
    vector<shared_ptr<User>> users;  // Vector container for users (Point 18)
    static int totalCaloriesBurned;  // Static member to track total calories (Point 17)
public:
    void addUser(shared_ptr<User> user) {
        users.push_back(user);
    }
    void displaySystemSummary() const {
        cout << "Total Users: " << users.size() << endl;
        cout << "Total Calories Burned by All Users: " << totalCaloriesBurned << " cal" << endl;
    }
    static void updateCaloriesBurned(int calories) {  // Static method (Point 17)
        totalCaloriesBurned += calories;
    }
    static int getTotalCaloriesBurned() {
	return totalCaloriesBurned;
    }
};

void displayWorkouts(Workout* workouts[], int size) {
    for (int i = 0; i < size; ++i) {
        workouts[i]->display();  // Call display() on each Workout object
    }
}


int Tracker::totalCaloriesBurned = 0;  // Initialize static member

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

