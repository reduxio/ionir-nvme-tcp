obj-m += ionir-nvme-tcp.o
#obj-m += simple-procfs-kmod.o

ifndef KVER
KVER=$(shell uname -r)
endif

ifndef KMODVER
KMODVER=$(shell git describe HEAD 2>/dev/null || git rev-parse --short HEAD)
endif

buildprep:
	# elfutils-libelf-devel is needed on EL8 systems
	sudo yum install -y gcc kernel-{core,devel,modules}-$(KVER) elfutils-libelf-devel
all:
	make -C /lib/modules/$(KVER)/build M=$(PWD) EXTRA_CFLAGS=-DKMODVER=\\\"$(KMODVER)\\\" modules
clean:
	make -C /lib/modules/$(KVER)/build M=$(PWD) clean
install:
	sudo install -v -m 755 -d /lib/modules/$(KVER)/
	sudo install -v -m 644 ionir-nvme-tcp.ko        /lib/modules/$(KVER)/ionir-nvme-tcp.ko
	sudo depmod -F /lib/modules/$(KVER)/System.map $(KVER)
