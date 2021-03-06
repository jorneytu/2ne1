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

* --- slab 解决申请内存不到一页，而引起的内存碎片和浪费问题
	  slab 的三链用于存放slab_partial, slab_full分别包含空闲与非空闲的slab的对象的链表
	  分配内存时，先从这3个区里分配空闲，如果没有空闲，就从新的页框中取页，来分配给slab。
* --- 高速缓存2^gf个页框的内存布局
	  ^ ------------- ^ -- ^ -- ^ -- ^ -- ^ ---- ^ ---- ^ --- ^ --- ^
      |  struct slab  |  x | .. | y  | .. | used | ...  |free | ... |
	    ------------- - -- - -- - -- - -- - ---- - ---- - --- - --- -
					  0         x		  ^
					      kmem_bufctl_t   ^   0      ~     x   ~  
						 				 |||
	struct slab						    s_mem 
	{
		list;
		colouroff;
		s_mem;       # 指向第一个已分配(used)或未分配(free)的slab对象
		inuse;       # 非空闲的对象的个数
		free;        # 下一个空闲的坐标
	}

	每个对象都有类型为kmem_bufctl_t的一个描述符，不过这个对象描述符只不过是一个无符号整数（16位），
	只有在对象空闲时才有意义。对象描述符存放在一个数组中，位于相应的slab 描述符之后.

	某个slab中有16个对象，其中只有1、3、5号对象空闲。那么1号对象描述符的值为3，3号对象描述符的值为5，
	5号对象描述符的值为BUFCTL_END



* --- pidmap_array位图来表示当前已分配的PID和闲置的PID号。因为一个页框包含32768个位（4*1024*8），
      所以在32位体系结构中pidmap_array位图正好存放在一个单独的页中。系统会一直保存这些页而不释放的

* --- k_struct描述符包含一个list_head类型的字段run_list。如果进程的优先权等于k（其取值范围从0到139），
     run_list字段就把该进程的优先级链入优先级为k的可运行进程的链表中。此外，在多处理器系统中，每个
	 CPU都有它自己的运行队列，即它自己的进程链表集。这是一个通过使数据结构更复杂来改善性能的典型例子：
	 调度程序的操作效率的确更高了，但运行队列的链表却为此被拆分成140个不同的队列

* --- 被抢占的进程并没有被挂起，因为它还处于TASK_RUNNING状态，只不过不再使用CPU.

* --- 静态优先级
      内核用100（最高优先级）到139（最低优先级）的整数表示普通进程的静态优先级.通过系统调用nice()和setprioritry().
	  基本时间片 = [ (140 - static_priority) * 20  if static_priority < 120 ] 
	           或= [ (140 - static_priority) * 5  if static_priority >= 120 ]

* --- 动态优先级
      prio小于100就是实时进程.
	  动态优先级，其值的范围也是是100（最高优先级MAX_RT_PRIO，低于100就成了实时进程了）到139（最低优先级MAX_PRIO）
	  动态优先级 = max (100, min (静态优先级 - bonus + 5, 139)) 
      平均睡眠时间越久，bonus值越大.bonus（奖赏）是从范围0~10的值，值小于5表示降低动态优先级以惩戒.
	  平均睡眠时间就是进程在睡眠状态中所消耗的平均纳秒数，其存放在task_struck的sleep_avg字段中

	  进程是先进先出（FIFO）的实时进程,想占用CPU多久就占用多久，而且不可能比其他优先级低或其他优先级相等的进程所抢占

	  基于时间片轮转的实时进程（rt_task(p) && (p->policy == SCHED_RR)）不能更新其动态优先级，而只能修改其时间片

