#include<stdio.h>
#include<string.h>
#include "xfun.h"

struct alog
{
	int id;
	struct xlist list;
};

struct alog *header = NULL;

void init(void)
{
	header = (struct alog *)malloc(sizeof(struct alog));

	if(header == NULL)
		exit(0);

	header->id = 0;
	XLIST_HEAD_INIT(&header->list);
}

void show(void)
{
	struct xlist *current = &header->list;
	struct alog *tmp;

	printf("\n");
	do{
		current = current->next;
		tmp = xcontainer_of(current, struct alog, list);
		printf("%p : %d\n", tmp, tmp->id);
	}while(current->next != &header->list);
}
void node_create(int i)
{
	struct alog *tmp;
	tmp = (struct alog *)malloc(sizeof(struct alog));

	if(tmp == NULL)
		exit(0);

	tmp->id = i;

	printf("%p : %d\n",tmp, tmp->id);
	XLIST_ADD_TAIL(&tmp->list, &header->list);

}
int main()
{

	int i;
	printf("please Enter:");
	scanf(" %d",&i);

	init();
	while(i)
	{
		node_create(i);
		i--;
	}
	show();
}
