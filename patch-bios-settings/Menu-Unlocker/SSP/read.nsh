# Tested with BIOS Version L2.09 on ASROCK B450D4U-V1LQ5
# Tuned based on File_DXE_driver_CbsSetupDxeSSP_CbsSetupDxeSSP_body.fbd.0.0.en-US.ifr.txt

# Enable printing of Commands
@echo -on

# Enable UMC Common Options
# setup_var.efi Setup(0x1):0x4=0x01
# setup_var.efi Setup(0x1):0x4 > result
# dmpstor -l result enable_umc_common_options
# echo Enable UMC Common Options: Setup(0x1):0x4=%enable_umc_common_options%
echo Enable UMC Common Options:
setup_var.efi Setup(0x1):0x4
echo Expected Setup(0x1):0x4=0x01
echo ...................................................................

# # Force QuestionId: 0x4 (VarStoreId: 0x1, VarOffset: 0x1) to unhide Menu (!= 0 should do it)
# setup_var.efi setup_var.efi Setup(0x1):0x1=0x01
# setup_var.efi setup_var.efi Setup(0x1):0x1 > result
# dmpstor -l result force_questionid_0x4
# echo Force QuestionId: 0x4: Setup(0x1):0x1=%force_questionid_0x4%
echo Force QuestionId: 0x4:
setup_var.efi Setup(0x1):0x1
echo Expected Setup(0x1):0x1=0x01
echo ...................................................................

# Force QuestionId: 0x5 (VarStoreId: 0x4, VarOffset: 0x0) to unhide Menu (== 1 should do it)
# setup_var.efi SystemAccess(0x4):0x0=0x01
# setup_var.efi SystemAccess(0x4):0x0 > result
# dmpstor -l result force_questionid_0x5
# echo Enable Overclock: SystemAccess(0x4):0x0=%force_questionid_0x5%
echo Force QuestionId: 0x5:
setup_var.efi SystemAccess(0x4):0x01
echo Expected SystemAccess(0x4):0x0=0x01
echo ...................................................................

# Force QuestionId: 0x7 (VarStoreId: 0x2, VarOffset: 0x0) to unhide Menu (!= 0 and != 1 should do it)
# setup_var.efi Setup2(0x2):0x0=0x02
# setup_var.efi Setup2(0x2):0x0 > result
# dmpstor -l result force_questionid_0x7
# echo Enable Overclock: Setup2(0x2):0x0=%force_questionid_0x7%
echo Force QuestionId: 0x7:
setup_var.efi Setup2(0x2):0x0
echo Expected Setup2(0x2):0x0=0x02
echo ...................................................................

# Force QuestionId: 0x8 (VarStoreId: 0x1, VarOffset: 0x0) (!= 0 should do it)
# setup_var.efi Setup(0x1):0x0=0x01
# setup_var.efi Setup(0x1):0x0 > result
# dmpstor -l result force_questionid_0x8
# echo Enable Overclock: SystemAccess(0x4):0x0=%force_questionid_0x8%
echo Force QuestionId: 0x8:
setup_var.efi Setup(0x1):0x0
echo Expected Setup(0x1):0x0=0x01
echo ...................................................................
