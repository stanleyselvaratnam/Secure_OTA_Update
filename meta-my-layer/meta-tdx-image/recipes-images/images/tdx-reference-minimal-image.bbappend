# Force u-boot-distro-boot to deploy boot.scr before building the image
DEPENDS += "u-boot-distro-boot"

# Ensure do_deploy runs before do_image
do_image[depends] += "u-boot-distro-boot:do_deploy"

# Fallback: generate boot.scr-${MACHINE} if missing
python do_image_bootscr_fallback() {
    import os
    import shutil

    machine = d.getVar('MACHINE', True)
    deploydir = d.getVar('DEPLOYDIR', True)
    bootscr_name = f'boot.scr-{machine}'
    bootscr_path = os.path.join(deploydir, bootscr_name)
    generic_bootscr = os.path.join(deploydir, 'boot.scr')

    if not os.path.exists(bootscr_path):
        if os.path.exists(generic_bootscr):
            shutil.copyfile(generic_bootscr, bootscr_path)
            bb.note(f"Copied generic boot.scr to {bootscr_name}")
        else:
            bb.warn(f"boot.scr does not exist in deploydir {deploydir}")
}

do_image_bootscr_fallback[dirs] = "${DEPLOYDIR}"
do_image_bootscr_fallback[nostamp] = "1"
do_image_bootscr_fallback[cleandirs] = ""
addtask do_image_bootscr_fallback after do_deploy before do_image_bootfs