* --- CPU高速缓存

      malloc_sizes[] 为高速缓存划分不同大小的空间。
	  kmalloc() 从 malloc_sizes[] 根据分配空间大小选择不同大小的高速缓存类，然后再去划分内存。

	  slab结构作为访问热点，必须考虑缓存的问题。所谓的着色，就是每次分配一个结构，都比上一个结构偏移一个缓存行的大小，
	  这样，能保证两个结构存在于不同的缓存行中。否则，就会发生所谓cache line bouncing的问题，就是不同的地址，争夺
	  同一缓存行的现象，即访问A, A被装入某缓存行， 然后访问B, B刚好又装入同一缓存行，这样每次访问都要付出cache miss
	  + 访问内存 + 装入缓存的代价.

	  Cache命中：假定Cache 大小为16KB，块大小为16字节(slab 着色 16),32位体系结构
	  offset: 4个比特位 ==> 2^4 
	  index:  10个比特位 ==> 2^14 / 2^4 = 2^10
	  tag:    18个比特位

	  访问地址解析：
	  ^-------------------------------------^   ^-------------------------------------------^
      |   31 - 14   |   13 - 4    |  3 - 0  |   |  0  |  1  |  2  |  3  |  ~~ |  14  |  15  | 
	  ---------------------------------------   ---------------------------------------------
	  tag        index(块)    块内偏移                           数据(字节)
	  例如CPU访问地址 0x80001004 ==> 1000 0000 0000 0000 0001 0000 0000 0100
                                     ^                     ^            ^
	  index = 0x100 则查找 0x100块Cache
	  如果0x100中的tag值等于0010 0000 0000 0000 0000 0000 则说明Cache已经映射了主内存，无需再访问主内存
	  接着加上块内偏移，就可以访问该地址对应的数据了。

	  在创建slab阶段，每个slab倾向于把一个或多个页面平均分成 x 个 (x + ?)个对象。
	  每个 slab 需要一个 struct slab 数据结构和一个管理所有空闲对象的kmem_bufctl_t（4 字节的无符号整数）的数组.

* --- 抢占式内核与非抢占是内核
	 	 (非抢占式)
		 非抢占式内核是由任务主动放弃CPU的使用权。中断服务可以使一个高优先级的任务由挂起状态变为就绪状态。
		 但中断服务以后控制权还是回到原来被中断了的那个任务，直到该任务主动放弃CPU的使用权时，那个高优先级
		 的任务才能获得CPU的使用权。

		 (非抢占式内核的优点有)：
		 ·中断响应快(与抢占式内核比较)；
		 ·允许使用不可重入函数；
		 ·几乎不需要使用信号量保护共享数据。运行的任务占有CPU，不必担心被别的任务抢占。这不是绝对的，在打印机的使用上，仍需要满足互斥条件。

		 (非抢占式内核的缺点有)：
		 ·任务响应时间慢。高优先级的任务已经进入就绪态，但还不能运行，要等到当前运行着的任务释放CPU。
		 ·非抢占式内核的任务级响应时间是不确定的，不知道什么时候最高优先级的任务才能拿到CPU的控制权，完全取决于应用程序什么时候释放CPU.
		 (抢占式)
		 使用抢占式内核可以保证系统响应时间。最高优先级的任务一旦就绪，总能得到CPU的使用权。当一个运行着的
		 任务使一个比它优先级高的任务进入了就绪态，当前任务的CPU使用权就会被剥夺，或者说被挂起了，那个高优
		 先级的任务立刻得到了CPU的控制权。如果是中断服务子程序使一个高优先级的任务进入就绪态，中断完成时，
		 中断了的任务被挂起，优先级高的那个任务开始运行

		 (抢占式内核的优点有)
		 ·使用抢占式内核，最高优先级的任务什么时候可以执行，可以得到CPU的使用权是可知的。使用抢占式内核使得
		 任务级响应时间得以最优化。

		 (抢占式内核的缺点有)
		 ·不能直接使用不可重入型函数。调用不可重入函数时，要满足互斥条件，这点可以使用互斥型信号量来实现。
		 如果调用不可重入型函数时，低优先级的任务CPU的使用权被高优先级任务剥夺，不可重入型函数中的数据有可能被破坏。


* ---  barrier()
 	这就是所谓的内存屏障，前段时间曾经讨论过。CPU越过内存屏障后，将刷新自已对存储器的缓冲状态。这条语句实际上
	不生成任何代码，但可使gcc在barrier()之后刷新寄存器对变量的分配.
