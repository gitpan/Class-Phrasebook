# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'
BEGIN { $| = 1; print "1..10\n"; }
END {print "not ok 1\n" unless $loaded;}
use Class::Phrasebook;
use Log::LogLite;
$loaded = 1;
print "ok 1\n";
unlink("test.log"); # clean the test.log if it exits.
my $log = new Log::LogLite("test.log");

my $pb = new Class::Phrasebook($log, "test.xml");

print_ok($pb->load("EN"), 2, "load English dictionary");

my $phrase;

$phrase = $pb->get("HELLO_WORLD");
print_ok(clean_whites($phrase) eq clean_whites("Hello World!!!"), 3, 
	 "simple get");

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
my $hour_str = sprintf("%.2d:%.2d", $hour, $min);
$phrase = $pb->get("THE_HOUR", { hour => $hour_str });
print_ok(clean_whites($phrase) eq clean_whites("The time now is $hour_str."), 
	 4, "get with placeholder");

$phrase = $pb->get("ADDITION", { a => 10,
			         b => 11,
			         c => 21 });
print_ok(clean_whites($phrase) eq 
	 clean_whites("add 10 and 11 and you get 21"), 5, 
	 "get with several placeholders");

# now we load the Dutch dictionary
print_ok($pb->load("NL"), 6, "load Dutch dictionary");

$phrase = $pb->get("HELLO_WORLD");
print_ok(clean_whites($phrase) eq clean_whites("Hallo Wereld!!!"), 7, 
	 "simple get");

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
my $hour_str = sprintf("%.2d:%.2d", $hour, $min);
$phrase = $pb->get("THE_HOUR", { hour => $hour_str });
print_ok(clean_whites($phrase) eq clean_whites("Het is nu $hour_str."), 
	 8, "get with placeholder");

$phrase = $pb->get("ADDITION", { a => 10,
			         b => 11,
			         c => 21 });
print_ok(clean_whites($phrase) eq clean_whites("10 + 11 = 21"), 9, 
	 "get with several placeholders");

$phrase = $pb->get("THE_AUTHOR");
print_ok(clean_whites($phrase) eq clean_whites("Rani Pinchuk"), 10, 
	 "get from the default dictionary");

#######################
# clean_whites
#######################
sub clean_whites {
    my $str = shift;
    $str =~ s/\s+/ /goi;
    $str =~ s/^\s//;
    $str =~ s/\s$//;
    return $str;
} # of clean_whites

#############################################
# print_ok ($expression, $number, $comment)
#############################################
sub print_ok {
    my $expression = shift;
    my $number =shift;
    my $string = shift || "";

    $string = "ok " . $number . " " . $string . "\n";
    if (! $expression) {
        $string = "not " . $string;
    }
    print $string;
} # print_ok





