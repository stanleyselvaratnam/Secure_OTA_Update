# ============================================================
#  Suppression du kernel dans le rootfs (test rollback Mender)
# ============================================================

ROOTFS_POSTPROCESS_COMMAND += "remove_kernel_from_rootfs;"

remove_kernel_from_rootfs() {
    echo "== remove-kernel: suppression de Image.gz et Image dans ${IMAGE_ROOTFS}/boot =="

    # Supprime les fichiers kernel classiques
    rm -f ${IMAGE_ROOTFS}/boot/Image.gz || true
    rm -f ${IMAGE_ROOTFS}/boot/Image || true

    # Si Toradex ou Yocto place d'autres versions du kernel dans /boot
    rm -f ${IMAGE_ROOTFS}/boot/vmlinuz* || true
    rm -f ${IMAGE_ROOTFS}/boot/zImage || true

    # Facultatif : supprimer les dtb pour simuler un échec encore plus grave
    # rm -f ${IMAGE_ROOTFS}/boot/*.dtb || true
}
