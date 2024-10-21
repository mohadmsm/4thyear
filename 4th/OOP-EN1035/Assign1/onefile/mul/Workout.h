#ifndef WORKOUT_H
#define WORKOUT_H

#include "FitnessComponent.h"

class Workout : public FitnessComponent {
private:
    int duration;
    int caloriesBurned;
    friend void modifyWorkoutDuration(Workout& w, int newDuration);
    friend void adjustCalories(Workout workoutByValue, Workout& workoutByReference);
protected:
    string type;
public:
    Workout(string name, string type, int duration, int calories);
    Workout(const Workout& other);
    Workout& operator=(const Workout& other);
    Workout operator+(const Workout& other);
    void display() const override;
};

void showWorkoutDetails(const Workout& w);
void adjustCalories(Workout workoutByValue, Workout& workoutByReference);

#endif // WORKOUT_H

