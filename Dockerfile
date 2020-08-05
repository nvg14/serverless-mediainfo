FROM amazonlinux

WORKDIR /
RUN yum update -y

RUN yum install make -y
RUN yum -y install openssl-devel bzip2-devel libffi-devel wget tar gzip make gcc-c++

RUN wget https://mediaarea.net/download/binary/libmediainfo0/20.03/MediaInfo_DLL_20.03_GNU_FromSource.tar.gz
RUN tar -xzvf MediaInfo_DLL_20.03_GNU_FromSource.tar.gz

RUN yum install libcurl-devel -y

WORKDIR /MediaInfo_DLL_GNU_FromSource/
RUN ./SO_Compile.sh
RUN cd /MediaInfo_DLL_GNU_FromSource/MediaInfoLib/Project/GNU/Library && make install

RUN yum install zip -y
RUN mkdir -p /packages/pymediainfo/
RUN cp /MediaInfo_DLL_GNU_FromSource/MediaInfoLib/Project/GNU/Library/.libs/* /packages/pymediainfo/
WORKDIR /packages/pymediainfo/
RUN zip -r9 /packages/pymediainfo.zip .
WORKDIR /packages/
RUN rm -rf /packages/pymediainfo/
