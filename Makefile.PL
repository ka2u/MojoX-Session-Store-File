use inc::Module::Install;
name 'MojoX-Session-Store-File';
all_from 'lib/MojoX/Session/Store/File.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
