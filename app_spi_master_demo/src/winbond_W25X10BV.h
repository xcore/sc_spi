// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

// instructions
#define PAGE_PROGRAM_CMD 0x02
#define READ_DATA_CMD 0x03
#define READ_STATUS_REG_CMD 0x05
#define WRITE_ENABLE_CMD 0x06
#define SECTOR_ERASE_CMD 0x20
#define JEDEC_ID_CMD 0x9F

// status reg masks
#define STATUS_BUSY_MASK 0b00000001
#define STATUS_WRITE_EN_MASK 0b00000010

// Expected values for Winbond W25x10BV flash used on XK-1A
#define MANUFACTURER_ID 0xEF
#define DEVICE_ID 0x3011
#define COMPLETE_ID 0xEF301100
