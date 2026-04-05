import requests
import json
import time
import random
from datetime import datetime

# --- Configuration ---
# Replace with your actual Cloud Function URL after deployment
INGEST_URL = "https://your-cloud-function-url.a.run.app"
DEVICE_IDS = ["SENSOR-EA-01", "SENSOR-EA-02", "SENSOR-US-01", "SENSOR-US-02"]
INTERVAL_SECONDS = 5  # Frequency of data generation

def generate_telemetry(device_id):
    """Generates realistic sensor data with a slight random walk."""
    # Base values
    base_temp = 22.0
    base_hum = 45.0
    
    return {
        "device_id": device_id,
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "temperature": round(random.normalvariate(base_temp, 2.5), 2),
        "humidity": round(random.normalvariate(base_hum, 5.0), 2),
        "status": random.choice(["HEALTHY", "HEALTHY", "HEALTHY", "MAINTENANCE_REQ"]),
        "type": "environmental_sensor"
    }

def start_simulation():
    print(f"Starting IoT Simulation. Sending to: {INGEST_URL}")
    print("Press Ctrl+C to stop.")
    
    try:
        while True:
            for dev_id in DEVICE_IDS:
                payload = generate_telemetry(dev_id)
                
                try:
                    response = requests.post(
                        INGEST_URL, 
                        json=payload,
                        headers={"Content-Type": "application/json"},
                        timeout=5
                    )
                    
                    if response.status_code in [200, 202]:
                        print(f"[{payload['timestamp']}] Sent data for {dev_id}: {payload['temperature']}°C")
                    else:
                        print(f"Failed to send: {response.status_code} - {response.text}")
                
                except requests.exceptions.RequestException as e:
                    print(f"Connection Error: {e}")

            time.sleep(INTERVAL_SECONDS)
            
    except KeyboardInterrupt:
        print("\nSimulation stopped by user.")

if __name__ == "__main__":
    start_simulation()