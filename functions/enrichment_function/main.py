import base64
import json
import os
from google.cloud import bigquery

# Initialize BigQuery client outside the function scope for better performance (warm starts)
client = bigquery.Client()
DATASET_ID = os.environ.get('DATASET_ID', 'iot_analytics_ds')
TABLE_ID = os.environ.get('TABLE_ID', 'enriched_telemetry')

def enrich_iot_data(event, context):
    """Triggered from a message on a Cloud Pub/Sub topic.
    Args:
         event (dict): Event payload.
         context (google.cloud.functions.Context): Metadata for the event.
    """
    # 1. Decode the Pub/Sub message
    pubsub_message = base64.b64decode(event['data']).decode('utf-8')
    data = json.loads(pubsub_message)

    # 2. Enrichment Logic
    # Example: Adding a processing timestamp and a 'region' based on device_id
    data['processed_at'] = context.timestamp
    data['region'] = "EMEA" if data.get('device_id', '').startswith('EU') else "US-EAST"
    
    # 3. Business Logic Enrichment (e.g., Status Normalization)
    if data.get('temperature', 0) > 85:
        data['alert_level'] = 'CRITICAL'
    else:
        data['alert_level'] = 'NORMAL'

    # 4. Stream into BigQuery
    table_ref = client.dataset(DATASET_ID).table(TABLE_ID)
    errors = client.insert_rows_json(table_ref, [data])

    if errors:
        print(f"Enrichment Error: {errors}")
    else:
        print(f"Successfully enriched and stored message from device: {data.get('device_id')}")