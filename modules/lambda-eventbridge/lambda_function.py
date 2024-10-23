import json
import boto3
import base64
import os


ses_client = boto3.client('ses')

def lambda_handler(event, context):

    # Get the environment variables for the dynamic source and destination emails
    source_email = os.environ['SOURCE_EMAIL']
    destination_emails = os.environ['DESTINATION_EMAILS'].split(',')
    # Extract the findings array from the event
    findings = event['detail']['findings']
    
    if not findings:
        return {
            'statusCode': 400,
            'body': json.dumps('No findings available')
        }

    # Get the first finding (assuming you want to handle one finding at a time)
    finding = findings[0]
    
    # Simplified notification for the email body
    simple_notification = {
        'accountId': finding.get('AwsAccountId'),
        'Description': finding.get('Description'),
        'FindingProviderFields': finding.get('FindingProviderFields', {}),
        'Region': finding.get('Region'),
        'SourceUrl': finding.get('SourceUrl'),
        'Title': finding.get('Title')
    }

    # Full notification details for the attachment in text format
    full_notification_text = (
        f"Account ID: {finding.get('AwsAccountId')}\n"
        f"Created At: {finding.get('CreatedAt')}\n"
        f"Description: {finding.get('Description')}\n"
        f"Finding Provider Fields: {json.dumps(finding.get('FindingProviderFields', {}), indent=4)}\n"
        f"First Observed At: {finding.get('FirstObservedAt')}\n"
        f"Generator ID: {finding.get('GeneratorId')}\n"
        f"ID: {finding.get('Id')}\n"
        f"Last Observed At: {finding.get('LastObservedAt')}\n"
        f"Processed At: {finding.get('ProcessedAt')}\n"
        f"Product ARN: {finding.get('ProductArn')}\n"
        f"Region: {finding.get('Region')}\n"
        f"Resources: {json.dumps(finding.get('Resources', []), indent=4)}\n"
        f"Source URL: {finding.get('SourceUrl')}\n"
        f"Title: {finding.get('Title')}\n"
        f"Types: {json.dumps(finding.get('Types', []), indent=4)}\n"
    )

    # Create attachment in text format
    attachment = {
        'ContentType': 'text/plain',
        'Content': base64.b64encode(full_notification_text.encode('utf-8')).decode('utf-8'),
        'FileName': 'full_finding_details.json'
    }

    # Extract severity label and finding type for the subject
    severity_label = finding.get('FindingProviderFields', {}).get('Severity', {}).get('Label', 'UNKNOWN')
    finding_type = finding.get('FindingProviderFields', {}).get('Types', [None])[0]  # Get the first type
    subject = f"{severity_label}-{finding_type}" if finding_type else "Finding Notification"

    # Email body with simplified notification
    email_body = f"""
    GuardDuty Finding Notification:

    Account ID: {simple_notification['accountId']}
    Description: {simple_notification['Description']}
    Severity: {simple_notification['FindingProviderFields'].get('Severity', {}).get('Label', 'UNKNOWN')}
    Region: {simple_notification['Region']}
    Title: {simple_notification['Title']}
    For more details, visit: {simple_notification['SourceUrl']}
    """

    # Send the email via SES with the attachment
    response = ses_client.send_raw_email(
        Source=source_email,
        Destinations=destination_emails,
        RawMessage={
            'Data': build_raw_email(
                subject=subject,
                body=email_body,
                attachment=attachment
            )
        }
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Email sent with attachment!')
    }

def build_raw_email(subject, body, attachment):
    boundary = 'NextPartBoundary'
    
    raw_email = f"Subject: {subject}\n"
    raw_email += f"Content-Type: multipart/mixed; boundary=\"{boundary}\"\n\n"
    
    # Email body
    raw_email += f"--{boundary}\n"
    raw_email += "Content-Type: text/plain; charset=utf-8\n\n"
    raw_email += f"{body}\n\n"
    
    # Attachment in text format
    raw_email += f"--{boundary}\n"
    raw_email += f"Content-Type: {attachment['ContentType']}; name=\"{attachment['FileName']}\"\n"
    raw_email += "Content-Transfer-Encoding: base64\n"
    raw_email += f"Content-Disposition: attachment; filename=\"{attachment['FileName']}\"\n\n"
    raw_email += f"{attachment['Content']}\n"
    
    raw_email += f"--{boundary}--"
    
    return raw_email
