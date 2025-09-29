# ajouter le dossier files à la recherche
FILESEXTRAPATHS:prepend := "${THISDIR}/../files:"

# ajouter le DTS fourni
SRC_URI:append = " file://qemu.dts"

# copier le DTS dans le source tree du kernel au moment de la configure
do_configure:append() {
    install -m 0644 ${WORKDIR}/qemu.dts ${S}/arch/arm64/boot/dts/qemu.dts
    echo "dtb-$(CONFIG_ARM64) += qemu.dtb" >> ${S}/arch/arm64/boot/dts/Makefile
}

# indiquer le nom du DTB à inclure dans l'image
KERNEL_DEVICETREE:append = " qemu.dtb"
