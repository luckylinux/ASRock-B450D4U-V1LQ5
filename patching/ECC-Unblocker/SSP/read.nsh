# Tested with BIOS Version L2.09 on ASROCK B450D4U-V1LQ5
# Tuned based on File_DXE_driver_CbsSetupDxeSSP_CbsSetupDxeSSP_body.fbd.0.0.en-US.ifr.txt

# Enable printing of Commands
@echo -on

# Enable Memory Overclock & Accept Risk
# setup_var.efi AmdSetup(0x5000):0xD4=0x01
# setup_var.efi AmdSetup(0x5000):0xD4 > result
# dmpstor -l result enable_overclock
# echo Enable Memory Overclock: AmdSetup(0x5000):0xD4=%enable_overclock%
echo Enable Memory Overclock Setting:
setup_var.efi AmdSetup(0x5000):0xD4
echo Expected AmdSetup(0x5000):0xD4=0x01
echo ...................................................................

# Enable Combo CBS
# setup_var.efi AmdSetup(0x5000):0x20=0xFF
# setup_var.efi AmdSetup(0x5000):0x20 > result
# dmpstor -l result enable_combo_cbs
# echo Enable Combo CBS: AmdSetup(0x5000):0x20=%enable_combo_cbs%
echo Enable Combo CBS Setting:
setup_var.efi AmdSetup(0x5000):0x20
echo Expected AmdSetup(0x5000):0x20=0xFF
echo ...................................................................

# Enable ECC Memory
# setup_var.efi AmdSetup(0x5000):0x11B=0x01
# setup_var.efi AmdSetup(0x5000):0x11B > result
# dmpstor -l result enable_ecc_memory
# echo Enable Overclock: AmdSetup(0x5000):0x11B=%enable_ecc_memory%
echo Enable ECC Memory Setting:
setup_var.efi AmdSetup(0x5000):0x11B
echo Expected AmdSetup(0x5000):0x11B=0x01
echo ...................................................................
