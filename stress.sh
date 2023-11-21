#!/bin/bash

# Duration in seconds for each stress period
PERIOD=10

# Maximum percentage of CPU load. Approximation, since translating percentage to stress level is not direct.
MAX_PERCENT=1

# Obtain the number of CPU cores
#CPU_CORES=$(nproc)
CPU_CORES=10
RANGE=10
# Calculate max load per CPU core (assuming 100% is full load on 1 core)
MAX_LOAD_PER_CORE=$((MAX_PERCENT * CPU_CORES))

while true; do
  number=$RANDOM
  let "number %= $RANGE"
  THIS_PERIOD=$((RANDOM % PERIOD + 1))
  # Generate random load percentage up to MAX_PERCENT for the current period
  CURRENT_LOAD=$((RANDOM % MAX_LOAD_PER_CORE + 1))

  # Calculate the stress-ng 'cpu' stressor workload. This is an approximation as stress-ng does not accept percentage.
  # You might need to calibrate 'STRESSORS' based on your CPU's performance for more accurate results.
  #STRESSORS=$((CURRENT_LOAD * CPU_CORES / 300))
  STRESSIRS=$number

  echo "Applying CPU load with $number stressor(s) for $THIS_PERIOD seconds."

  # Start the stress-ng process to load the CPU for the given period. Adjust '--cpu' to add more CPU workers if needed.
  stress-ng --cpu $number --timeout $THIS_PERIOD &

  # Capture the stress-ng PID to wait for it later
  STRESS_PID=$!

  # Wait for the stress-ng process to finish
  wait $STRESS_PID

  # Sleep some time before changing the load again
  SLEEP_TIME=$((RANDOM % PERIOD + 1))
  echo "Sleeping for $SLEEP_TIME seconds before applying the next load."
  sleep $SLEEP_TIME
done

