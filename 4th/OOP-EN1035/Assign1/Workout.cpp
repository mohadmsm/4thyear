// Workout.cpp
#include "Workout.h"

Workout::Workout(string name, string type, int duration, int calories)
    : FitnessComponent(name), type(type), duration(duration), caloriesBurned(calories) {}

Workout::Workout(const Workout& other)
    : FitnessComponent(other.componentName), type(other.type), duration(other.duration), caloriesBurned(other.caloriesBurned) {}

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

ostream& operator<<(ostream& os, const Workout& workout) {
    os << workout.componentName << " (" << workout.type << ") - " << workout.caloriesBurned << " cal";
    return os;
}

Workout::~Workout() {
    cout << "Workout " << componentName << " is being deleted." << endl;
}

