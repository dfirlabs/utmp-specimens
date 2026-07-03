#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <utmp.h>
#include <time.h>

void write_entry(
      short entry_type,
      const char *user,
      const char *line,
      const char *id,
      const char *host,
      time_t log_time )
{
	struct utmp entry;

	memset( &entry, 0, sizeof( struct utmp ) );

	entry.ut_type = entry_type;
	entry.ut_pid = getpid();
	entry.ut_tv.tv_sec = log_time;

	if( line != NULL )
	{
		strncpy( entry.ut_line, line, sizeof( entry.ut_line ) );
	}
	if( id != NULL )
	{
		strncpy( entry.ut_id, id, sizeof( entry.ut_id ) );
	}
	if( user != NULL )
	{
		strncpy( entry.ut_user, user, sizeof( entry.ut_user ) );
	}
	if( host != NULL )
	{
		strncpy( entry.ut_host, host, sizeof( entry.ut_host ) );
	}
	setutent();
	pututline( &entry );
	endutent();
}

int main( void ) {
	time_t current_time = time(NULL);
	time_t old_time = current_time;
	time_t new_time = current_time + 300;

	write_entry( EMPTY, "", "", "", "", current_time );

	write_entry( INIT_PROCESS, "", "tty2", "t2", "", current_time );

	write_entry( LOGIN_PROCESS, "LOGIN", "tty2", "t2", "", current_time );

	write_entry( USER_PROCESS, "developer", "tty2", "t2", "10.0.0.5", current_time );

	write_entry( DEAD_PROCESS, "", "tty2", "t2", "", current_time );

	write_entry( BOOT_TIME, "reboot", "system boot", "~", "0.0.0.0", current_time );

	write_entry( RUN_LVL, "shutdown", "runlevel 0", "~", "", current_time );

	write_entry( OLD_TIME, "date", "|", "~~", "", old_time );

	write_entry( NEW_TIME, "date", "}", "~~", "", new_time );

	return 0;
}

