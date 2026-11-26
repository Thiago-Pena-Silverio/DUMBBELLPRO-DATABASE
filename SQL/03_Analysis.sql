-- =====================================
-- Part 6: Query Implementation
-- =====================================

-- 1️ Top 3 users with the most workout sessions
-- Purpose: Find the most active users to reward or study their habits
SELECT u.user_id, u.name, COUNT(ws.workout_id) AS total_sessions
FROM "user" u
JOIN workout_session ws ON u.user_id = ws.user_id
GROUP BY u.user_id, u.name
ORDER BY total_sessions DESC
LIMIT 3;

-- 2️ Most trained muscle groups (by total sets)
-- Purpose: See which muscle groups are most commonly trained across all users
SELECT mg.name AS muscle_group, SUM(we.sets) AS total_sets
FROM muscle_group mg
JOIN workout_exercise we ON mg.muscle_id = we.muscle_group_id
GROUP BY mg.name
ORDER BY total_sets DESC;

-- 3️ Average dumbbell weight used per body part
-- Purpose: Understand how heavy users typically lift for upper vs lower body
SELECT mg.body_part,
       ROUND(AVG(d.weight_kg)::numeric, 2) AS avg_weight_kg
FROM workout_exercise we
JOIN dumbbell d ON we.dumbbell_id = d.dumbbell_id
JOIN muscle_group mg ON we.muscle_group_id = mg.muscle_id
GROUP BY mg.body_part;

-- 4️ Average number of sets per workout session
-- Purpose: Measure how intense a typical session is (based on total sets)
SELECT ROUND(AVG(session_sets)::numeric, 2) AS avg_sets_per_session
FROM (
  SELECT workout_id, SUM(sets) AS session_sets
  FROM workout_exercise
  GROUP BY workout_id
) s;

-- 5️ Average session duration per user
-- Purpose: See how long each user usually trains — useful for personalization
SELECT u.user_id, u.name, ROUND(AVG(ws.duration_minutes)::numeric, 2) AS avg_duration_minutes
FROM "user" u
JOIN workout_session ws ON u.user_id = ws.user_id
GROUP BY u.user_id, u.name
ORDER BY avg_duration_minutes DESC;

-- 6️ Total training volume per user
-- Purpose: Calculate total workload: sets × average reps × dumbbell weight
-- Note: Estimate average reps as (rep_min + rep_max) / 2
SELECT u.user_id, u.name,
       ROUND(SUM(we.sets * ((we.rep_min + we.rep_max)/2.0) * d.weight_kg)::numeric, 2) AS total_volume
FROM "user" u
JOIN workout_session ws ON u.user_id = ws.user_id
JOIN workout_exercise we ON ws.workout_id = we.workout_id
JOIN dumbbell d ON we.dumbbell_id = d.dumbbell_id
GROUP BY u.user_id, u.name
ORDER BY total_volume DESC;

-- 7️ Inactive users (no workouts in the last 7 days)
-- Purpose: Identify users who might need a reminder or motivation
SELECT u.user_id, u.name, MAX(ws.workout_date) AS last_workout_date
FROM "user" u
LEFT JOIN workout_session ws ON u.user_id = ws.user_id
GROUP BY u.user_id, u.name
HAVING MAX(ws.workout_date) IS NULL OR MAX(ws.workout_date) < CURRENT_DATE - INTERVAL '7 days'
ORDER BY last_workout_date NULLS FIRST;

-- 8️ Heaviest dumbbell used per muscle group
-- Purpose: See the maximum weight used for each muscle group — useful for safety and programming
SELECT mg.name AS muscle_group, MAX(d.weight_kg) AS heaviest_weight_kg
FROM muscle_group mg
JOIN workout_exercise we ON mg.muscle_id = we.muscle_group_id
JOIN dumbbell d ON we.dumbbell_id = d.dumbbell_id
GROUP BY mg.name
ORDER BY heaviest_weight_kg DESC;
