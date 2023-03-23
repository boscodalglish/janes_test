import boto3
import json
def lambda_handler(event, context):


s3 = boto3.client("s3")

s31 = boto3.resource("s3")

bucket ="my-test-s3-bucket-sspsinha"

prefix = ""

suffix = "csv"

kwargs = {"Bucket": bucket}
if isinstance(prefix, str):
    kwargs["Prefix"] = prefix
    list = []
    resp = s3.list_objects_v2(**kwargs)
    contents = resp["Contents"]
for con in contents:
   if con["Key"].endswith(suffix):
      list.append(con["Key"])  
      copy_source = {
           "Bucket": bucket,
           "Key": con["Key"]
        }
s31.meta.client.copy(copy_source, bucket, con["Key"].split(".")[0] +".txt")
s3.delete_object(Bucket=bucket, Key=con["Key"])
return list
