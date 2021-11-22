TARGET = dehydrated

SHELL = sh
REMOVE = rm -f
REMOVEDIR = rm -rf
COPY = cp
INSTALL = install
TOUCH = touch
CHMOD = chmod

ETC_DIR=$(DESTDIR)/etc/dehydrated
VAR_DIR=$(DESTDIR)/var/lib/dehydrated/
DOC_DIR=$(DESTDIR)/usr/share/doc/dehydrated

#REVISION = 60832185013aee00914acff29a2d868e2b15507e
REVISION = v0.7.0

all : update tmp/config.local tmp/config

$(TARGET) :
	@git clone https://github.com/lukas2511/dehydrated.git
	@( cd $(TARGET) ; git fetch; git checkout $(REVISION) )

tmp/config :
	@mkdir -p tmp
	@$(COPY) dehydrated/docs/examples/config tmp/config
	@echo "" >> tmp/config
	@echo ". /etc/dehydrated/config.local" >> tmp/config
	@echo "" >> tmp/config

tmp/config.local :	
ifeq ($(origin CONTACT), undefined)
	@echo "CONTACT is not set"
	@exit 1
endif
ifeq ($(origin SSH_USER), undefined)
	@echo "SSH_USER is not set"
	@exit 1
endif
	@mkdir -p tmp
	@echo '#!/bin/bash' > tmp/config.local
	@echo '' >> tmp/config.local
	@echo 'CONTACT_EMAIL="$(CONTACT)"' >> tmp/config.local
	@echo 'SSH_USER="$(SSH_USER)"' >> tmp/config.local
	@echo 'CA="$(CA_URL)"' >> tmp/config.local
	@echo 'SSH_AUTH_SOCK=""' >> tmp/config.local
	@echo 'SSH_CMD="/usr/bin/ssh -axTi /etc/dehydrated/ns-update-ssh -o UserKnownHostsFile=/dev/null -o PasswordAuthentication=no -o StrictHostKeyChecking=no"' >> tmp/config.local
	@echo 'PRIVATE_KEY_RENEW="no"' >> tmp/config.local
	@echo 'CHALLENGETYPE="dns-01"' >> tmp/config.local
	@echo 'HOOK="$${BASEDIR}/hook.sh"' >> tmp/config.local
	@echo 'HOOK_CHAIN="yes"' >> tmp/config.local
	@echo 'PREFERRED_CHAIN="ISRG Root X1"' >> tmp/config.local
ifneq ($(origin CERTDIR), undefined)
	@echo 'CERTDIR="$(CERTDIR)"' >> tmp/config.local
endif
ifneq ($(origin ACCOUNTDIR), undefined)
	@echo 'ACCOUNTDIR="$(ACCOUNTDIR)"' >> tmp/config.local
endif
ifneq ($(origin CHAINCACHE), undefined)
	@echo 'CHAINCACHE="$(CHAINCACHE)"' >> tmp/config.local
endif

update : $(TARGET)
	@( cd $(TARGET) ; git fetch; git checkout $(REVISION) )

clean:
	rm -rf tmp/config.local tmp/config
	rmdir tmp || true

install: update
	$(INSTALL) -d $(ETC_DIR)
	$(INSTALL) -t $(ETC_DIR) tmp/config tmp/config.local files/hook.sh files/cron.sh files/install-cert.sh
	$(INSTALL) -t $(ETC_DIR) dehydrated/dehydrated
	$(CHMOD) a+x $(ETC_DIR)/*.sh
	$(CHMOD) 750 $(ETC_DIR)/config.local
	$(INSTALL) -d $(VAR_DIR)
	$(INSTALL) -d $(DOC_DIR)
	$(INSTALL) -t $(DOC_DIR) dehydrated/LICENSE dehydrated/README.md
