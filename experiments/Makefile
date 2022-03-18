MAKEFLAGS += --no-builtin-rules --warn-undefined-variables --no-print-directory
include Makefile.common

# Contracts
I:=Hold
H:=hive
PRIME:=$I

INIT:=$(PRIME)
KEY:=~
RKEYS:=$(KEY)/k1.keys
VAL0:=15

TSBIN:=bin
USH:=usr/share
UBIN:=.
S0:=sb0
ENTRIES:=gosh help type var hive object
STORES:=$(S0)
#DIRS:=

PHONY += all dirs cc tty tt deploy clean
all: cc

dirs:
	mkdir -p $(DIRS)

install: dirs cc hosts
	@$(TOC) config --url gql.custler.net

cc: $(patsubst %,$(BLD)/%.cs,$(ENTRIES) $(INIT) $(STORES))
	@true

DEPLOYED=$(patsubst %,$(BLD)/%.deployed,$(INIT))

deploy: $(DEPLOYED)
	-cat $^

$(BLD)/%.tvc: $(SRC)/%.sol
	$(SOLC) $< -o $(BLD)
	$(LINKER) compile --lib $(LIB) $(BLD)/$*.code -o $@
$(BLD)/$I.tvc: $(SRC)/$I.sol
	$(SOLC) $< -o $(BLD)
	$(LINKER) compile --lib $(LIB) $(BLD)/$I.code -o $@
$(BLD)/%.cs: $(BLD)/%.tvc
	$(LINKER) decode --tvc $< | grep 'code:' | cut -d ' ' -f 3 | tr -d '\n' >$@

$(BLD)/$I_update_model_%.args: shell/$(BLD)/%.cs
	jq -R '{name:"$*",c:.}' $< >$@
$(BLD)/$I_update_model_%.ress: $(BLD)/$I_update_model_%.args
	$($I_c) update_model $(word 1,$^)

$(BLD)/%.shift: $(BLD)/%.tvc $(BLD)/%.abi.json $(RKEYS)
	$(TOC) genaddr $< $(word 2,$^) --setkey $(word 3,$^) | grep "Raw address:" | sed 's/.* //g' >$@
$(BLD)/%.cargs:
	$(file >$@,{})
$(BLD)/%.deployed: $(BLD)/%.shift $(BLD)/%.tvc $(BLD)/%.abi.json $(RKEYS) $(BLD)/%.cargs
	$(call _pay,$(file < $<),$(VAL0))
	$(TOC) deploy $(word 2,$^) --abi $(word 3,$^) --sign $(word 4,$^) $(word 5,$^) >$@

$(BLD)/%.cs: $(BLD)/%.tvc
	$(LINKER) decode --tvc $< | grep 'code:' | cut -d ' ' -f 3 | tr -d '\n' >$@

repo: $(DEPLOYED)
	$(foreach c,$^,printf "%s %s\n" $c `grep "deployed at address" $^ | cut -d ' ' -f 5`;)

define t-call
$1_a=$$(shell grep -w $1 etc/hosts.boot | cut -f 1)
$$(eval $1_r=$(TOC) -j run $$($1_a) --abi $(BLD)/$1.abi.json)
$$(eval $1_c=$(TOC) call $$($1_a) --abi $(BLD)/$1.abi.json)
endef

$(foreach c,$(INIT) $H,$(eval $(call t-call,$c)))

#$1_a=$$(shell grep -F " $$(subst sb,,$1) " etc/store | cut -f 3 -d ' ')
define s-call
$1_a=$$(shell tail -1 etc/store | cut -f 3 -d ' ')
$$(eval $1_r=$(TOC) -j run $$($1_a) --abi $(BLD)/$1.abi.json)
$$(eval $1_c=$(TOC) call $$($1_a) --abi $(BLD)/$1.abi.json)
endef

$(foreach c,$(STORES),$(eval $(call s-call,$c)))

etc/hosts:
	$($I_r) etc_hosts {} | jq -j '.out' | sed 's/ *$$//' >$@
lmo:
	$($H_r) models {} | jq -j '.out'
etc/lmo:
	$($H_r) models {} | jq -j '.out' >$@
live:
	$($H_r) live_hosts {} | jq -j '.out'
