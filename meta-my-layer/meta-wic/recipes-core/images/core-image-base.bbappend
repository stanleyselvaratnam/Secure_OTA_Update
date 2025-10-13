# meta-my-layer/meta-wic/recipes-core/images/core-image-base.bbappend

IMAGE_FSTYPES += "wic wic.bz2 sdimg"

# Vérifie le nom du wks :
WKS_FILE = "custom-qemuarm64.wks.in"
WKS_FILE_DEPENDS += "virtual/kernel"

# Optionnel : assure que wic voie ces variables
WICVARS += "IMAGE_BOOT_FILES_label-kernelA IMAGE_BOOT_FILES_label-kernelB"

# Ces variables doivent correspondre aux labels EXACTS de ton .wks.in :
IMAGE_BOOT_FILES_label-kernelA = "Image"
IMAGE_BOOT_FILES_label-kernelB = "Image"

# Si tu veux un bootloader EFI générique pour QEMU :
IMAGE_BOOT_FILES = "grub-efi-bootaa64.efi"

