PREFIX			= /
HSPC_TEMPLATE	= $(PREFIX)/var/opt/hspc-root/template
PLUGIN_PATH	= $(HSPC_TEMPLATE)/HSPC/Plugin/PP/BT_Dummy/
PM_TMPL_PATH = $(HSPC_TEMPLATE)/HSPC/Plugin/PM/BT_Dummy/

PLUGIN_TMPLS	= bt_dummy_edit.tmpl bt_dummy_view.tmpl

PM_TMPLS = pm_add_form.tmpl pm_view_form.tmpl pm_edit_form.tmpl

MKDIR		= mkdir -p

all:

install:
	$(MKDIR) $(PLUGIN_PATH)
	$(MKDIR) $(PM_TMPL_PATH)
	
	@for i in $(PLUGIN_TMPLS); do \
	  install -m 644 $$i $(PLUGIN_PATH); \
	done

	for i in `find . -type f -name help_pp_* | grep -v svn`; do \
		install -Dm644 $$i $(PLUGIN_PATH)/$$i || exit $?; \
	done

	@for i in $(PM_TMPLS); do \
	  install -m 644 $$i $(PM_TMPL_PATH); \
	done

	for i in `find . -type f -name help_pm_* | grep -v svn`; do \
		install -Dm644 $$i $(PM_TMPL_PATH)/$$i || exit $?; \
	done
	
clean:
