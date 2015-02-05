CROSS_COMPILE := mips-linux-uclibc-
ARCH := mips
export ARCH CROSS_COMPILE

obj-m := hello.o

ifneq ($(KERNELDIR),)
else
	KERNELDIR := /home/jorney/work/pc018work-v16_1202/apv5sdk-v16/linux/kernels/mips-linux-2.6.31/
	PWD := $(shell pwd)
modules:
	$(MAKE) -C $(KERNELDIR) M=$(PWD)  modules
endif
