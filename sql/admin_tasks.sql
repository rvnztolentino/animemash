-- ==========================================
-- 1. VERIFY AUTOMATIC RESET
-- ==========================================
-- Run this query to see if your monthly reset cron job is scheduled.
-- You should see a job that calls a function (likely 'reset_monthly' or similar) 
-- scheduled for '0 0 1 * *' (Midnight on the 1st of every month).
SELECT * FROM cron.job;


-- ==========================================
-- 2. SETUP MANUAL RESET COMMAND
-- ==========================================
-- Run this entire block ONE TIME to create the 'reset_rankings' function.
-- This function allows you to manually reset the leaderboard safely.

CREATE OR REPLACE FUNCTION reset_rankings()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Clear all voting history
  TRUNCATE TABLE votes;
  
  -- Reset all characters to default values
  UPDATE characters 
  SET elo_rating = 1500, 
      wins = 0, 
      losses = 0;
END;
$$;


-- ==========================================
-- 3. EXECUTE MANUAL RESET
-- ==========================================
-- Run this line whenever you want to immediately wipe all data and reset Elos.
-- WARNING: This cannot be undone!

SELECT reset_rankings();
