MAKEFLAGS += --no-builtin-rules --warn-undefined-variables --no-print-directory
include Makefile.common

# Contracts
I:=Hold
PRIME:=$I

INIT:=$(PRIME)
KEY:=~
RKEYS:=$(KEY)/k1.keys
VAL0:=15

ENTRIES:=
#DIRS:=

PHONY += all dirs cc tty tt deploy clean
all: cc

dirs:
	mkdir -p $(DIRS)
#	echo / > $(PROC)/cwd

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
#$(BLD)/$I.tvc: boot/$(SRC)/$I.sol
#	$(SOLC) $< -o $(BLD)
#	$(LINKER) compile --lib $(LIB) $(BLD)/$I.code -o $@
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

$(BLD)/%.abi.json: $(SRC)/%.sol
	$(SOLC) $< --tvm-abi -o $(BLD)

tty tt: ts bocs
	./$<
.PHONY: $(PHONY)

V?=
#$(V).SILENT:
#.PHONY: no_targets__ list

.PHONY: list cc
#.PRECIOUS: $(BLD)/*.tvc
list:
	LC_ALL=C $(MAKE) -pRrq -f Makefile : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
