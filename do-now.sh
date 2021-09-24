dpkg --add-architecture i386
apt-get update -y
apt-get -y install flex bison ncurses-dev texinfo gcc gperf patch libtool automake g++ libncurses5-dev gawk expat libexpat1-dev python-all-dev binutils-dev libgcc1:i386 bc libgnutls28-dev libcap-dev autoconf autoconf-archive libgmp-dev build-essential gcc-multilib g++-multilib pkg-config libmpc-dev libmpfr-dev autopoint gettext liblzma-dev libssl-dev libz-dev

git config --global color.ui auto

mkdir -p $(pwd)/reep
PATH="$(pwd)/reep:${PATH}"
curl https://storage.googleapis.com/git-repo-downloads/repo > $(pwd)/reep/repo
chmod a+rx $(pwd)/reep/repo

mkdir recovery && cd recovery

repo init --depth=1 -u git://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-11

repo sync

git clone --depth=1 https://github.com/ZyCromerZ/twrp_redmi_begonia -b android-11.0 device/redmi/begonia

export ALLOW_MISSING_DEPENDENCIES=true

. build/envsetup.sh

lunch twrp_begonia-eng

make -j8 recoveryimage

cd ..

if [ -f recovery/out/target/product/begonia/recovery.img ];then
    git clone https://${GIT_SECRET}@github.com/ZyCromerZ/uploader-kernel-private
    chmod +x $(pwd)/uploader-kernel-private/run.sh
    . $(pwd)/uploader-kernel-private/run.sh "$(pwd)/recovery/out/target/product/begonia/recovery.img" "shared-file" "$(date +"%Y-%m-%d")"
fi