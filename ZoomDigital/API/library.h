#ifndef LIBRARY_H
#define LIBRARY_H

#include <stdint.h>

void initialization(void);
void finalization(void);
void store(uint32_t address, uint8_t data);
uint8_t load(uint32_t address);
void pixel_decimation(void);
void block_average(void);
void nearest_neighbor(uint8_t offset_x, uint8_t offset_y);
void pixel_replication(uint8_t offset_x, uint8_t offset_y);
void open_image(const char *filename);
void reset(void);

#endif