use Test::More 'no_plan';
use File::Temp qw(tempdir);
use File::Spec;
use MojoX::Session;
use MojoX::Session::Store::File;

my $tempdir = tempdir(DIR => ".", CLEANUP => 1);
#my $tempdir = "./tmp";

my $session = MojoX::Session->new(
   store => MojoX::Session::Store::File->new(dir => $tempdir),
#   expires_delta => 3600,
);

$session->create;
$session->data(hoge => "foo", bar => "boo");
$session->flush;
ok(-f File::Spec->catfile($tempdir, $session->sid . ".dat"), "session file exists");
is($session->data('hoge'), "foo", "store data hoge");
is($session->data('bar'), "boo", "store data var");

$session->data(hoge => "uoo");
$session->flush;
is($session->data("hoge"), "uoo", "update");

$session->clear('hoge');
$session->flush;
isnt($session->data('hoge'), "foo", "clear");

#$session->expire;
#$session->flush;
#ok($session->sid, "delete");

