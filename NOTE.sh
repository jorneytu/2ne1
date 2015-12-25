#!/bin/gvim

* sudo mount -t vboxsf sharing share/

***************************************************

http://ambcnsvn/svn/linux/impl/trunk/internal-share
http://ambcnsvn/svn/linux/impl/trunk/a5s_ipcam_sdk/document-new
http://ambcnsvn/svn/linux/impl/trunk/S2_linux_sdk/document
http://ambcnsvn/svn/linux/impl/trunk/S2L_linux_sdk/document
http://sh-wiki/mediawiki

\\ambshfs1

**************************************************

- Amboot
	* dump
		show mem

	* w8, w16, w32
		write

	* r8, r16, r32
		read

	* xmdl [addr] exec
		xmdl [addr] exec => download bin with XMODEM at mem addr and then execute

	* usbdl [addr]  exec
		 ...

	* show netboot
		... show environment

	* netboot
		download through net and then execute

		'setenv eth_mac 00:11:22:33:44:55' to set the MAC address.
		'setenv lan_ip 192.168.0.10' to set the target IP address.
		'setenv lan_mask 255.255.254.0' to set the network mask.
		'setenv lan_gw 192.168.0.1' to set the gateway ip.
		'setenv auto_dl 1' to enable the netboot at bootup.
		'setenv tftpd 192.168.0.9' to set the tftp server IP.
		'setenv pri_addr 0xc0100800' to set the starting address of RTOS/APP on DRAM.
		'setenv pri_file prkapp_debug.bin' to set the filename of RTOS/APP.



- ssh qtu@10.4.8.65 12345tu!

- amcode.ambarella.com

- curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo > ~/bin/repo

- repo
	repo init -u URL , 在当前目录安装 repository ，会在当前目录创建一个目录
	".repo" ， -u 参数指定一个URL， 从这个URL 中取得repository 的 manifest
	文件。

	repo init -u git://android.git.kernel.org/platform/manifest.git ，可以用 -m
	参数来选择 repository 中的某一个特定的 manifest
	文件，如果不具体指定，那么表示为默认的 manifest 文件 (default.xml)

	repo init -u git://android.git.kernel.org/platform/manifest.git -m
	dalvik-plus.xml 可以用 -b 参数来指定某个manifest 分支。

	repo start [branch]  ; create a new branch
	repo prune           ; delete branches which have merged
	repo abandon         ; delete branches no matter have merged or not
	repo branches/branch ; show branches
	repo diff            ;
	repo upload          ; commit

	example:
  		repo init -u ssh://amcode.ambarella.com:29418/ambarella/manifest.git -b master -m a12_ipcam.xml

- minicom

	* sudo usermod -a -G dialout [username] ; no need sudo for minicom

	* MINICOM='-m -c on'
	  export MINICOM    ; add these at /etc/profile , minicom with background-color

- http://amcode.ambarella.com.cn/svn/sys_doc

	* new data pdf by cao ...

- Ubuntu open terminal at current dir
 	sudo apt-get install nautilus-open-terminal
	reboot


- SDK build
	make sync_build_mkcfg
	make s2l_ipcam_config


- Makefile

	call函数是唯一一个可以用来创建新的参数化的函数。你可以写一个非常复杂的表达式，
	这个表达式中，你可以定义许多参数，然后你可以用call函数来向这个表达式传递参数。
	其语法是：

	$(call <expression>,<parm1>,<parm2>,<parm3>...)

	当make执行这个函数时，<expression>参数中的变量，如$(1)，$(2)，$(3)等，会被参数
	<parm1>，<parm2>，<parm3>依次取代。而<expression>的返回值就是
	call函数的返回值。例如：
	reverse = $(1) $(2)

	foo = $(call reverse,a,b)

	那么，foo的值就是"a b"。当然，参数的次序是可以自定义的，不一定是顺序的，如：

	reverse = $(2) $(1)
	foo = $(call reverse,a,b)

	此时的foo的值就是"b a"。


