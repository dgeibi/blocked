SHELL := /bin/bash
PROXY ?= "PROXY 127.0.0.1:1080"
IPSET_NAME ?= gfwlist
BLOCKED = ./blocked.txt
WHITE = ./white.txt
DNSMASQ_CONF = ./dnsmasq-blocklist.conf
GREATFIRE = ./tmp/gfwfire.txt
GITHUB = ./tmp/github.txt
Threshold = 60
PAC = ./proxy.pac

generate: $(PAC) $(DNSMASQ_CONF)

update: import-from-github import-from-greatfire
	$(MAKE) generate

$(DNSMASQ_CONF): $(BLOCKED) $(WHITE)
	sed -i '/^$$/d' $(BLOCKED)
	echo "#### BLOCKE IPSET DOMAINS" > $(DNSMASQ_CONF)
	cat $(BLOCKED) | while read SingleDomain;\
		do echo "ipset=/$${SingleDomain}/$(IPSET_NAME)" >> $(DNSMASQ_CONF); \
	done
	echo "#### BYPASS IPSET DOMAINS" >> $(DNSMASQ_CONF)
	cat $(WHITE) | while read SingleDomain ;\
		do echo "ipset=/$${SingleDomain}/#" >> $(DNSMASQ_CONF);\
	done

$(PAC): $(BLOCKED) $(WHITE) bricks
	./bricks makpac $(PROXY) $(BLOCKED) $(WHITE)

import-from-greatfire: FORCE
	rm -rf $(GREATFIRE)
	for i in $$(seq 0 10);\
	do \
	curl -s --insecure "https://zh.greatfire.org/search/alexa-top-1000-domains?page=$$i"|  \
		grep 'class="first"' | grep 'class="blocked"' | grep -vE "google"|\
		sed -e "s#^[^\/]*\/\([^\"]*\)[^\%]*\%...\([^\%]*\)\%.*#\1 \2#g"|\
		awk '$$2>='"$(Threshold)"' {print ""$$1"" }'\
		>> $(GREATFIRE);\
	curl -s --insecure "https://zh.greatfire.org/search/domains?page=$$i"|  \
		grep 'class="first"' | grep 'class="blocked"' | grep -vE "google"|\
		grep -vE "facebook"| grep -vE "twitter"|\
		sed -e "s#^[^\/]*\/\([^\"]*\)[^\%]*\%...\([^\%]*\)\%.*#\1 \2#g"|\
		sed -e "s#^https/##g" |\
		awk '$$2>='"$(Threshold)"' {print ""$$1"" }'\
		>> $(GREATFIRE);\
	done
	sed -i '/^url\b/'d $(GREATFIRE)
	./bricks adds $(GREATFIRE) $(BLOCKED)

import-from-github: FORCE
	curl https://raw.githubusercontent.com/wongsyrone/domain-block-list/master/domains.txt > $(GITHUB)
	./bricks adds $(GITHUB) $(BLOCKED)

clean: FORCE
	python find_redundant.py | while read SingleDomain;\
		do if [ -n $${SingleDomain} ];\
		then ./bricks remove $${SingleDomain};\
		fi;done
	rm -rf tmp/*.txt

FORCE:
