# serverless-mediainfo

A serverless function to get the mediainfo of the asset URL

This project is a serverless deployment of AWS Lambda function using Python 2.7 and libMediaInfo and pymediainfo to get metadata/media information of a video file accessed through URL.

The project is inspired from https://github.com/iandow/mediainfo_aws_lambda

Compilation of the libmediainfo is done in amazonlinux base image. Currently the project uses the libmediainfo - v20.03

To add the URL parsing support to the mediainfo, we use the libcurl-devel in yum repository and compile the libmediainfo (already taken care in the default script SO_Compile.sh provided by mediainfo). Lambda layer approach is not used as of now.

PyMediaInfo (https://pypi.org/project/pymediainfo/) is used as a wrapper around the Mediainfo


### Prerequisite

> Python 2.7

> python-pip

> serverless



### Installation 

Install the required packages - serverless and deploy the serverless function

```sh
$ cd serverless-mediainfo
$ chmod +x test.sh
$ ./test.sh
```


### Usage

Once the serverless deployment is done the POST API Gateway will be displayed in the console
Use the API as a POST request with the following payload
```
{
  "url": "url of the asset"
}
```
