
### processor start at real mode

16 bit registers
20 bit address bus

on paper we cant access all the address space using the registers

```
registers max size = 2 ^ 16
max address = 2 ^ 20
```

Solution
```
# present address into two parts
segemnt_selector:offset

PhysicalAddress = (segment_selector * 16) + offset
# bitwise since 16 = 2^4
PhysicalAddress = (segment_selector << 4) + offset

# max selector and offset
0xFFFF:0xFFFF
PhysicalAddress = 0xFFFF * 16 + 0xFFFF = 0x10FFEF > 0xFFFFF
```

#### A20 
When disabled wrap around the physical address when it surpass the address space by discarding extra bits.
```
0x10FFEF -> 0x00FFEF
```

## MBR structure

```
Bootstrap code area 446
4x partition table entries 16
_Boot signature_ = 0x55 0xaa (care about endianess)
```

### Real mode memory map

```
0x00000000 - 0x000003FF - Real Mode Interrupt Vector Table
0x00000400 - 0x000004FF - BIOS Data Area
0x00000500 - 0x00007BFF - Unused
0x00007C00 - 0x00007DFF - Our Bootloader <-------------
0x00007E00 - 0x0009FFFF - Unused
0x000A0000 - 0x000BFFFF - Video RAM (VRAM) Memory
0x000B0000 - 0x000B7777 - Monochrome Video Memory
0x000B8000 - 0x000BFFFF - Color Video Memory
0x000C0000 - 0x000C7FFF - Video ROM BIOS
0x000C8000 - 0x000EFFFF - BIOS Shadow Area
0x000F0000 - 0x000FFFFF - System BIOS
```

## Resources
https://en.wikipedia.org/wiki/BIOS_interrupt_call
https://en.wikipedia.org/wiki/Master_boot_record
https://wiki.osdev.org/Tutorials
Linux Kernel Development 3rd Edition