CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
LDSCRIPT = main_stat.ld

TARGET = freertos.elf
O = obj

SRCS := \
  freertos/Source/list.c \
  freertos/Source/portable/GCC/UVMM/port.c \
  freertos/Source/portable/GCC/UVMM/portISR.c \
  freertos/Source/portable/MemMang/heap_2.c \
  freertos/Source/queue.c \
  freertos/Source/tasks.c \
  gic.c \
  main.c \
  start.S

INCLUDES := \
  . \
  freertos/Source/include \
  freertos/Source/portable/GCC/UVMM

CPPFLAGS := $(addprefix -I,$(INCLUDES)) -MMD -MP

CFLAGS = -Wall -Wextra \
         -marm -mno-thumb-interwork -mabi=aapcs-linux \
         -march=armv8-r -fno-builtin -ffreestanding \
         -fomit-frame-pointer -fno-strict-aliasing -Og -g

ASFLAGS = -march=armv8-r -g

LINKER_FLAGS = -Map=$@.map -Bstatic --no-dynamic-linker --gc-sections

OBJS := $(SRCS:%=$(O)/%.o)
DEPS := $(OBJS:.o=.d)

.PHONY: all clean

all: $(O)/$(TARGET)

$(O)/$(TARGET): $(OBJS) Makefile
	$(LD) -o $@ $(OBJS) -T$(LDSCRIPT) $(LINKER_FLAGS) $(LDFLAGS)

$(O)/%.S.o: %.S Makefile
	mkdir -p $(dir $@)
	$(CC) -c $(CPPFLAGS) $(ASFLAGS) $< -o $@

$(O)/%.c.o: %.c Makefile
	mkdir -p $(dir $@)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $< -o $@

clean:
	rm -f $(O)/freertos.elf
	rm -f $(OBJS)

-include $(DEPS)
