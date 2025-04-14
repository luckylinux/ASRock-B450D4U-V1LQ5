# Tested with BIOS Version L2.09 on ASROCK B450D4U-V1LQ5
# Tuned based on File_DXE_driver_CbsSetupDxeRN_CbsSetupDxeRN_body.fbd.0.0.en-US.ifr.txt

# Disable printing of Commands
@echo -on

# Enable Memory Overclock & Accept Risk
setup_var.efi AmdSetup(0x5000):0x4A=0x01

# Enable Combo CBS
setup_var.efi AmdSetup(0x5000):0x20=0xFF

# Enable ECC Memory
setup_var.efi AmdSetup(0x5000):0x91=0x01
