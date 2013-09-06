Name: hspc-plugin-pp-bt-dummy
Summary: Parallels Business Automation - Standard Bank Transfer Processing: Dummy bank transfer
Source: %{name}.tar.bz2
Version:	%{version}
Release:	%{release}
Group:	Plug-Ins/Bank Transfer
AutoReqProv: no
License: Commercial
Vendor: Parallels
BuildRoot: %{_tmppath}/%{name}-%{version}-root
Obsoletes: hspc-pp-plugin-dummy
Requires: hspc-release

%description
Parallels Business Automation - Standard Bank Transfer: Dummy bank transfer

%prep
%setup -q -n %{name}

%build
make PREFIX=$RPM_BUILD_ROOT

%install
rm -rf $RPM_BUILD_ROOT
make PREFIX=$RPM_BUILD_ROOT install
/usr/lib/rpm/brp-compress
find $RPM_BUILD_ROOT -type f -print | sed "s@^$RPM_BUILD_ROOT@@g" | grep -v perllocal.pod | grep -v ".packlist" | grep -v "/CVS" > %{name}-%{version}-filelist

%clean
rm -rf $RPM_BUILD_ROOT

%post
/usr/sbin/hspc-upgrade-manager --register pp/plugin-pp-bt-dummy

%preun
if [ $1 = 0 ]; then
	/usr/sbin/hspc-upgrade-manager --clean plugin-pp-bt-dummy
fi

%files -f %{name}-%{version}-filelist
%defattr(-, apache, apache)
%attr(-, root, root)   %{_datadir}/hspc-upgrade/upgrade/plugin-pp-bt-dummy

%changelog
* Wed May 22 2002 olsh@sw.ru	2.0.2-1
- Initial release
