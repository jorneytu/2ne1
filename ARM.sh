#!/bin/gvim

$ "ax" 表示：a为section is allocatable, x为executable
	s: .section	".idmap.text", "ax"

$ .org: 汇编伪指令
	.org offest, fill
	移动当前位置到到当前段的offset, 不可往前移动，否则忽略指令
	当前位置到offset之间填充fill(default is zero)

$ .text . : { *(.text) }和.text : { *(.text) }
	这两个描述是截然不同的，第一个将.text section的VMA设置为定位符号的值，
	而第二个则是设置成定位符号的修调值 = $(满足对齐要求后的)。


$ .xxx (VMD):(LMD){}
	VMD 内存运行地址，编译器链接会使用该值，对应 map
	LDM 加载地址

$ ldrex & strex
	ldrex Rd, Rs      ;
	strex Rt, Rs, Rd  ; # if do strex successfully; then Rt = 0; 用于操作自旋

	ldrex & strex 是通过arm的exclusive monitor 的机制实现的. EM是一个状态机.
	ldrex 将状态机置为exclusive状态, strex将状态机置为open状态.保证访问的唯一性

$ ldr r0, xxx & ldr r0, =xxx
  第一个表示加载xxx标号地址指向的内容，第二个表示获取xxx标号的地址。

$ 任何一个文件的任意section只能在SECTIONS命令内出现一次。
	看如下例子
	SECTIONS {
	.data : { *(.data) }
	.data1 : { data.o(.data) }
	}
	data.o文件的.data section在第一个OUTPUT-SECTION-COMMAND命令内被使用了,那么在第二个OUTPUT-
	SECTION-COMMAND命令内将不会再被使用,也就是说即使连接器不报错,输出文件的.data1 section的内容也是
	空的。
