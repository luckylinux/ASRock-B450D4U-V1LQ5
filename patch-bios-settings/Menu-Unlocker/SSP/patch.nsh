# Tested with BIOS Version L2.09 on ASROCK B450D4U-V1LQ5
# Tuned based on File_DXE_driver_CbsSetupDxeSSP_CbsSetupDxeSSP_body.fbd.0.0.en-US.ifr.txt

# Disable printing of Commands
@echo -on

# Enable UMC Common Options
# setup_var.efi Setup(0x1):0x4=0x01

# Force QuestionId: 0x4 (VarStoreId: 0x1, VarOffset: 0x1) to unhide Menu (!= 0 should do it)
setup_var.efi Setup(0x1):0x1=0x01

# Force QuestionId: 0x5 (VarStoreId: 0x4, VarOffset: 0x0) to unhide Menu (== 1 should do it)
setup_var.efi SystemAccess(0x4):0x0=0x01

# Force QuestionId: 0x7 (VarStoreId: 0x2, VarOffset: 0x0) (!= 0 and != 1 should do it)
setup_var.efi Setup2(0x2):0x0=0x02

# Force QuestionId: 0x8 (VarStoreId: 0x1, VarOffset: 0x0) (!= 0 should do it)
setup_var.efi Setup(0x1):0x0=0x01
