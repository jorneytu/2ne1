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