- repo
	Hi All,

	In order to avoid confusion, let unique the branch names.

	If you want to know the detailed branch for each git projects, pls see $PROJECT/.repo/manifest.xml

	For Kernel/Drivers developments on A5S/S2/S2L, Termed as "kernels branch", only used by us:

	repo init -u ssh://amcode.ambarella.com:29418/ambarella/manifest.git -b kernels

	For IAV Drivers developments on S2L, Termed as "s2l master branch", used by other teams:

	repo init -u ssh://amcode.ambarella.com:29418/ambarella/manifest.git -b master -m a12_ipcam.xml

	For For IAV Drivers developments on A5S/S2 , Termed as "a5s/s2 master branch", used by other teams:

	repo init -u ssh://amcode.ambarella.com:29418/ambarella/manifest.git -b master -m ipcam.xml

- fat32
	扇区大小512
	磁道与柱面: 数据的存取是沿柱面进行的.写满一个柱面,然后转向下一个.
	MBR: master boot recoder,主引导. 446 字节
	分区表项: 64 字节 16 * 4
		00      : 可引导标志. 0x00 - 不可引导; 0x80 - 可引导标志
		01 - 03 : 分区起始 CHS 地址
		04		: 分区类型
		05 - 07 : 分区结束地址
		08 - 0b : 分区起始LSA 地址
		0c - 0f : 分区大小扇区数

	簇: 由一组连续的扇区组成,扇区数2的n次幂,MAX = 64.

	# FAT32: 根目录从第2个簇开始

    # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	^ ---------- ^ ------------------ ^ ------- ^ ------- ^ ---------------------- ^ --------- ^ -------- ^ -------- ^ -------- ^ ----------^
	|     MBR    |  分区表项( 4 * 16) |  55 AA  |   ...   |	 DBR(文件系统引导扇区) |   FSINFO  |   ...    |   FAT 1  |   FAT 2  |  DATA ... |
	  ----------   ------------------   -------   -------   ----------------------   ---------   --------   --------   --------   ----------
	0           446                   			 		  *
												文件系统开始扇区位置

	> DBR: 大小为一个扇区
    # ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



- Cache clean & Cache flush & Cache invalidate
	1. 有时候需要区分buffer和cache：buffer解决CPU写的问题，比如将多次写操作
	buffer起来一次性更新；cache解决CPU读的问题，将数据cache起来在下次读的时候快速取用。

	2. cache有两种更新策略：write back和write through。writeback是将待写入
	memory的数据先放在cache中，直到cache位置将被替换时writeback到memory；
	write through是将数据同时写入cache和memory。

	3. invalidate：将cache数据设置为无效（即discard cache中的数据），不会将cache数据写入memory；
		clean（write back）：将cache数据写进memory；
		flush：clean and invalidate。

	4. 对于DMA From Device to Memory来说，invalidate range未必对其到cache line，
	这时需要首先将非对齐部分clean到memory，然后invalidate cache。

	A. DMA 从外设读取数据到供处理器使用时，可先进性invalidate 操作。这样将迫使
	处理器在读取cache中的数据时，先从内存中读取数据到缓存，保证缓存和内存中数据的一致性。

	B. DMA 向外设写入由处理器提供的数据时，可先进性writeback 操作。这样可以DMA
	传输数据之前先将缓存中的数据写回到内存中。

	如果不清楚DMA 操作的方向，也可先同时进行invalidate 和writeback 操作。操作的
	结果等同于invalidate 和 writeback 操作效果的和。

	==>  所谓8路组相连（ 8-way set associative）的含义是指，每个组里面有8个行。
	==> 举例来说，data cache: 32-KB, 8-way set associative, 64-byte line size
	==> Cache总大小为32KB，8路组相连（每组有8个line），每个line的大小linesize为64Byte,OK，
	==> 我们可以很轻易的算出一共有32K/8/64=64 个组。
	==> 对于32位的内存地址，每个line有2^6 = 64Byte，所以地址的【0，5】区分line中的那个字节。
	==> 一共有64个组。我们取内存地址中间6为来hash查找地址属于那个组。
	==> 即内存地址的【6，11】位来确定属于64组的哪一个组。组确定了之后，
	==> 【12，31】的内存地址与组中8个line挨个比对，如果【12，31】为与某个line一致，
	==> 并且这个line为有效，那么缓存命中。

	-- Cache 对速度有什么影响呢？这可以由 latency 来表示。CPU 在从记忆体中读取资料（或程式）时，
	-- 会需要等待一段时间，这段时间就是 latency，通常用 cycle 数表示。例如，一般来说，
	-- 如果资料已经在 L1 cache 中，则 CPU 在读取资料时（这种情形称为 L1 cache hit），
	-- CPU 是不需要多等的。但是，如果资料不在 L1 cache 中（这种情形称为 L1 cache miss），
	-- 则 CPU 就得到 L2 cache 去读取资料了。这种情形下，CPU 就需要等待一段时间。如果
	-- 需要的资料也不在 L2 cache 中，也就是 L2 cache miss，那么 CPU 就得到主记忆体中
	-- 读取资料了（假设没有 L3 cache）。这时候，CPU 就得等待更长的时间


