import os
import json
from pymediainfo import MediaInfo

def hello(event, context):
    event_obj = json.loads(event["body"])
    url = event_obj['url']
    print url
    os.system("ls layer/")
    media_info = MediaInfo.parse(url, library_file='layer/libmediainfo.so.0').to_data()
    print media_info
    return {
        "statusCode": 200,
        "body": json.dumps(media_info, indent=2)
    }
