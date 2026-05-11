
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

## Resources
https://en.wikipedia.org/wiki/BIOS_interrupt_call
https://en.wikipedia.org/wiki/Master_boot_record
Linux Kernel Development 3rd Edition