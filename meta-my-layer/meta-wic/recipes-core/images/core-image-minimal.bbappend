# meta-my-layer/meta-wic/recipes-core/images/core-image-minimal.bbappend

# ask for a .wic image
IMAGE_FSTYPES += "wic wic.bz2 sdimg"

# use our custom wks (layer.conf already sets it; redondant but explicit)
WKS_FILE = "custom-qemuarm64.wks"
WKS_FILE_DEPENDS += " virtual/kernel"

# Default boot files (u-boot + kernel image name)

# Pour éviter d’essayer de copier un u-boot.img inexistant
IMAGE_BOOT_FILES = "grub-efi-bootaa64.efi"

# Map the same kernel Image into two different partitions labeled KERNEL_A and KERNEL_B.
# bootimg-partition plugin utilise les variables IMAGE_BOOT_FILES_label-<label>
IMAGE_BOOT_FILES_label-KERNEL_A = "Image qemuarm64.dtb"
IMAGE_BOOT_FILES_label-KERNEL_B = "Image qemuarm64.dtb"

# expose these variables to wic (WICVARS fait en sorte qu'elles soient visibles par wic)
# WICVARS += "IMAGE_BOOT_FILES_label-KERNEL_A IMAGE_BOOT_FILES_label-KERNEL_B"
