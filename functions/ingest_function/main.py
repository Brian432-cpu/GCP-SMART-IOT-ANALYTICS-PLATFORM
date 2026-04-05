import os
import json
import base64
from flask import jsonify
from google.cloud import pubsub_v1

# Initialize Pub/Sub client outside the function to leverage warm starts
publisher = pubsub_v1.PublisherClient()
PROJECT_ID = os.environ.get('GCP_PROJECT')
TOPIC_ID = os.environ.get('TOPIC_ID', 'iot-raw-data')

def ingest_iot_data(request):
    """
    HTTP Cloud Function to ingest IoT telemetry.
    Args:
        request (flask.Request): The logic expects a JSON payload.
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`.
    """
    # 1. Basic Security/Method Check
    if request.method != 'POST':
        return jsonify({"error": "Only POST requests are accepted"}), 405

    request_json = request.get_json(silent=True)
    
    # 2. Validation
    if not request_json or 'device_id' not in request_json:
        return jsonify({"error": "Invalid payload: 'device_id' is required"}), 400

    try:
        # 3. Prepare message for Pub/Sub
        topic_path = publisher.topic_path(PROJECT_ID, TOPIC_ID)
        data_string = json.dumps(request_json)
        data_bytes = data_string.encode("utf-8")

        # 4. Publish to Topic
        # We can also add attributes for server-side filtering later
        future = publisher.publish(
            topic_path, 
            data_bytes, 
            device_id=request_json['device_id'],
            sensor_type=request_json.get('type', 'unknown')
        )
        message_id = future.result()

        return jsonify({
            "status": "success",
            "message_id": message_id,
            "device_id": request_json['device_id']
        }), 202

    except Exception as e:
        print(f"Error publishing to Pub/Sub: {e}")
        return jsonify({"error": "Internal Server Error"}), 500