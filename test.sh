# Create a layer directory in which the compiled libmediainfo file resides
mkdir -p layer

# Build the docker image to compile the mediainfo from dll - currently using libemediainfo 20.03
docker build --tag=nvg/mediainfo:latest .

# Extract the zip file to current directory
docker run --rm -it -v $(pwd):/data nvg/mediainfo cp /packages/pymediainfo.zip /data

# Unzip the zip file to layer folder
unzip pymediainfo.zip -d layer/

# Install the pymediainfo wrapper to get the result in data structure
pip install pymediainfo --target=. --system

# Remove the zip folder to reduce the serverless size
rm -rf pymediainfo.zip

# Deploy the serverless function
sls deploy --aws-profile vod-root

# Use the below command to deploy with profile which has the required permission
#sls deploy --aws-profile <profile-name>