- 如果我們希望讓ARM處於Suspend,進入低耗電的狀態(類似對裝置Clock Gating,只是並沒有
	透過PMIC關閉電源),也可以透過WFI(Wait For Interrupt)指令,讓ARM等待外部中斷.
	例如:IRQ或FIQ,對產品端而言就是手機的按鍵或是透過Real-Time Clock的中斷,喚醒處理器,
	恢復正常的執行.同时,也可以透過System Controller關閉處理器的電源(進入Doze Mode),
	只是相對於WFI,會變成處理器要重新Re-initialize,相關的狀態還要預存在TCM(Tightly-Couple Memory),
	這需要針對產品端要達成的目的來做設計上的評估.


- CacheCoherence
	主要會同步每個處理器L1與L2的Cache.
	如果有處理器更新到另一個處理器Cache中也有同位址的資料內容時,就會透過這機制把有同位址資料的處理器Cache進行更新.

* -- ARM MPCore 提供4中电源模式. RUN/Standby/Dormant/Shutdown .

	Standby : wakeup 最快的省电模式是Standby, 此时,处理器并未断电, 相关寄存器与coprocessor的
	状态都维持住,只有处理器进入 ClockGating的状态...
	如果希望处理器也断电,则可以进一步把相关状态寄存器储存到处理器的 TCM 中.

	Dormant : 进入模式前,把所有寄存器状态储存在 RAM 中,以恢复.

* Cortex A9 l2c310 Cache feature
	$ Double linefill issuing
	$ Prefetch hints
	$ Full line of zero write
	$ Double linefill issuing
	$ Internal instruction and data prefetch engine
	$ Double linefill issuing


	-->==> 当所有 RUNNING 进程的时间片被用完之后，调度器将重新计算所有进程的 counter 值，所有进程不仅包括
	RUNNING 进程，也包括处于睡眠状态的进程


* timer
	timer_irq()
		==> xx->event_handle()	* ( 最开始为 tick_handle_periodic(), 一定时候触发转换成HRTIMER，该函数替换为
								hrtimer_interrupt() / tick_nohz_handler).
	处理方式：
		HRTIMER：红黑树任务链表，timer中断触发，取head->next任务,
		如果任务时间到，执行。执行完，设置重新设置timer。timer
		中断间隔一直在变,可大，可小。任务执行一般在中断上文进行，也有软中断触发。

		内核使用了一个取巧的办法：既然高精度模式已经启用，可以定义一个hrtimer，把它的到期时间设定为一个jiffies的时间，
		当这个hrtimer到期时，在这个hrtimer的到期回调函数中，进行和原来的tick_device同样的操作，然后把该hrtimer的到
		期时间顺延一个jiffies周期，如此反复循环，完美地模拟了原有tick_device的功能

		NO_HZ: 主要应用于timer 中断间隔大于 1 * jiffies。任务队列平常一样，有软中断触发。没有精度要求。


* Ubuntu 14.04 skype
  sudo sh -c "echo 'deb http://archive.canonical.com/ubuntu/ trusty partner' >> /etc/apt/sources.list.d/canonical_partner.list"
  sudo apt-get update
  sudo apt-get install skype

* -Wl,--build-id=none
  pass a linker option from gcc (rm .note.gnu.build-id)

*
