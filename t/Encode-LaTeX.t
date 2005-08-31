# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Encode-LaTeX.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 2;
use Encode;
BEGIN { use_ok('Encode::LaTeX') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $str = "eacute => '" . chr(0xe9) . "'";

ok(encode('LaTeX', $str), "eacute => '\\'e'");
