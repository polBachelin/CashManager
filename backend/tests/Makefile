##
## backend
## File description:
## Makefile
##

GO	=	go

GOFLAGS	=	-c --mod=vendor

NAME	=	test

all:	tests

tests:
	$(GO) mod vendor
	$(GO) test -o $(NAME) $(GOFLAGS)

fclean:
		rm -f $(NAME)

tests_run:	fclean tests
			./$(NAME) -test.v