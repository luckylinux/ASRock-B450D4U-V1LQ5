# README

## Requirements
### UEFI Shell Boot Drive
Setup a UEFI Shell Boot Drive on a USB Flashdrive.

Furthermore, many of the different File Copies / Locations described below might NOT be required, but this was the only way I could get it to boot on an ASUS P9D WS Motherboard with the "Standard" EFI Shell Executable Layout.

1. Format the Drive as FAT32
2. Get a `shellx64.efi` UEFI Shell Executable
3. 
   - (Old) [TianoCore](https://github.com/tianocore/edk2/blob/UDK2018/ShellBinPkg/UefiShell/X64/Shell.efi)
   - (Verify Build Process / Artifacts for Safety) [pbatard Repository](https://github.com/pbatard/UEFI-Shell/releases/download/24H2/shellx64.efi)
4. Create a ./efi/boot Folder Structure in your newly formatted FAT32 Drive
5. Copy `shellx64.efi` to:
   - `./efi/shellx64.efi`
   - `./efi/bootx64.efi`
   - `./efi/boot/shellx64.efi`
   - `./efi/boot/bootx64.efi`

### (Optional) Download `setup_var.efi` from the Official Repositorsy
A copy of `setup_var.efi` has been included in each Subfolder, so that there will be no `PATH` related Issues.

If you prefer to Download `setup_var.efi` from the [Official Repository](https://github.com/datasone/setup_var.efi), feel Free to do so and replace all the `setup_var.efi` Files from this Repository with the one you downloaded from the Official Repository.

## Patching
### AMD 5000 Series CPUs
Tested on:
- AMD Ryzen 5600X
- AMD Ryzen 5700X

The Scripts inside the `SSP` Subfolder shall be used.

Procedure:
1. Boot into UEFI Shell (F11 -> select Boot Device).
2. Run `patch.nsh`.
3. Reboot with `reset`.
4. Boot into UEFI Shell (F11 -> select Boot Device).
5. Run `read.nsh`.
6. Shutdown by pressing the Power Button / Shorting the Pins for several (5-10) Seconds
7. **Disconnect Power Cord for at least 30 Seconds** (possibly more, up to 1-5 Minutes might be required).
8. Boot into Debian/Ubuntu LiveUSB (F11 -> select Boot Device)
9. Check if ECC is now working using `dmesg`:
```
dmesg | grep -i edac
```

This should return something along the Lines of
```
     root@LiveUbuntu02:~# dmesg | grep -i edac
[    0.649063] EDAC MC: Ver: 3.0.0
[    7.189913] EDAC MC0: Giving out device to module amd64_edac controller F19h_M20h: DEV 0000:00:18.3 (INTERRUPT)
[    7.189916] EDAC amd64: F19h_M20h detected (node 0).
[    7.189920] EDAC MC: UMC0 chip selects:
[    7.189921] EDAC amd64: MC: 0:     0MB 1:     0MB
[    7.189922] EDAC amd64: MC: 2:     0MB 3:     0MB
[    7.189926] EDAC MC: UMC1 chip selects:
[    7.189927] EDAC amd64: MC: 0:     0MB 1:     0MB
[    7.189928] EDAC amd64: MC: 2:  8192MB 3:  8192MB
```

If you **ONLY** get a single Line of Output line this one, then ECC is **NOT** working !!!
```
root@LiveUbuntu02:~# dmesg | grep -i edac
[    0.650269] EDAC MC: Ver: 3.0.0     
```

10. Check if ECC is now working using `dmidecode`:
```
sudo dmidecode -t memory | grep -i 'error correction'
```

Should return:
```
root@LiveUbuntu02:~# sudo dmidecode -t memory | grep -i 'error correction'
	Error Correction Type: Multi-bit ECC
```

If it returns:
```
root@LiveUbuntu02:~# sudo dmidecode -t memory | grep -i 'error correction'
        Error Correction Type: None
```

Then ECC is **NOT** working !!!

