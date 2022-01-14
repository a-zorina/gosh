MAKEFLAGS += --no-builtin-rules --warn-undefined-variables --no-print-directory
include Makefile.common

# Contracts
I:=Hold
PRIME:=$I

INIT:=$(PRIME)
KEY:=~
RKEYS:=$(KEY)/k1.keys
VAL0:=15

TSBIN:=bin
USH:=usr/share
UBIN:=.
ENTRIES:=gosh help type var
#DIRS:=

PHONY += all dirs cc tty tt deploy clean
all: cc

dirs:
	mkdir -p $(DIRS)

install: dirs cc hosts
	@$(TOC) config --url gql.custler.net

cc: $(patsubst %,$(BLD)/%.cs,$(ENTRIES) $(INIT))
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

$(foreach c,$(INIT),$(eval $(call t-call,$c)))

etc/hosts:
	$($I_r) etc_hosts {} | jq -j '.out' | sed 's/ *$$//' >$@
hosts:
	rm -f etc/hosts
	make etc/hosts

$(BLD)/%.ress: $(BLD)/%.cs
	$(eval args!=jq -R '{name:"$*",c:.}' $<)
	$($I_c) update_model '$(args)' >$@
	rm -f $(TSBIN)/$*.boc
ss: $(patsubst %,$(BLD)/%.ress,$(ENTRIES))
	echo $^

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
#	$($I_c) update_source '$(call _asc,$*,$<)'
	$($I_c) update_source $<

$(BLD)/%.argsc: $(SRC)/%.sol
#	$(file >$@,{"name":"$*","source":"$(file <$<)"})
	jq -Rs '{"name":"$*","source":.}' $< >$@
#	$(eval source!=jq -Rs '. |@sh' $<)
#	$(eval args!=jq '{name:"$*",source:"$(source)"}' $<)
#	$($I_c) update_source '{"name":"$*","source":$(call _sc)}' >$@
#sc: $(patsubst %,$(BLD)/%.resc,$(ENTRIES))
#sc: $(patsubst %,$(BLD)/%.resc,$(ENTRIES))
sc: $(patsubst %,$(BLD)/%.resc,help)
	echo $^

$(BLD)/%.abi.json: $(SRC)/%.sol
	$(SOLC) $< --tvm-abi -o $(BLD)

$(TSBIN)/%.boc: etc/hosts
	$(eval aa!=grep -w $* $< | cut -f 1)
	$(TOC) account $(aa) -b $@

bocs: $(patsubst %,$(TSBIN)/%.boc,$(ENTRIES))
	@true

hb:
	$($I_r) models {} | jq -j '.out'

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
