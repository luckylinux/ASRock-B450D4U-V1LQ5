# Tested with BIOS Version L2.09 on ASROCK B450D4U-V1LQ5
# Tuned based on File_DXE_driver_CbsSetupDxeSSP_CbsSetupDxeSSP_body.fbd.0.0.en-US.ifr.txt

# Disable printing of Commands
@echo -on

# Enable Memory Overclock & Accept Risk
setup_var.efi AmdSetup(0x5000):0xD4=0x01

# Enable Combo CBS
setup_var.efi AmdSetup(0x5000):0x20=0xFF

# Enable ECC Memory
setup_var.efi AmdSetup(0x5000):0x11B=0x01

