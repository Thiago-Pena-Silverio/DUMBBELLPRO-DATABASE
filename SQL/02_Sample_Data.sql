-- =====================================
-- Part 3: Create Inserts
-- =====================================

-- Insert 15 users with realistic names, emails, fitness goals, and join dates
-- These users will be used to simulate different training behaviors in the app
INSERT INTO "user" (name, email, fitness_goal, join_date, total_sessions) VALUES
('John Doe', 'john.doe@example.com', 'Strength', '2026-02-01', 0),
('Maria Silva', 'maria.silva@example.com', 'Hypertrophy', '2026-02-05', 0),
('Pedro Santos', 'pedro.santos@example.com', 'Endurance', '2026-02-08', 0),
('Ana Costa', 'ana.costa@example.com', 'Fat Loss', '2026-02-10', 0),
('Lucas Oliveira', 'lucas.oliveira@example.com', 'Strength', '2026-02-12', 0),
('Sofia Pereira', 'sofia.pereira@example.com', 'Hypertrophy', '2026-02-15', 0),
('Gabriel Lima', 'gabriel.lima@example.com', 'Endurance', '2026-02-18', 0),
('Isabela Rocha', 'isabela.rocha@example.com', 'Fat Loss', '2026-02-20', 0),
('Mateus Ferreira', 'mateus.ferreira@example.com', 'Strength', '2026-02-22', 0),
('Julia Almeida', 'julia.almeida@example.com', 'Hypertrophy', '2026-02-25', 0),
('Thiago Pena', 'thiago.pena@example.com', 'Endurance', '2026-03-01', 0),  
('Carla Souza', 'carla.souza@example.com', 'Fat Loss', '2026-03-03', 0),
('Rafael Mendes', 'rafael.mendes@example.com', 'Strength', '2026-03-05', 0),
('Beatriz Nunes', 'beatriz.nunes@example.com', 'Hypertrophy', '2026-03-07', 0),
('Diego Castro', 'diego.castro@example.com', 'Endurance', '2026-03-10', 0);

-- Insert 35 dumbbells from 1kg to 35kg (1kg increments)
-- These represent the available dumbbell weights in the app
INSERT INTO dumbbell (weight_kg) VALUES
(1.0),(2.0),(3.0),(4.0),(5.0),(6.0),(7.0),(8.0),(9.0),(10.0),
(11.0),(12.0),(13.0),(14.0),(15.0),(16.0),(17.0),(18.0),(19.0),(20.0),
(21.0),(22.0),(23.0),(24.0),(25.0),(26.0),(27.0),(28.0),(29.0),(30.0),
(31.0),(32.0),(33.0),(34.0),(35.0);

-- Insert 6 muscle groups 
-- Each muscle group is linked to a body part (Upper or Lower Body)
INSERT INTO muscle_group (name, body_part) VALUES
('Biceps', 'Upper Body'),
('Chest', 'Upper Body'),
('Abs', 'Upper Body'),
('Glutes', 'Lower Body'),
('Calves', 'Lower Body'),
('Squats', 'Lower Body');

-- =====================================
-- Part 4: Generate Workout Session
-- =====================================

-- Generate 90 workout sessions with varied session counts per user
-- Each user gets a different number of sessions (between 4 and 8), totaling 90
WITH user_sessions AS (
  SELECT * FROM (VALUES
    (1, 6), (2, 5), (3, 7), (4, 4), (5, 8),
    (6, 6), (7, 5), (8, 7), (9, 4), (10, 6),
    (11, 8), (12, 6), (13, 7), (14, 5), (15, 6)
  ) AS t(user_id, session_count)
),
expanded_sessions AS (
  -- Create one row per session for each user
  SELECT us.user_id, generate_series(1, us.session_count) AS session_num
  FROM user_sessions us
),
final_sessions AS (
  -- Assign a random workout date (within 14 days) and duration (30–75 minutes)
  SELECT
    user_id,
    DATE '2026-03-01' + (FLOOR(random() * 14))::int AS workout_date,
    30 + (FLOOR(random() * 46))::int AS duration_minutes
  FROM expanded_sessions
)
-- Insert the generated sessions into the workout_session table
INSERT INTO workout_session (user_id, workout_date, duration_minutes)
SELECT user_id, workout_date, duration_minutes
FROM final_sessions;

-- =====================================
-- Part 5: Generate Workout Exercises
-- =====================================

-- Generate 270 workout exercises with three per session
-- Assumes 90 workout_session rows with workout_id 1 to 90
INSERT INTO workout_exercise (
  workout_id, muscle_group_id, dumbbell_id, sets, rep_min, rep_max, session_notes
)
SELECT
  ws.workout_id,
  ((ws.workout_id + ex) % 6) + 1 AS muscle_group_id,
  ((ws.workout_id * ex) % 35) + 1 AS dumbbell_id,
  3 + (ex % 3) AS sets,
  6 + (ex % 5) AS rep_min,
  8 + (ex % 5) AS rep_max,
  CASE ex
    WHEN 1 THEN 'Focus on form'
    WHEN 2 THEN 'Increase weight next session'
    ELSE 'Maintain tempo'
  END AS session_notes
FROM workout_session ws
CROSS JOIN generate_series(1,3) AS ex;
