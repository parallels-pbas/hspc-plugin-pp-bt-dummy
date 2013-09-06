## Copyright (C) 1999-2012 Parallels IP Holdings GmbH and its affiliates.
## All rights reserved.
##
package HSPC::MT::Plugin::PM::BT_Dummy;

use strict;

use HSPC::PluginToolkit::General qw(throw_exception);

sub provided_payment_method_types {
	my $class = shift;

	return [
		{type => 'BT_Dummy', title_id => 'bapm_dummy_type_dummy', image_id => ''},
	];
}

sub title_id {
	return 'bapm_dummy_ba_uc';
}

sub get_public_data {
	my $class = shift;
	my %h = (
		data             => undef,
		@_
	);

	my %public_data = (
		holder_name    => $h{data}->{holder_name},
	);
	return \%public_data;
}

sub get_secure_data {
	my $class = shift;
	my %h = (
		data             => undef,
		keep_secure_code => undef,
		@_
	);

	my %secure_data = (
		account_number => $h{data}->{account_number},
		bank_code      => $h{data}->{bank_code},
	);
	return \%secure_data;
}

sub get_public_number {
	my $class = shift;
	my %h = (
		secure_data => undef,
		public_data => undef,
		@_
	);

	return "****" . substr($h{secure_data}->{account_number},-4);
}

sub get_secure_number {
	my $class = shift;
	my %h = (
		secure_data => undef,
		public_data => undef,
		@_
	);

	return $h{secure_data}->{bank_code}.$h{secure_data}->{account_number};
}

sub validate {
	my $class = shift;
	my %h = (
		expire_date => undef,
		secure_data => undef,
		public_data => undef,
		type        => undef,
		@_
	);

	throw_exception(
		type    => 'parameter',
		message => {string_id => 'holder_name_not_defined'}
	) unless $h{public_data}->{holder_name};

	return unless $h{secure_data};

	throw_exception(
		type    => 'parameter',
		message => {string_id => 'dummy_bank_code_required'}
	) unless $h{secure_data}->{bank_code};

	throw_exception(
		type    => 'parameter',
		message => {string_id => 'dummy_bank_code_length8'}
	) if length($h{secure_data}->{bank_code}) > 8;

	throw_exception(
		type    => 'parameter',
		message => {
			string_id => 'bapm_dummy_bank_code_is_wrong',
			string_args => {code => $h{secure_data}->{bank_code}}
		}
	) if $h{secure_data}->{bank_code} =~ /\D/;

	if (
		!length($h{secure_data}->{account_number}) ||
		$h{secure_data}->{account_number} =~ /\D/ ||
		length($h{secure_data}->{account_number}) > 10
	) {
		throw_exception(
			type    => 'parameter',
			message => {
				string_id => 'bapm_dummy_account_number_is_wrong',
				string_args => {acc => $h{secure_data}->{account_number}}
			}
		);
	}

	return undef;
}

sub get_paymethod_type {
	return 'BT_Dummy';
}

1;
