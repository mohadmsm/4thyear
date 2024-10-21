// Workout.h
#ifndef WORKOUT_H
#define WORKOUT_H

#include "FitnessComponent.h"

class Workout : public FitnessComponent {
private:
    string type;  // Cardio, Strength, etc.
    int duration;  // Minutes
    int caloriesBurned;

public:
    Workout(string name, string type, int duration, int calories);
    Workout(const Workout& other);  // Copy Constructor (Point 15)
    Workout& operator=(const Workout& other);  // Assignment Operator (Point 12)
    Workout operator+(const Workout& other);  // Operator Overloading (Point 11)
    void display() const override;
    ~Workout();
};

ostream& operator<<(ostream& os, const Workout& workout);  // Non-member operator overload (Point 13)

#endif // WORKOUT_H

