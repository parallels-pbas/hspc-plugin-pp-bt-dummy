#!/usr/bin/perl

use strict;
use HSPC::WebDB qw(:DEFAULT trans);

use Storable qw(freeze);

my $accounts = select_hashrows(q|
	SELECT
		pm.id, pm.paytype_id, pm.pdata_id, pm.name, pm.account_no,
		pm.is_online, pm.is_enabled, pm.status, pm.customer_ip,
		NULL expire_date, ba.holder_name,pm.user_comment,pm.admin_comment
	FROM
		paymethod pm, paymethod_bankaccount ba
	WHERE
		pm.paytype_id = 'DUMMY' AND
		pm.id = ba.id
		
|);

foreach my $account (@$accounts) {
	my %hash = (
		type        => 'BT_Dummy',
		holder_name => $account->{holder_name}
	);

	my $trans = trans();

	select_run(q|
		INSERT INTO plugin_pm (
			id, type, name, account_no, enabled, recurring,
			status, template_id, customer_ip, expire_date,
			data_id, public_data, checksum
		) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, '0000-00-00 00:00:00', ?, ?, NULL)|,
		$account->{id}, 'BT_Dummy', $account->{name}, $account->{account_no},
		$account->{is_enabled}, $account->{is_online}, $account->{status}, 'BT_Dummy',
		$account->{customer_ip}, $account->{pdata_id}, freeze(\%hash)
	);
	select_run(q|
		INSERT INTO core_comment (node_id,node_type,
		create_date,comment_type,added_by,added_by_account,added_by_ip,
		is_public,comment_txt) VALUES (?,?,?,?,?,?,?,?,?)|,$account->{id},
		'HSPC::MT::PM::PluginEngine::BankAccount','0000-00-00 00:00:00',
		1,1,1,undef,1,$account->{user_comment}
	) if ( $account->{user_comment} );
	select_run(q|
		INSERT INTO core_comment (node_id,node_type,
		create_date,comment_type,added_by,added_by_account,added_by_ip,
		is_public,comment_txt) VALUES (?,?,?,?,?,?,?,?,?)|,$account->{id},
		'HSPC::MT::PM::PluginEngine::BankAccount','0000-00-00 00:00:00',
		1,1,1,undef,0,$account->{admin_comment}
	) if ( $account->{admin_comment} );

	select_run("delete from paymethod where paymethod.id = '$account->{id}'");
	select_run("delete from paymethod_bankaccount where paymethod_bankaccount.id = '$account->{id}'");

	$trans->commit();
}

