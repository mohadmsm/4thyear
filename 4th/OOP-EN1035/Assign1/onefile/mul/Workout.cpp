#include "Workout.h"
#include <iostream>

Workout::Workout(string name, string type, int duration, int calories)
    : FitnessComponent(name), type(type), duration(duration), caloriesBurned(calories) {}

Workout::Workout(const Workout& other)
    : FitnessComponent(other.componentName), type(other.type), duration(other.duration), caloriesBurned(other.caloriesBurned) {
    cout << "Workout copy constructor called. Creating a copy of " << other.componentName << endl;
}

Workout& Workout::operator=(const Workout& other) {
    if (this != &other) {
        componentName = other.componentName;
        type = other.type;
        duration = other.duration;
        caloriesBurned = other.caloriesBurned;
    }
    return *this;
}

Workout Workout::operator+(const Workout& other) {
    return Workout("Combined Workout", "Mixed", this->duration + other.duration, this->caloriesBurned + other.caloriesBurned);
}

void Workout::display() const {
    cout << "Workout: " << componentName << " | Type: " << type << " | Duration: " << duration << " mins | Calories: " << caloriesBurned << endl;
}

void showWorkoutDetails(const Workout& w) {
    w.display();
}

void adjustCalories(Workout workoutByValue, Workout& workoutByReference) {
    if (workoutByValue.caloriesBurned < 300) {
        workoutByValue.caloriesBurned = 300;
    }
    workoutByValue.display();
    if (workoutByReference.caloriesBurned < 300) {
        workoutByReference.caloriesBurned = 300;
    }
    workoutByReference.display();
}

void modifyWorkoutDuration(Workout& w, int newDuration) {
    w.duration = newDuration;
}

