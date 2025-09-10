import json
import os
import urllib.request

def lambda_handler(event, context):
    webhook_url = os.environ['TEAMS_WEBHOOK_URL']
    environment = os.environ.get('ENVIRONMENT', 'unknown')

    # Extract data from SNS event
    record = event['Records'][0]['Sns']
    sns_message = json.loads(record['Message'])
    sns_subject = record.get('Subject', 'No Subject')
    sns_topic_arn = record['TopicArn']

    # Extract alarm details from SNS message
    alarm_name = sns_message.get('AlarmName', 'Unknown Alarm')
    alarm_description = sns_message.get('AlarmDescription', 'No description')
    new_state = sns_message.get('NewStateValue', 'Unknown')
    reason = sns_message.get('NewStateReason', 'No reason provided')
    metric_name = sns_message.get('Trigger', {}).get('MetricName', 'N/A')

    # Set theme color based on environment
    if environment.lower() == "staging":
        theme_color = "d13212"  # Red
    else:
        theme_color = "00ff00"  # Green

    # Prepare the message card for Microsoft Teams
    message_card = {
        "@type": "MessageCard",
        "@context": "http://schema.org/extensions",
        "summary": f"AWS Alarm - {environment.upper()}",
        "themeColor": theme_color,
        "title": f"**AWS Alarm - {environment.upper()}**",
        "sections": [
            {
                "activityTitle": f"🔔 **Alarm:** {alarm_name}",
                "activitySubtitle": f"Environment: {environment.upper()}",
                "facts": [
                    {"name": "State", "value": new_state},
                    {"name": "Description", "value": alarm_description},
                    {"name": "Metric", "value": metric_name},
                    {"name": "Reason", "value": reason}
                ],
                "markdown": True
            },
            {
                # Add a collapsible section for full SNS message details
                "text": "<details><summary>🔍 **Full SNS Message**</summary>\n\n```json\n" + json.dumps(sns_message, indent=2) + "\n```</details>"
            }
        ]
    }

    # Set custom headers (User-Agent can be customized but actual sender in Teams is defined by the webhook)
    headers = {
        'Content-Type': 'application/json',
        'User-Agent': 'AWS Alarm Notification'
    }

    # Send the message to Microsoft Teams webhook
    data = json.dumps(message_card).encode('utf-8')
    req = urllib.request.Request(webhook_url, data=data, headers=headers)

    try:
        with urllib.request.urlopen(req) as response:
            response.read()
        print("Message sent to Microsoft Teams successfully!")
    except Exception as e:
        print(f"Error sending message: {e}")

    return {
        'statusCode': 200,
        'body': json.dumps('Notification sent')
    }