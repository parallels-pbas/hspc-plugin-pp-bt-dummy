## Copyright (C) 1999-2012 Parallels IP Holdings GmbH and its affiliates.
## All rights reserved.
##
package HSPC::Plugin::PP::BT_Dummy;

use strict;
use HSPC::PluginToolkit::HTMLTemplate qw(parse_template);
use HSPC::PluginToolkit::General qw(string argparam get_help_url);

sub view_form {
	my $class = shift;
	my %h    = (
		config => undef,
		@_
	);
	my $config = $h{config};
	my $html;

	$html = parse_template(
				path => __PACKAGE__,
				name => 'bt_dummy_view.tmpl',
				data => { 
						merchant       => $config->{merchant},
						bank_code      => $config->{bank_code},
						account_number => $config->{account_number},
			}
		);

	return $html;
}

sub edit_form{
	my $class = shift;
	my %h    = (
		config  => undef,
		@_
	);
	my $html;
	my $config = $h{config};
	
	$html = parse_template(
				path => __PACKAGE__,
				name => 'bt_dummy_edit.tmpl',
				data => { 
						merchant       => $config->{merchant},
						bank_code      => $config->{bank_code},
						account_number => $config->{account_number},
			}
		);

	return $html;
}

sub collect_data{
	my $class = shift;
	my %h    = (
		config  => undef,
		@_
	);
	my $config = $h{config};
	
	$config->{merchant}       = argparam('merchant');
	$config->{bank_code}      = argparam('bank_code');
	$config->{account_number} = argparam('account_number');

	return $config;
}

sub get_help_page {
	my $class = shift;
	my %h    = (
		action  => undef,
		language  => undef,
		@_
	);

	my $action   = $h{action};
	my $language = $h{language};

	my  $html = parse_template(
				path => __PACKAGE__ . '::' . uc($language),
				name => "help_pp_$action.html",
				data => {
					about_url =>
					  get_help_url( action => 'about', language => $language, )
				},
			);

	return $html;
}

1;