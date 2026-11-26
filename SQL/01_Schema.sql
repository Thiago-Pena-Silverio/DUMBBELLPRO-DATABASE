-- =====================================
-- Part 1: Create Database Schema
-- =====================================

-- Run this script in a new database.

-- Create USER table to store app users
CREATE TABLE "user" (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    fitness_goal VARCHAR(50) NOT NULL,
    join_date DATE NOT NULL,
    total_sessions INTEGER DEFAULT 0 CHECK (total_sessions >= 0)
);

-- Create MUSCLE_GROUP table to define target muscle areas
CREATE TABLE muscle_group (
    muscle_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE CHECK (name IN ('Biceps', 'Chest', 'Abs', 'Glutes', 'Calves', 'Squats')),
    body_part VARCHAR(20) NOT NULL CHECK (body_part IN ('Upper Body', 'Lower Body'))
);

-- Create DUMBBELL table to store available dumbbell weights
CREATE TABLE dumbbell (
    dumbbell_id SERIAL PRIMARY KEY,
    weight_kg DECIMAL(4,1) NOT NULL CHECK (weight_kg > 0 AND weight_kg <= 35)
);

-- Create WORKOUT_SESSION table to track each user's training sessions
CREATE TABLE workout_session (
    workout_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES "user"(user_id) ON DELETE CASCADE,
    workout_date DATE NOT NULL,
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0 AND duration_minutes <= 180)
);

-- Create WORKOUT_EXERCISE table to store exercises done in each session
CREATE TABLE workout_exercise (
    workoutex_id SERIAL PRIMARY KEY,
    workout_id INTEGER NOT NULL REFERENCES workout_session(workout_id) ON DELETE CASCADE,
    muscle_group_id INTEGER NOT NULL REFERENCES muscle_group(muscle_id),
    dumbbell_id INTEGER NOT NULL REFERENCES dumbbell(dumbbell_id),
    sets INTEGER NOT NULL CHECK (sets >= 1 AND sets <= 10),
    rep_min INTEGER NOT NULL CHECK (rep_min >= 1),
    rep_max INTEGER CHECK (rep_max >= rep_min AND rep_max <= 30),
    session_notes TEXT
);

-- =====================================
-- Part 2: Create Indexes
-- =====================================

-- Create indexes to improve performance on common queries
CREATE INDEX idx_user_id ON workout_session(user_id);
CREATE INDEX idx_workout_date ON workout_session(workout_date);
CREATE INDEX idx_muscle_group_id ON workout_exercise(muscle_group_id);
