import boto3
import urllib.request
import os


def lambda_handler(event, context):
    url = os.getenv('URL')
    status_code = -1
    try:
        status_code = urllib.request.urlopen(url).getcode()
    except Exception as e:
        print("Url: " + url)
        print(e)

    cloudwatch = boto3.client('cloudwatch')
    cloudwatch.put_metric_data(
        MetricData=[
            {
                'MetricName': 'statusCode',
                'Dimensions': [
                    {
                        'Name': 'url',
                        'Value': url
                    }
                ],
                'Unit': 'None',
                'Value': status_code
            },
        ],
        Namespace='Monitoring'
    )
    cloudwatch.put_metric_data(
        MetricData=[
            {
                'MetricName': 'isOK',
                'Dimensions': [
                    {
                        'Name': 'url',
                        'Value': url
                    }
                ],
                'Unit': 'None',
                'Value': 1 if status_code == 200 else 0
            },
        ],
        Namespace='Monitoring'
    )

    print("Url: " + url)
    print("Status: " + str(status_code))


if __name__ == "__main__":
    print("Check url lambda")
