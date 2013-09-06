## Copyright (C) 1999-2012 Parallels IP Holdings GmbH and its affiliates.
## All rights reserved.
##
package HSPC::MT::Plugin::PP::BT_Dummy;

use HSPC::PluginToolkit::General qw(split_date_string datetime_gmt_now string);
use strict;

sub get_title {
	my $class = shift;
	
	return "Dummy bank transfer plugin";
}

sub process_batch_content {
	my $class = shift;
	my %h = (
		config           => undef,
		transaction_list => undef,
		vendor_info      => undef,
		file_id          => undef,
		@_
	);

	my $config = $h{config};
	my $transaction_list = $h{transaction_list};
	my $file_id = $h{file_id};

	my %cdate = split_date_string( datetime_gmt_now() );
	my $today_date = $cdate{day}.$cdate{month}.substr($cdate{year},-2);

	my $batch_content = "HEADER {\n" . 
		"provider_bank_code  - ". $config->{bank_code} ."\n" . 
		"provider_acc_number - ". $config->{account_number}."\n" . 
		"provider_merch_name - ". $config->{merchant}."\n" .
		"today_date          - ". $today_date."\n}\nCONTENT\n";

	my $result_amount   = 0;
	my $number_of_c_records = 0;

	foreach my $t (@$transaction_list) {
		$batch_content .= ++$number_of_c_records . ": {\n" . 
			"customer_bank_code  = ". $t->{payment_method}->{secure_data}->{bank_code}. "\n" .
			"customer_acc_number = ". $t->{payment_method}->{secure_data}->{account_number}. "\n" .
			"customer_merch_name = ". $t->{payment_method}->{public_data}->{holder_name}. "\n" .
			"customer_country    = ". $t->{account_info}->{address_country} . "\n" .
			"amount              = ". $t->{transaction_amount} . "\n" .
			"payment_purpose     = ". string('dummy_pp_description',
				doc_name => $t->{document_info}->{name},
				doc_num => $t->{document_info}->{number},
			)  . "\n}\n";

		$result_amount   += $t->{transaction_amount};
	}
	
	$batch_content .= "END {\n" . 
			"result_amount = " . $result_amount. "\n" .
			"c_number      = " . $number_of_c_records . "}\n";

	return {
		BATCH_CONTENT   => $batch_content,
		BATCH_FILE_NAME => sprintf("dummy_file_%06d.txt", $file_id),
	};
}

sub get_supported_payment_method_types{
	my $class = shift;
	
	return [
		'BT_Dummy',
	];
}

