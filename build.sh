# 指定打包的scheme
SCHEME="LWColorPicker"
# 指定打包的workspace文件
WORKSPACE="./Example/${SCHEME}.xcworkspace"
echo '================== Build Framework =================='
# 输出当前的构建目录
BUILD_DIR=`pwd`
echo ${BUILD_DIR}
# 设置导出framework路径
EXPORT_FRAMMEWORK_DIR='./product/'
# 设置真机打包的路径
DEVICE_DIR='../../build/Release-iphoneos/'
# 设置模拟器打包的路径
SIMULATOR_DIR='../../build/Release-iphonesimulator/'
xcodebuild -workspace ${WORKSPACE} -configuration Release  -scheme ${SCHEME} -sdk iphoneos CONFIGURATION_BUILD_DIR=${DEVICE_DIR} clean build
xcodebuild -workspace ${WORKSPACE} -configuration Release  -scheme ${SCHEME} -sdk iphonesimulator CONFIGURATION_BUILD_DIR=${SIMULATOR_DIR} clean build
# 删除旧有的framework文件夹，并重新创建
if [[ -d ${EXPORT_FRAMMEWORK_DIR} ]]; then
	rm -rf ${EXPORT_FRAMMEWORK_DIR}
fi
mkdir -p ${EXPORT_FRAMMEWORK_DIR}
# 重置模拟器与真机的framework路径
DEVICE_DIR='./build/Release-iphoneos/'
SIMULATOR_DIR='./build/Release-iphonesimulator/'
# 拷贝真机framework到导出文件夹
cp -rf ${DEVICE_DIR} ${EXPORT_FRAMMEWORK_DIR}
# 合并真机与模拟器二进制文件
lipo -create ${DEVICE_DIR}/${SCHEME}.framework/${SCHEME}  ${SIMULATOR_DIR}/${SCHEME}.framework/${SCHEME} -output  ${EXPORT_FRAMMEWORK_DIR}/${SCHEME}.framework/${SCHEME}
echo '================== Build Finished =================='
echo 'Final Framework path:'
echo ${EXPORT_FRAMMEWORK_DIR}${SCHEME}.framework