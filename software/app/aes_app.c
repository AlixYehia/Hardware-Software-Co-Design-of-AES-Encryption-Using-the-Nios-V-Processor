// The ENC (Encryption) and DEC (Decryption) modules are custom AES hardware IPs
// connected to the Nios V processor through an AXI4-Lite interface.
// Each module is memory-mapped to a base address defined in system.h:
//   - AES_AXI_0_BASE : Base address of the Encryption module.
//   - AES_DECR_0_BASE: Base address of the Decryption module.
// These base addresses correspond to physical addresses in the on-chip memory map.
//
// By casting these base addresses to int* pointers (ptr_enc, ptr_dec),
// we can directly access the control and data registers of each module
// as if they were arrays in memory. For example:
//   - ptr_enc[0] accesses ENC's input register 0 (offset 0x00).
//   - ptr_enc[4] accesses ENC's key register 0 (offset 0x10).
//   - ptr_enc[8] accesses ENC's output register 0 (offset 0x20), and so on.
//
// This way, read/write operations to these addresses actually configure
// or retrieve data from the corresponding hardware modules via memory-mapped I/O.

#include <stdint.h>
#include <stdio.h>
#include "D:\ITI\FPGA\AES\software\bsp\system.h"
#include "D:\ITI\FPGA\AES\software\bsp\HAL\inc\sys\intel_fpga_api_niosv.h"


int main() {
	// base addresser for the AES [ENC, DEC] modules
	int *ptr_enc = (int *) (AES_AXI_0_BASE);
	int *ptr_dec = (int *) (AES_DECR_0_BASE);

	// this is the input for the ENC module
	int plain_text_in[4] = { 0x00112233, 0x44556677, 0x8899aabb, 0xccddeeff };
	int key[4] = { 0x00010203, 0x04050607, 0x08090a0b, 0x0c0d0e0f };

	// Assigning the data to the input of ENC
	for (int i = 0; i < 4; i++){
		ptr_enc[i] = plain_text_in[i];
		ptr_enc[i + 4] = key[i];
	}

	// Taking the output from ENC module
	int ciphertext[4] = {0};
	for (int i = 0; i < 4; i++){
		ciphertext[i] = ptr_enc[i+8];
	}

	// Assigning the data to the input of DEC
	for (int i = 0; i < 4; i++){
		ptr_dec[i] = ciphertext[i];
		ptr_dec[i + 4] = key[i];
	}

	// Taking the output from DEC module
	int plain_text_out [4] = {0};
	for (int i = 0; i < 4; i++){
		plain_text_out[i] = ptr_dec[i+8];
	}

	printf("############################################\n");
	printf("## Encrypting 128-bit plaintext using AES ##\n");
	printf("############################################\n\n");

	printf("%-22s", "Plaintext:");
    for (int i = 0; i < 4; i++) {
        printf("%08x", ptr_enc[i]);
    }
	printf("\n---------------------------------------------\n");

	printf("%-22s", "Key:");
    for (int i = 4; i < 8; i++) {
        printf("%08x", ptr_enc[i]);
    }
	printf("\n---------------------------------------------\n");

	printf("%-22s", "Actual ciphertext:");
	for (int i = 0; i < 4; i++) {
		printf("%08x", ciphertext[i]);
	}
	printf("\n---------------------------------------------\n");


	printf("%-22s", "Expected ciphertext:");
	printf("69c4e0d86a7b0430d8cdb78070b4c55a");
	printf("\n---------------------------------------------\n");
	printf("AES encryption completed.\n");


	printf("\n**********************************************\n\n");


	printf("############################################\n");
	printf("## Decrypting 128-bit ciphertext using AES ##\n");
	printf("############################################\n\n");

	printf("%-22s", "Ciphertext:");
    for (int i = 0; i < 4; i++) {
        printf("%08x", ptr_dec[i]);
    }
	printf("\n---------------------------------------------\n");

	printf("%-22s", "Key:");
    for (int i = 4; i < 8; i++) {
        printf("%08x", ptr_dec[i]);
    }
	printf("\n---------------------------------------------\n");

	printf("%-22s", "Actual plaintext:");
	for (int i = 0; i < 4; i++) {
		printf("%08x", plain_text_out[i]);
	}
	printf("\n---------------------------------------------\n");
	printf("AES decryption completed.\n");

	return 0;
}
