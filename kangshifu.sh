#!/usr/bin/gvim

* --- grub
	(hd1,2) : first HDD & second partition 
	$ root (hdX,Y)  指定/boot所在磁盘和分区
  	$ kernel /boot/vmlinuz-3.5.0-23-generic ro root=/dev/hda7
  	$ initrd /boot/initrd.img-3.5.0-23-generic
  	$ boot

* --- zt 当前行置顶， zz 当前行居中，zb 当前行置底

* --- :s/abc\zs[a-z]\ze//
 	\zs 替换开始处
 	\ze 替换结束处

* ---  函数返回: mov pc, lr	@ lr = pc(orig) - 4
	中断返回: mov pc, lr - 4	@ lr = pc(orig)

* --- .align
	.align: 在当期位置插入 0-3 字节，以使代码 4 字节对齐。
	.align 5 (2^5 ---> 32 字节对齐, cacheline 32 bits, 提高了效率)

* --- diff intel with AT&T
   	$ 在 AT&T 汇编格式中，寄存器名要加上 '%' 作为前缀；而在 Intel 
  	 汇编格式中，寄存器名不需要加前缀
   	AT&T  格式  pushl %eax 
   	Intel 格式  push eax 

	$ 在 AT&T 汇编格式中，用 '$' 前缀表示一个立即操作数；而在 Intel
	汇编格式中，立即数的表示不用带任何前缀
	AT&T  格式 pushl $1  
	Intel 格式 push 1  

	$ AT&T 和 Intel 格式中的源操作数和目标操作数的位置正好相反。在 Intel
	汇编格式中，目标操作数在源操作数的左边；而在 AT&T
	汇编格式中，目标操作数在源操作数的右边
	AT&T  格式 addl $1, %eax  
	Intel 格式 add eax, 1

	$ 在 AT&T
	汇编格式中，操作数的字长由操作符的最后一个字母决定，后缀'b'、'w'、'l'分别表示操作数为字节（byte，8
	比特）、字（word，16 比特）和长字（long，32比特）；而在 Intel
	汇编格式中，操作数的字长是用 "byte ptr" 和 "word ptr" 等前缀来表示的
	AT&T  格式  movb val, %al  
	Intel 格式  mov al, byte ptr val  

* --- skb 操作

	^--------^  -----> head
    | *******|
	^--------^  -----> data
    |        |
	^  data  ^
    |        |
	^--------^  -----> tail
    | ****** |
	 --------   -----> end

	$ skb_put()
	  将tail指针下移，增加sk_buff 的len 值，并返回skb->tail 的当前值

	$ skb_push()
	  会将data指针上移，也就是将数据添加在buffer的起始点，因此也要增加sk_buff的len值

	$ skb_pull()
	  将data指针下移，并减少skb的len值， 这个操作与skb_push()对应

	$ skb_reserve()
	  将data指针 和 tail 指针同时下移。这个操作用于在缓冲区头部预留len长度的空间

* --- 经过网桥处理后，再次进入netif_receive_skb()->handle_bridge()，此时skb->dev已经不
      是网卡设备了，而是网桥设备，注意到在向网桥添加端口时，是相应网卡dev->br_port赋值
	  为创建的端口，网桥设备是没有的，因此其br_port为空，在这一句会直接返回，进入正常的
	  协议栈流程

* --- shell 16进制输出
      x=`printf "%x" 345`
	  echo $x
	  
* --- shell 获取awk结果
      eval $(awk '{printf("x=%d",$1)}' file)
	  echo $x

* --- shift 
      位置参数可以用shift命令左移。比如(shift 3)表示原来的$4现在变成$1，原来的$5现在变成
	  $2等等，原来的$1、$2、$3丢弃，$0不移动

* --- Q:为什么在中断向量表中不直接LDR PC,"异常地址".而是使用一个标号,然有再在后面使用DCD
        定义这个标号
	  A:因为LDR指令只能跳到当前PC 4kB范围内,而B指令能跳转到32MB范围,而现在这样 在LDR PC,
	    "xxxx"这条指令不远处用"xxxx"DCD定义一个字,而这个字里面存放最终异常服务程序的地址,
		这样可以实现4GB全范围跳转. 

* --- Makefile 
      被依赖的标号只会执行一次，如果已经执行过了，就跳过。
	  例如：

	  x1:x3
	  .........
	  x2:x3
	  .........
	  x3:
	  .........
	  
	  x3 被x1和x2所依赖，如果x3被x1执行，那么执行x2时就不会再执行x3.

* --- 一般来说，由自旋锁所保护的每个临界区都是禁止内核抢占的。在单处理器系统上，这种锁本身并
      不起锁的作用，自旋锁技术仅仅是用来禁止或启用内核抢占。请注意，在自旋锁忙等期间，因为并
	  没有进入临界区，所以内核抢占还是有效的，因此，等待自旋锁释放的进程有可能被更高优先级的
	  所取代。这种设计是合理的，因为不能因为占用CPU太久而使系统死锁。

