#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/timer.h>
struct timer_list timer;
int magic = 10;

void good_luck(void *p)
{
	printk("GOOD LUCK\n");
	if(--magic <= 5){
		del_timer(&timer);
		return;
	}

	mod_timer( &timer, jiffies + magic * HZ);
}

static int after_init(void)
{

	init_timer(&timer);
	timer.expires = jiffies + magic * HZ;
	timer.data = NULL;
	timer.function = good_luck;

	add_timer(&timer);

	return 0;
}

void after_exit(void)
{
	del_timer(&timer);
}

module_init(after_init);
module_exit(after_exit);

MODULE_LICENSE("GPL");
