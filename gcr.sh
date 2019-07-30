#!/bin/sh
# 40 min
time_out_seconds=2400
start_timestamp=`date +%s`

maxCount=400
touch counter.tmp
touch skip.tmp
incr(){
    echo "1" >> counter.tmp
}

count(){
    cat counter.tmp | wc -l
}

clean(){
    rm -fr counter.tmp
}

docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
cp jenkins-x-platform/values.yaml ./


cat jenkins-x-platform/values.yaml | grep gcr.io |  grep -o  "\w*\..*:.*$" | sort | uniq | while read repo; do
    docker pull $repo
    target="${DOCKER_USER}/${repo##*/}"
    echo "tag $repo to $target"
    docker tag $repo $target
    docker push $target
    sed -i "s~$repo~$target~g" values.yaml
done

echo "result: "
cat values.yaml

#time sh git_push.sh

