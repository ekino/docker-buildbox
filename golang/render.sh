#!/bin/bash

versionsreference=(1.18.7 1.19.2 1.20-rc)
versions=(1.18 1.19 1.20)

for i in 0 1 2
do 
  globalversion=${versions[$i]}
  goversion=${versionsreference[$i]}
  mkdir $globalversion
  sed "s/\${GOLANG_VERSION}/$goversion/" Dockerfile.template > $globalversion/Dockerfile
done

