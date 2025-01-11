#include <fcntl.h>
#include <stdlib.h>
#include <termio.h>
#include <unistd.h>

int main(void)
{
	int fd;
	char ch;
	struct termios old, new;
	const char *port = "/dev/ttyUSB0";

	fd = open(port, O_RDONLY | O_NOCTTY);
	if (fd < 0)
		exit(69);
	write(STDOUT_FILENO, "open\n", 5);

	tcgetattr(fd, &old);
	new = old;
	new.c_iflag |= (IGNPAR | ICRNL);
	new.c_cflag |= (CS8 | CREAD);
	new.c_lflag &= ~ICANON;
	new.c_cc[VTIME] = 100;
	new.c_cc[VMIN] = 0;
	cfsetospeed(&new, B9600);
	tcsetattr(fd, TCSANOW, &new);


	for (;;) {
		read(fd, &ch, 1);
		write(STDOUT_FILENO, "read\n", 5);
		if (ch == 'x')
			break;
	}

	write(STDOUT_FILENO, "qwer\n", 5);

	tcflush(fd, TCIOFLUSH);
	tcsetattr(fd, TCSANOW, &old);
	if (close(fd) != 0)
		exit(74);
	return 0;
}
