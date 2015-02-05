/* ^!^ *
 * Copyright CN
 * Jorney (jorneytu@163.com)
 * 2014年 07月 31日 星期四 16:32:33 CST
 */
#ifndef _XFUN_
#define _XFUN_
struct xlist
{
	struct xlist *prev;
	struct xlist *next;
};

#define xcontainer_of(ptr, type, member) \
    (type *)((char *)ptr - (char *)&(((type *)0)->member))

void XLIST_HEAD_INIT(struct xlist *header)
{
	header->prev = header;
	header->next = header;
}
void xlist_add(struct xlist *new, struct xlist *prev, struct xlist *next)
{
	prev->next = new;

	new->prev = prev;
	new->next = next;

	next->prev = new;

}
void XLIST_ADD_TAIL(struct xlist *new, struct xlist *header)
{
	xlist_add(new, header->prev, header);
}

void xlist_del(struct xlist *prev, struct xlist *next)
{
	prev->next = next;
	next->prev = prev;
}
void XLIST_DEL(struct xlist *entry)
{
	xlist_del(entry->prev, entry->next);
}

#endif /* _XFUN_ */
