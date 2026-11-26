-- =====================================
-- Part 7: Appendix
-- =====================================

-- validation selects
SELECT COUNT(*) FROM workout_session;       -- Should return 90
SELECT COUNT(*) FROM workout_exercise;      -- Should return 270
SELECT COUNT(*) FROM "user";                -- Should return 15
SELECT COUNT(*) FROM dumbbell;              -- Should return 35
SELECT COUNT(*) FROM muscle_group;          -- Should return 6

-- Show how many exercises each id have
SELECT workout_id, COUNT(*) AS exercises
FROM workout_exercise
GROUP BY workout_id
ORDER BY workout_id
LIMIT 15;  -- Each session has 3 exercises


SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN ('user', 'muscle_group', 'dumbbell',
                     'workout_session', 'workout_exercise');

-- Check the structure of each table
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'workout_exercise'; -- Change here to see other tables

-- Confirm that both invalid examples from the report are rejected.
DO $$
BEGIN
    BEGIN
        INSERT INTO dumbbell (dumbbell_id, weight_kg) VALUES (36, 50);
        RAISE EXCEPTION 'Expected the 35 kg limit to reject this insert';
    EXCEPTION WHEN check_violation THEN NULL;
    END;
    BEGIN
        INSERT INTO workout_session (workout_id, user_id, workout_date, duration_minutes)
        VALUES (999, 999, DATE '2026-04-01', 45);
        RAISE EXCEPTION 'Expected the missing user to trigger a foreign key violation';
    EXCEPTION WHEN foreign_key_violation THEN NULL;
    END;
END;
$$;