etc/store:
	$($H_r) live_hosts {} | jq -j '.out' >$@
store:
	rm -f etc/store
	make etc/store
hosts:
	rm -f etc/hosts
	make etc/hosts

$(BLD)/%.ress: $(BLD)/%.cs
	$(eval args!=jq -R '{name:"$*",c:.}' $<)
	$($I_c) update_model '$(args)' >$@
	rm -f $(TSBIN)/$*.boc

$(BLD)/%.resh: $(BLD)/%.cs
	$(eval index!=grep -w $* etc/lmo | cut -d ' ' -f 1)
	$(eval args!=jq -R '{index:$(index),name:"$*",c:.}' $<)
	$($H_c) update_model_at_index '$(args)' >$@
	rm -f $(BIN)/$*.boc

ss: $(patsubst %,$(BLD)/%.ress,$(ENTRIES))
	echo $^

sh: $(patsubst %,$(BLD)/%.resh,$(STORES))
	echo $^

name?=
s_add: $(BLD)/$(name).cs
	$(eval args!=jq -R '{index:0,name:"$(name)",c:.}' $<)
	$($I_c) update_model_at_index '$(args)' >$@
h_add: $(BLD)/$(name).cs
	$(eval args!=jq -R '{index:0,name:"$(name)",c:.}' $<)
	$($H_c) update_model_at_index '$(args)' >$@
k?=1
n?=1
h:
	$($H_c) spawn '{"k":$k,"n":$n}'

stb:
	$(eval args!=jq -n '{"b":{"obj":{"parsed":0,"otype":0,"flags":0,"oid":{"hash":"0d0a","algo":1},"short_blob":"bb","store_link":"aa"}}}')
	$($(S0)_c) store_blob '$(args)'

_sha1=$(shell sha1sum $1 | cut -f 1 -d ' ')
sts_%: $(SRC)/%.sol
	$(eval args!=jq -n '{"b":{"obj":{"parsed":0,"otype":0,"flags":0,"oid":{"hash":"$(call _sha1,$<)","algo":1},"short_blob":"$(call _hex2,$<)","store_link":"$<"}}}')
	$($(S0)_c) store_blob '$(args)'

uc: $(BLD)/$I.cs
	$(eval args!=jq -R '{c:.}' $<)
	$($I_c) upgrade_code '$(args)'

$(USH)/%.man: $(TSBIN)/%.boc $(BLD)/%.abi.json
	$(UBIN)/gosh gosh_help_data $*

$(USH)/man_pages: $(patsubst %,$(USH)/%.man,$(ENTRIES))
	jq 'add' $^ >$@

cmp: $(patsubst %,$(USH)/%.man,$(ENTRIES))
	echo $^
	rm -f $(USH)/man_pages
	jq 'add' $^ >$(USH)/man_pages

_sc=$(shell jq -Rs '.' $1)
_asc={"name":"$1","source":$(call _sc,$2)}
$(BLD)/%.resc: $(BLD)/%.argsc
	$($I_c) update_source $<

$(BLD)/%.argsc: $(SRC)/%.sol
	jq -Rs '{"name":"$*","source":.}' $< >$@
sc: $(patsubst %,$(BLD)/%.resc,$(ENTRIES))
#sc: $(patsubst %,$(BLD)/%.resc,help)
	echo $^

$(BLD)/%.abi.json: $(SRC)/%.sol
	$(SOLC) $< --tvm-abi -o $(BLD)

$(TSBIN)/%.boc: etc/hosts
	$(eval aa!=grep -w $* $< | cut -f 1)
	$(TOC) account $(aa) -b $@

bocs: $(patsubst %,$(TSBIN)/%.boc,$(ENTRIES))
	@true

report:
	$($I_r) models {} | jq -j '.out'

sls:
	$($I_r) _images {} | jq -r '._images[] | .name, .source'

tty tt: tx bocs
	./$<
.PHONY: $(PHONY)

V?=
#$(V).SILENT:
#.PHONY: no_targets__ list

.PHONY: list cc
#.PRECIOUS: $(BLD)/*.tvc
list:
	LC_ALL=C $(MAKE) -pRrq -f Makefile : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
