#!/bin/bash

address=$ARTIFACTORY_URL
artifactory_pass=$ARTIFACTORY_PASSWORD
build_name="test_library_header_only_bump_case"
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
conan_build_info --v2 start "${build_name}" "${build_number}"

echo "# new revision" >> libX/conanfile.py

libX_version="1.0"

conan create libX libX/${libX_version}@

sed "s/<VERSION>/${libX_version}/" libHO/template.py > libHO/conanfile.py

conan export libHO

conan graph lock libHO/1.0@ -r conan-tmp

conan graph build-order conan.lock --build=missing 

cat conan.lock

conan create libHO --lockfile=conan.lock -r conan-tmp

conan upload 'libX' --all -r conan-tmp --confirm ${use_force}
conan upload 'libHO' --all -r conan-tmp --confirm  ${use_force}

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

conan_build_info --v2 start "${build_name}" "${build_number}"

libX_version="${build_number}"

conan create libX libX/${libX_version}@

sed "s/<VERSION>/${libX_version}/" libHO/template.py > libHO/conanfile.py

conan export libHO

conan graph lock libHO/1.0@ -r conan-tmp

conan graph build-order conan.lock --build=missing 

cat conan.lock

conan create libHO --lockfile=conan.lock --build libHO -r conan-tmp

conan upload 'libX' --all -r conan-tmp --confirm ${use_force}
conan upload 'libHO' --all -r conan-tmp --confirm  ${use_force}

cat conan.lock

conan_build_info --v2 create --lockfile conan.lock --user admin --password ${artifactory_pass} build_info.json

cat build_info.json

conan_build_info --v2 publish --url http://${address}:8081/artifactory --user admin --password ${artifactory_pass} build_info.json

curl -u"admin:${artifactory_pass}" -XPOST "http://${address}:8081/artifactory/api/build/promote/${build_name}/${build_number}" -H "Content-type: application/json" -d '{"dryRun" : false, "sourceRepo" : "conan-tmp", "targetRepo" : "conan-develop", "copy": true, "artifacts" : true, "dependencies" : true}'


# reset version
sed "s/<VERSION>/1.0/" libHO/template.py > libHO/conanfile.py
