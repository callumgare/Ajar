#!/usr/bin/env perl
use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
	module_name   => 'Game::Ajar',
	license       => 'perl',
	share_dir     => 'share',
	requires => {
		'perl'           => 5.010,
		'Test::More'     => 0,
		'File::ShareDir' => 0,
	},
	recommends => {
		'Test::Pod'           => 1.22,
		'Test::Pod::Coverage' => 0.18,
	},
	meta_merge => {
		resources => {
			license    => 'http://dev.perl.org/licenses/',
			repository => 'http://github.com/Blaizer/Ajar',
		},
	},
	add_to_cleanup => [
	],
);

$build->create_build_script;
