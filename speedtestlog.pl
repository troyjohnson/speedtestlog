#! /usr/bin/perl -w

# speedtestlog.pl

# variables
#my $speedtestcli_bin = '/usr/local/bin/speedtest_cli';
my $speedtestcli_bin = '/usr/bin/speedtest-cli';
my $speedtestcli_args = '--simple';
my $speedtestcli_ver = '--version';
my $redirect_stderr = '2>&1';
my $logger_bin = '/usr/bin/logger';
my $logger_pri = 'local5.info';
my $logger_tag = 'SPEEDTEST';
my $logger_args = "-p ${logger_pri} -t ${logger_tag}";
my @errors = ();
my $error_msg = "";
my $log_msg = "";

# get speedtest output
my $speedtest_version_output =
	`${speedtestcli_bin} ${speedtestcli_ver} ${redirect_stderr}`;
chomp($speedtest_version_output);
my $speedtest_output =
	`${speedtestcli_bin} ${speedtestcli_args} ${redirect_stderr}`;

# extract data from output using regexes
my ($speedtest_version) =
	$speedtest_version_output =~ 
		m/(\d+\.\d+\.\d+)/;
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
if (not defined $st_ping) { push(@errors, "st_ping"); }
if (not defined $st_p_units) { push(@errors, "st_p_units"); }
if (not defined $st_download) { push(@errors, "st_download"); }
if (not defined $st_dl_units) { push(@errors, "st_dl_units"); }
if (not defined $st_upload) { push(@errors, "st_upload"); }
if (not defined $st_ul_units) { push(@errors, "st_ul_units"); }
if (not defined $speedtest_version) { push(@errors, "speedtest_version"); }
if (scalar(@errors) > 0) {
	$log_msg = 'error=\"true\" notdefined=\"' . 
		join(',', @errors) . '\" ';
} 
else {
	$log_msg = 'ping=\"' . $st_ping .
		'\" ping_units=\"' . $st_p_units . 
		'\" download=\"' . $st_download .
		'\" download_units=\"' . $st_dl_units .
		'\" upload=\"' . $st_upload .
		'\" upload_units=\"' . $st_ul_units .
		'\" version=\"' . $speedtest_version . '\" ';
}

# send log message
my $logger_cmd = "${logger_bin} ${logger_args} ${log_msg}";
my $logger_output = `${logger_cmd} ${redirect_stderr}`;

