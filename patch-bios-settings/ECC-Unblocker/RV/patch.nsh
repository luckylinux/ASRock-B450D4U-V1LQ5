# Tested with BIOS Version L2.09 on ASROCK B450D4U-V1LQ5
# Tuned based on File_DXE_driver_CbsSetupDxeRV_CbsSetupDxeRV_body.fbd.0.0.en-US.ifr.txt

# Enable printing of Commands
@echo -on

# Enable Memory Overclock & Accept Risk
setup_var.efi AmdSetup(0x5000):0xA1=0x01

# Enable Combo CBS
setup_var.efi AmdSetup(0x5000):0x20=0xFF

# Enable ECC Memory
setup_var.efi AmdSetup(0x5000):0xE2=0x01
