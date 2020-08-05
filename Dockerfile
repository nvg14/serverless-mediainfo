# USAGE: 
# 1. Build the docker image:
#     docker build --tag=nvg/mediainfo:latest .
# 2. Build and copy MediaInfo libraries to ./pymediainfo-python[37,38].zip
#     docker run --rm -it -v $(pwd):/data nvg/mediainfo cp /packages/pymediainfo-python37.zip /data
# 3. Extract the pymediainfo-python37.zip to layer/
#     unzip pymediainfo-python37.zip -d layer/
# 4. Delete the pymediainfo-python37.zip
#     rm pymediainfo-python37.zip
FROM amazonlinux

WORKDIR /
RUN yum update -y

# Install Python 3.8
RUN yum -y install openssl-devel bzip2-devel libffi-devel wget tar gzip make gcc-c++
RUN wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz
RUN tar -xzvf Python-3.8.0.tgz
WORKDIR /Python-3.8.0
RUN ./configure --enable-optimizations
RUN make install

# Install Python 3.7
RUN yum install python3 zip -y

# Install Python packages
RUN mkdir /packages
RUN echo "pymediainfo" >> /packages/requirements.txt
RUN mkdir -p /packages/pymediainfo-3.7/python/lib/python3.7/site-packages
RUN mkdir -p /packages/pymediainfo-3.8/python/lib/python3.8/site-packages
RUN pip3.7 install -r /packages/requirements.txt -t /packages/pymediainfo-3.7/python/lib/python3.7/site-packages
RUN pip3.8 install -r /packages/requirements.txt -t /packages/pymediainfo-3.8/python/lib/python3.8/site-packages

# Install make
RUN yum install make -y

# Download MediaInfo
WORKDIR /root
RUN wget https://mediaarea.net/download/binary/libmediainfo0/20.03/MediaInfo_DLL_20.03_GNU_FromSource.tar.gz
RUN tar -xzvf MediaInfo_DLL_20.03_GNU_FromSource.tar.gz

# Install libcurl
RUN yum install libcurl-devel -y

# Compile MediaInfo with Support for URL Inputs
WORKDIR /root/MediaInfo_DLL_GNU_FromSource/
RUN ./SO_Compile.sh --with-libcurl
RUN cd /root/MediaInfo_DLL_GNU_FromSource/MediaInfoLib/Project/GNU/Library && make install

# Create zip files for Lambda Layer deployment
RUN cp /root/MediaInfo_DLL_GNU_FromSource/MediaInfoLib/Project/GNU/Library/.libs/* /packages/pymediainfo-3.7/python
RUN cp /root/MediaInfo_DLL_GNU_FromSource/MediaInfoLib/Project/GNU/Library/.libs/* /packages/pymediainfo-3.8/python
RUN cp /root/MediaInfo_DLL_GNU_FromSource/MediaInfoLib/Project/GNU/Library/.libs/* /packages/pymediainfo-3.7/
RUN cp /root/MediaInfo_DLL_GNU_FromSource/MediaInfoLib/Project/GNU/Library/.libs/* /packages/pymediainfo-3.8/
WORKDIR /packages/pymediainfo-3.7/
RUN zip -r9 /packages/pymediainfo-python37.zip .
WORKDIR /packages/pymediainfo-3.8/
RUN zip -r9 /packages/pymediainfo-python38.zip .
WORKDIR /packages/
RUN rm -rf /packages/pymediainfo-3.7/
RUN rm -rf /packages/pymediainfo-3.8/
