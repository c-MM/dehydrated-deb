TARGET = letsencrypt.sh

SHELL = sh
REMOVE = rm -f
REMOVEDIR = rm -rf
COPY = cp
INSTALL = install
TOUCH = touch
CHMOD = chmod

ETC_DIR=$(DESTDIR)/etc/letsencrypt
VAR_DIR=$(DESTDIR)/var/lib/letsencrypt/
DOC_DIR=$(DESTDIR)/usr/share/doc/letsencrypt

REVISION = v0.2.0

all : update tmp/config.local.sh tmp/config.sh

$(TARGET) :
	@git clone https://github.com/lukas2511/letsencrypt.sh.git

tmp/config.sh :
	@mkdir -p tmp
	@$(COPY) letsencrypt.sh/docs/examples/config.sh.example tmp/config.sh
	@echo "" >> tmp/config.sh
	@echo ". /etc/letsencrypt/config.local.sh" >> tmp/config.sh
	@echo "" >> tmp/config.sh

tmp/config.local.sh :	
ifeq ($(origin CONTACT), undefined)
	@echo "CONTACT is not set"
	@exit 1
endif
ifeq ($(origin SSH_USER), undefined)
	@echo "SSH_USER is not set"
	@exit 1
endif
	@mkdir -p tmp
	@echo '#!/bin/bash' > tmp/config.local.sh
	@echo '' >> tmp/config.local.sh
	@echo 'CONTACT_EMAIL="$(CONTACT)"' >> tmp/config.local.sh
	@echo 'SSH_USER="$(SSH_USER)"' >> tmp/config.local.sh
	@echo 'CA="$(CA_URL)"' >> tmp/config.local.sh
	@echo 'SSH_AUTH_SOCK=""' >> tmp/config.local.sh
	@echo 'SSH_CMD="/usr/bin/ssh -axTi /etc/letsencrypt/ns-update-ssh -o UserKnownHostsFile=/dev/null -o PasswordAuthentication=no -o StrictHostKeyChecking=no"' >> tmp/config.local.sh
	@echo 'PRIVATE_KEY_RENEW="no"' >> tmp/config.local.sh
	@echo 'CHALLENGETYPE="dns-01"' >> tmp/config.local.sh
	@echo 'HOOK="$${BASEDIR}/hook.sh"' >> tmp/config.local.sh
	@echo 'HOOK_CHAIN="yes"' >> tmp/config.local.sh

update : $(TARGET)
	@( cd $(TARGET) ; git fetch; git checkout $(REVISION) )

clean:
	rm -rf tmp/config.local.sh tmp/config.sh
	rmdir tmp || true

install: update
	$(INSTALL) -d $(ETC_DIR)
	$(INSTALL) -t $(ETC_DIR) tmp/config.sh tmp/config.local.sh files/hook.sh files/cron.sh files/install-cert.sh letsencrypt.sh/letsencrypt.sh
	$(CHMOD) a+x $(ETC_DIR)/*.sh
	$(CHMOD) 750 $(ETC_DIR)/config.local.sh
	$(INSTALL) -d $(VAR_DIR)
	$(INSTALL) -d $(DOC_DIR)
	$(INSTALL) -t $(DOC_DIR) letsencrypt.sh/LICENSE letsencrypt.sh/README.md
