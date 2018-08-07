# Instructions

1. Run install-deps.sh (or install-deps.bat if on Windows) to install the dependencies.
2. Run each test with perl n-test-name.pl

## Troubleshooting

If `cpanm` or `local::lib` aren't available, dependecies can be installed with:

cpan DBI DBD::mysql Mojolicious Config::Simple