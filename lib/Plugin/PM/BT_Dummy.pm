## Copyright (C) 1999-2012 Parallels IP Holdings GmbH and its affiliates.
## All rights reserved.
##
package HSPC::Plugin::PM::BT_Dummy;

use strict;

use HSPC::PluginToolkit::General qw(string argparam);
use HSPC::PluginToolkit::HTMLTemplate qw(parse_template);

sub view_form {
	my $class = shift;
	my %h = (
		secure_data      => undef,
		public_data      => undef,
		name             => undef,
		type_info        => undef,
		number_link      => undef,
		@_
	);

	my %th = (
		type_txt    => string($h{type_info}->{type_title_id}),
		holder_name => $h{public_data}->{holder_name},
		number_link => $h{number_link},
	);

	## Fill private data
	if ($h{secure_data}) {
		$th{only_public}    = 0;
		$th{folder_title}   = string('bapm_dummy_private_data_uc');
		$th{account_number} = $h{secure_data}->{bank_code} .
			' ' . $h{secure_data}->{account_number};
	} else {
		$th{only_public}    = 1;
		$th{folder_title}   = string('bapm_dummy_public_data_uc');
		$th{account_number} = $h{name};
	}

	return {
		content => parse_template(path => __PACKAGE__, name => 'pm_view_form.tmpl', data => \%th),
	};
}

sub edit_form {
	my $class = shift;
	my %h = (
		public_data      => undef,
		secure_data      => undef,
		name             => undef,
		allowed_types    => undef,
		@_
	);

	my %th = (
		holder_name => $h{public_data}->{holder_name},
		type_txt    => $h{allowed_types}->[1]->[1],
	);

	## Fill private data
	if ($h{secure_data}) {
		$th{only_public}    = 0;
		$th{folder_title}   = string('bapm_dummy_private_data_uc');
		$th{account_number} = $h{secure_data}->{account_number};
		$th{bank_code}      = $h{secure_data}->{bank_code};
	} else {
		$th{only_public}    = 1;
		$th{folder_title}   = string('bapm_dummy_public_data_uc');
		$th{account_number} = $h{name};
	}

	return {
		content => parse_template(path => __PACKAGE__, name => 'pm_edit_form.tmpl', data => \%th),
		js_onsubmit => undef
	};
}

sub add_form {
	my $class = shift;
	my %h = (
		public_data      => undef,
		secure_data      => undef,
		account_data     => undef,
		@_
	);

	my %th = (
		account_number => $h{secure_data} ? $h{secure_data}->{account_number} : undef,
		bank_code      => $h{secure_data} ? $h{secure_data}->{bank_code} : undef,
	);

	## Prepopulate holder name
	if ($h{account_data}) {
		if ($h{account_data}->{is_corporate}) {
			$th{holder_name} = $h{account_data}->{billing_fname} .
				' ' . $h{account_data}->{billing_lname};
		} else {
			$th{holder_name} = $h{account_data}->{admin_fname} .
				' ' . $h{account_data}->{admin_lname};
		}
	} elsif ($h{public_data}) {
		$th{holder_name} = $h{public_data}->{holder_name};
	}

	return {
		content => parse_template(path => __PACKAGE__, name => 'pm_add_form.tmpl', data => \%th),
		js_onsubmit => undef
	};
}

sub collect_data {
	my $class = shift;
	my %h = (
		secure_data      => undef,
		public_data      => undef,
		account_data     => undef,
		@_
	);

	my %data;
	if ($h{secure_data} && $h{secure_data}->{bank_code}) {
		## Update payment method number
		$data{bank_code} = $h{secure_data}->{bank_code};
		$data{account_number} = $h{secure_data}->{account_number};
	} else {
		## Set a new one
		$data{bank_code} = &argparam('bank_code');
		$data{account_number} = &argparam('account_number');
	}

	$data{holder_name} = &argparam('holder_name');

	return \%data;
}

sub get_help_page {
	my $class = shift;
	my %h = (
		action        => undef,
		template_id   => undef,
		language      => undef,
		customer_view => undef,
		@_
	);

	if ($h{action}) {
		my $path = __PACKAGE__ . '::' . uc($h{language});
		return parse_template(path => $path, name => "help_pm_$h{action}.html", data => \%h);
	}
	return undef;
}

1;