sub get_currencies_supported{
	return [
				'ADP', # Andorran Peseta
				'AED', # UAE Dirham
				'AFA', # Afghani
				'ALL', # Lek
				'AMD', # Armenian Dram
				'ANG', # Antillian Guilder
				'AON', # New Kwanza
				'AOR', # Kwanza Reajustado
				'ARS', # Argentine Peso
				'ATS', # Schilling
				'AUD', # Australian Dollar
				'AWG', # Aruban Guilder
				'AZM', # Azerbaijanian Manat
				'BAM', # Convertible Marks
				'BBD', # Barbados Dollar
				'BDT', # Taka
				'BEF', # Belgian Franc
				'BGL', # Lev
				'BGN', # Bulgarian LEV
				'BHD', # Bahraini Dinar
				'BIF', # Burundi Franc
				'BMD', # Bermudian Dollar
				'BND', # Brunei Dollar
				'BRL', # Brazilian Real
				'BSD', # Bahamian Dollar
				'BTN', # Ngultrum
				'BWP', # Pula
				'BYR', # Belarussian Ruble
				'BZD', # Belize Dollar
				'CAD', # Canadian Dollar
				'CDF', # Franc Congolais
				'CHF', # Swiss Franc
				'CLF', # Unidades de fomento
				'CLP', # Chilean Peso
				'CNY', # Yuan Renminbi
				'COP', # Colombian Peso
				'CRC', # Costa Rican Colon
				'CUP', # Cuban Peso
				'CVE', # Cape Verde Escudo
				'CYP', # Cyprus Pound
				'CZK', # Czech Koruna
				'DEM', # Deutsche Mark
				'DJF', # Djibouti Franc
				'DKK', # Danish Krone
				'DOP', # Dominican Peso
				'DZD', # Algerian Dinar
				'ECS', # Sucre
				'ECV', # Unidad de Valor Constante (UVC)
				'EEK', # Kroon
				'EGP', # Egyptian Pound
				'ERN', # Nakfa
				'ESP', # Spanish Peseta
				'ETB', # Ethiopian Birr
				'EUR', # Euro
				'FIM', # Markka
				'FJD', # Fiji Dollar
				'FKP', # Pound
				'FRF', # French Franc
				'GBP', # Pound Sterling
				'GEL', # Lari
				'GHC', # Cedi
				'GIP', # Gibraltar Pound
				'GMD', # Dalasi
				'GNF', # Guinea Franc
				'GRD', # Drachma
				'GTQ', # Quetzal
				'GWP', # Guinea-Bissau Peso
				'GYD', # Guyana Dollar
				'HKD', # Hong Kong Dollar
				'HNL', # Lempira
				'HRK', # Kuna
				'HTG', # Gourde
				'HUF', # Forint
				'IDR', # Rupiah
				'IEP', # Irish Pound
				'ILS', # New Israeli Sheqel
				'INR', # Indian Rupee
				'IQD', # Iraqi Dinar
				'IRR', # Iranian Rial
				'ISK', # Iceland Krona
				'ITL', # Italian Lira
				'JMD', # Jamaican Dollar
				'JOD', # Jordanian Dinar
				'JPY', # Yen
				'KES', # Kenyan Shilling
				'KGS', # Som
				'KHR', # Riel
				'KMF', # Comoro Franc
				'KPW', # North Korean Won
				'KRW', # Won
				'KWD', # Kuwaiti Dinar
				'KYD', # Cayman Islands Dollar
				'KZT', # Tenge
				'LAK', # Kip
				'LBP', # Lebanese Pound
				'LKR', # Sri Lanka Rupee
				'LRD', # Liberian Dollar
				'LSL', # Loti
				'LTL', # Lithuanian Litas
				'LUF', # Luxembourg Franc
				'LVL', # Latvian Lats
				'LYD', # Libyan Dinar
				'MAD', # Moroccan Dirham
				'MDL', # Moldovan Leu
				'MGF', # Malagasy Franc
				'MKD', # Denar
				'MMK', # Kyat
				'MNT', # Tugrik
				'MOP', # Pataca
				'MRO', # Ouguiya
				'MTL', # Maltese Lira
				'MUR', # Mauritius Rupee
				'MVR', # Rufiyaa
				'MWK', # Kwacha
				'MXN', # Mexican Peso
				'MXV', # Mexican Unidad de Inversion (UDI)
				'MYR', # Malaysian Ringgit
				'MZM', # Metical
				'NAD', # Namibia Dollar
				'NGN', # Naira
				'NIO', # Cordoba Oro
				'NLG', # Netherlands Guilder
				'NOK', # Norwegian Krone
				'NPR', # Nepalese Rupee
				'NZD', # New Zealand Dollar
				'OMR', # Rial Omani
				'PAB', # Balboa
				'PEN', # Nuevo Sol
				'PGK', # Kina
				'PHP', # Philippine Peso
				'PKR', # Pakistan Rupee
				'PLN', # Zloty
				'PTE', # Portuguese Escudo
				'PYG', # Guarani
				'QAR', # Qatari Rial
				'ROL', # Leu
				'RUB', # Russian Ruble
				'RUR', # Russian Ruble
				'RWF', # Rwanda Franc
				'SAR', # Saudi Riyal
				'SBD', # Solomon Islands Dollar
				'SCR', # Seychelles Rupee
				'SDD', # Sudanese Dinar
				'SEK', # Swedish Krona
				'SGD', # Singapore Dollar
				'SHP', # St Helena Pound
				'SIT', # Tolar
				'SKK', # Slovak Koruna
				'SLL', # Leone
				'SOS', # Somali Shilling
				'SRG', # Surinam Guilder
				'STD', # Dobra
				'SVC', # El Salvador Colon
				'SYP', # Syrian Pound
				'SZL', # Lilangeni
				'THB', # Baht
				'TJR', # Tajik Ruble (old)
				'TJS', # Somoni
				'TMM', # Manat
				'TND', # Tunisian Dinar
				'TOP', # Pa'anga
				'TPE', # Timor Escudo
				'TRY', # Turkish Lira
				'TTD', # Trinidad and Tobago Dollar
				'TWD', # New Taiwan Dollar
				'TZS', # Tanzanian Shilling
				'UAH', # Hryvnia
				'UGX', # Uganda Shilling
				'USD', # US Dollar
				'USN', # (Next day)
				'USS', # (Same day)
				'UYU', # Peso Uruguayo
				'UZS', # Uzbekistan Sum
				'VEB', # Bolivar
				'VND', # Dong
				'VUV', # Vatu
				'WST', # Tala
				'XAF', # CFA Franc BEAC
				'XAG', # Silver
				'XAU', # Gold Bond Markets Units
				'XBA', # European Composite Unit (EURCO)
				'XBB', # European Monetary Unit (E.M.U.-6)
				'XBC', # European Unit of Account 9 (E.U.A.- 9)
				'XBD', # European Unit of Account 17 (E.U.A.- 17)
				'XCD', # East Caribbean Dollar
				'XDR', # SDR
				'XOF', # CFA Franc BCEAO
				'XPD', # Palladium
				'XPF', # CFP Franc
				'XPT', # Platinum
				'XTS', # Codes specifically reserved for testing purposes
				'YER', # Yemeni Rial
				'YUM', # New Dinar
				'ZAL', # (financial Rand)
				'ZAR', # Rand
				'ZMK', # Kwacha
				'ZRN', # New Zaire
				'ZWD', # Zimbabwe Dollar
		];
}


1;