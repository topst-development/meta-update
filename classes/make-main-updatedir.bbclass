#Check your update romfile name

UPDATE_DIR = "${DEPLOY_DIR_IMAGE}/update_main"

do_make_updatedir() {
	rm -rf ${UPDATE_DIR}
	mkdir ${UPDATE_DIR}

	install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_BOOTLOADER_NAME}           ${UPDATE_DIR}/main_bootloader.rom
	install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_KERNEL_NAME}               ${UPDATE_DIR}/main_boot.img
	install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_ROOTFS_NAME}               ${UPDATE_DIR}/main_rootfs.ext4
	install -m 0644 ${DEPLOY_DIR_IMAGE}/${UPDATE_DTB_NAME}                  ${UPDATE_DIR}/main.dtb

	if [ ! -z ${UPDATE_SNOR_NAME} ]; then
		install -m 0644 ${DEPLOY_DIR_IMAGE}/boot-firmware/prebuilt/${UPDATE_SNOR_NAME}	${UPDATE_DIR}/snor.rom
	fi
}

addtask make_updatedir
