# Génération automatique de boot.cmd et boot.scr pour u-boot-toradex

do_prepare_bootcmd() {
    sed -e "s|@@APPEND@@|${APPEND}|g" \
        -e "s|@@KERNEL_IMAGETYPE@@|${KERNEL_IMAGETYPE}|g" \
        -e "s|@@FITCONF_FDT_OVERLAYS@@|${FITCONF_FDT_OVERLAYS}|g" \
        -e "s|@@KERNEL_DTB_PREFIX@@|${KERNEL_DTB_PREFIX}|g" \
        ${THISDIR}/files/boot.cmd.in > ${WORKDIR}/boot.cmd
}
addtask prepare_bootcmd after do_unpack before do_compile

do_generate_bootscr() {
    mkimage -A arm64 -T script -C none -n "Boot script" -d ${WORKDIR}/boot.cmd ${WORKDIR}/boot.scr
    install -m 0644 ${WORKDIR}/boot.scr ${DEPLOYDIR}/boot.scr
}
addtask generate_bootscr after do_compile before do_deploy
