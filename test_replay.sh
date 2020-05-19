#!/bin/bash

address=$ARTIFACTORY_URL
artifactory_pass=$ARTIFACTORY_PASSWORD
use_force=""

conan remote remove conan-develop
conan remote remove conan-tmp

conan remote add conan-develop http://${address}:8081/artifactory/api/conan/conan-develop
conan remote add conan-tmp http://${address}:8081/artifactory/api/conan/conan-tmp

conan user -p ${artifactory_pass} -r conan-develop admin
conan user -p ${artifactory_pass} -r conan-tmp admin

conan remove "libR*" -f
conan remove "libHO*" -f
conan remove "libX*" -f
conan remove "consumer*" -f

# bootstrap artifactory
# begin with new revisions

temp=$(< counter)
build_number=$(($temp + 1))
echo "--------------------------"
echo "-------- build number: ${build_number}"
echo "--------------------------"
echo $build_number > counter
conan_build_info --v2 start test_regular_case "${build_number}"

echo "# new revision" >> libX/conanfile.py

conan export libX libX/1.0@
conan export libR

conan graph lock libR/1.0@ -r conan-tmp

conan graph build-order conan.lock --build=missing

cat conan.lock

conan create libR --lockfile=conan.lock --build missing -r conan-tmp

conan upload 'libX' --all -r conan-tmp --confirm ${use_force}
conan upload 'libR' --all -r conan-tmp --confirm  ${use_force}

cat conan.lock

conan_build_info --v2 create --lockfile conan.lock --user admin --password ${artifactory_pass} build_info.json

cat build_info.json

conan_build_info --v2 publish --url http://${address}:8081/artifactory --user admin --password ${artifactory_pass} build_info.json

#### new build
conan remove "libR*" -f
conan remove "libHO*" -f
conan remove "libX*" -f
conan remove "consumer*" -f


temp=$(< counter)
build_number=$(($temp + 1))
echo "--------------------------"
echo "-------- build number: ${build_number}"
echo "--------------------------"
echo $build_number > counter

conan_build_info --v2 start test_regular_case "${build_number}"

# conan export libX libX/1.0@
# conan export libR

conan graph lock libR/1.0@ -r conan-tmp

conan graph build-order conan.lock --build=missing

cat conan.lock

conan create libR --lockfile=conan.lock --build missing -r conan-tmp

conan upload 'libX' --all -r conan-tmp --confirm ${use_force}
conan upload 'libR' --all -r conan-tmp --confirm  ${use_force}

cat conan.lock

conan_build_info --v2 create --lockfile conan.lock --user admin --password ${artifactory_pass} build_info.json

cat build_info.json

conan_build_info --v2 publish --url http://${address}:8081/artifactory --user admin --password ${artifactory_pass} build_info.json

curl -u"admin:${artifactory_pass}" -XPOST "http://${address}:8081/artifactory/api/build/promote/test_regular_case/${build_number}" -H "Content-type: application/json" -d '{"dryRun" : false, "sourceRepo" : "conan-tmp", "targetRepo" : "conan-develop", "copy": true, "artifacts" : true, "dependencies" : true}'








