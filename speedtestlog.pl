#! /usr/bin/perl -w

# speedtestlog.pl

# variables
my $speedtestcli_bin = '/usr/local/bin/speedtest-cli';
my $speedtestcli_args = '--simple';
my $speedtestcli_ver = '--version';
my $redirect_stderr = '2>&1';
my $logger_bin = '/usr/bin/logger';
my $logger_pri = 'local5.info';
my $logger_tag = 'SPEEDTEST';
my $logger_args = "-p ${logger_pri} -t ${logger_tag}";

# get speedtest output
my $speedtest_version =
	`${speedtestcli_bin} ${speedtestcli_ver} ${redirect_stderr}`;
chomp($speedtest_version);
my $speedtest_output =
	`${speedtestcli_bin} ${speedtestcli_args} ${redirect_stderr}`;

# extract data from output using regexes
my ($st_ping, $st_p_units) =
	$speedtest_output =~
		m/Ping: (\d*\.?\d+) (\S+)/;
my ($st_download, $st_dl_units) =
	$speedtest_output =~
		m/Download: (\d*\.?\d+) (\S+)/;
my ($st_upload, $st_ul_units) =
	$speedtest_output =~
		m/Upload: (\d*\.?\d+) (\S+)/;

# prepare log message
my $log_msg = 'ping=\"' . $st_ping .
	'\" ping_units=\"' . $st_p_units . 
	'\" download=\"' . $st_download .
	'\" download_units=\"' . $st_dl_units .
	'\" upload=\"' . $st_upload .
	'\" upload_units=\"' . $st_ul_units .
	'\" version=\"' . $speedtest_version . '\" ';

# send log message
my $logger_cmd = "${logger_bin} ${logger_args} ${log_msg}";
my $logger_output = `${logger_cmd} ${redirect_stderr}`;

