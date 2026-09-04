.DEFAULT_GOAL := all
include ../../../common/cmsis.mk
EXAMPLE ?= blink
IMPL ?= mixed
FLASH_KB ?= 16
ifeq ($(filter $(EXAMPLE),blink i2c_slave),)
$(error Unknown EXAMPLE '$(EXAMPLE)'; use blink or i2c_slave)
endif
ifeq ($(filter $(IMPL),spl registers mixed),)
$(error Unknown IMPL '$(IMPL)'; use spl, registers or mixed)
endif
ifeq ($(filter $(FLASH_KB),16 32 64),)
$(error FLASH_KB must be 16, 32 or 64)
endif
RAM_KB := $(if $(filter 64,$(FLASH_KB)),8,4)
EXAMPLE_PATH_blink := gpio/blink
EXAMPLE_PATH_i2c_slave := i2c/slave
EXAMPLE_DIR := examples/$(EXAMPLE_PATH_$(EXAMPLE))/$(IMPL)
DEVICE_DIR := src/CMSIS/GD/GD32F1x0
DRIVER_DIR := src/GD32F1x0_standard_peripheral
BUILD_DIR := build/$(EXAMPLE)/$(IMPL)/$(FLASH_KB)
LDSCRIPT := core/gd32f150.ld
SOURCES := $(wildcard $(EXAMPLE_DIR)/src/*.c) core/src/system_gd32f1x0.c \
 core/src/startup_gd32f150.s core/src/runtime.c
INCLUDES := core/include $(EXAMPLE_DIR)/src $(DEVICE_DIR)/Include $(DRIVER_DIR)/Include $(CMSIS_CORE_INCLUDE)
ifeq ($(IMPL),registers)
SOURCES += core/src/clock_registers.c
else
SOURCES += core/src/clock_spl.c $(DRIVER_DIR)/Source/gd32f1x0_rcu.c $(DRIVER_DIR)/Source/gd32f1x0_gpio.c
endif
ifeq ($(EXAMPLE),i2c_slave)
INCLUDES += examples/i2c/slave/common
ifneq ($(IMPL),registers)
SOURCES += $(DRIVER_DIR)/Source/gd32f1x0_i2c.c
endif
ifneq ($(IMPL),spl)
SOURCES += examples/i2c/slave/common/transport_registers.c
endif
endif
-include $(EXAMPLE_DIR)/libraries.mk
SOURCES += $(APP_LIBRARY_SOURCES)
INCLUDES += $(APP_LIBRARY_INCLUDES)
ARM_TOOLCHAIN ?=
TOOLCHAIN_BIN := $(patsubst %/,%,$(subst \,/,$(ARM_TOOLCHAIN)))
PREFIX := $(if $(strip $(TOOLCHAIN_BIN)),$(TOOLCHAIN_BIN)/arm-none-eabi-,arm-none-eabi-)
CC := "$(PREFIX)gcc"
OBJCOPY := "$(PREFIX)objcopy"
ARCH_FLAGS := -mcpu=cortex-m3 -mthumb
CPPFLAGS += -DGD32F130_150 $(addprefix -I,$(INCLUDES))
CFLAGS += $(ARCH_FLAGS) -std=c11 -Os -g -Wall -Wextra -ffunction-sections -fdata-sections
LDFLAGS += $(ARCH_FLAGS) -nostartfiles --specs=nano.specs --specs=nosys.specs \
 -Wl,--defsym=FLASH_SIZE=$(FLASH_KB)*1024,--defsym=RAM_SIZE=$(RAM_KB)*1024 \
 -T$(LDSCRIPT) -Wl,--gc-sections,-Map=$(BUILD_DIR)/$(EXAMPLE).map
ELF := $(BUILD_DIR)/$(EXAMPLE).elf
HEX := $(BUILD_DIR)/$(EXAMPLE).hex
BIN := $(BUILD_DIR)/$(EXAMPLE).bin
HEADERS := $(foreach dir,$(INCLUDES),$(wildcard $(dir)/*.h))
.PHONY: all clean
all: $(ELF) $(HEX) $(BIN)
$(ELF): $(SOURCES) $(HEADERS) $(LDSCRIPT) Makefile $(EXAMPLE_DIR)/libraries.mk ../../../common/cmsis.mk
	@$(call make-dir,$(BUILD_DIR))
	$(CC) $(CPPFLAGS) $(CFLAGS) $(SOURCES) $(LDFLAGS) -Wl,--start-group -lc -lm -lnosys -Wl,--end-group -o $@
$(HEX): $(ELF)
	$(OBJCOPY) -O ihex $< $@
$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@
clean:
	@$(call remove-tree,build)
