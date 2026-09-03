# Compilation des exemples du template — harnais de non-régression.
#
#   make            compile les quatre exemples, puis vérifie les journaux
#   make poly       n'en compile qu'un
#   make check      revérifie les journaux sans recompiler
#   make clean      efface les auxiliaires (garde les PDF)
#   make mrproper   efface tout, PDF compris
#
# `make` est VERT si les seules erreurs rencontrées sont celles listées dans
# KNOWN, c'est-à-dire des défauts connus de la v0, documentés dans
# ../../template-refonte/02-diagnostic.md. Toute erreur nouvelle rend le
# harnais ROUGE. Les entrées de KNOWN doivent disparaître à l'étape 2.

EXAMPLES := poly slides td exam

# -f : on va jusqu'au bout malgré les défauts connus ; c'est `check` qui juge.
LATEXMK  := latexmk -pdf -f -interaction=nonstopmode -file-line-error \
            -emulate-aux-dir -auxdir=build

# Défauts v0 tolérés, un motif grep -E par ligne.
KNOWN := Extra \\fi

.PHONY: all check clean mrproper $(EXAMPLES)

all: $(EXAMPLES) check

$(EXAMPLES):
	@echo "==> $@"
	@cd $@ && $(LATEXMK) main.tex >/dev/null 2>&1 || true
	@test -f $@/main.pdf || { echo "ÉCHEC : $@/main.pdf non produit"; exit 1; }

check:
	@status=0; \
	for d in $(EXAMPLES); do \
	  log=$$d/build/main.log; \
	  [ -f "$$log" ] || { echo "  $$d : pas de journal"; status=1; continue; }; \
	  new=$$(grep -E '^\./|^!' "$$log" | grep -vE '$(KNOWN)' || true); \
	  known=$$(grep -cE '$(KNOWN)' "$$log" || true); \
	  if [ -n "$$new" ]; then \
	    echo "  $$d : ERREUR NOUVELLE"; echo "$$new" | sed 's/^/      /'; status=1; \
	  elif [ "$$known" -gt 0 ]; then \
	    echo "  $$d : ok (défaut v0 connu : Extra \\fi — cf. D11)"; \
	  else \
	    echo "  $$d : ok"; \
	  fi; \
	done; \
	[ $$status -eq 0 ] && echo "==> harnais VERT" || { echo "==> harnais ROUGE"; exit 1; }

clean:
	@for d in $(EXAMPLES); do (cd $$d && latexmk -c -auxdir=build main.tex >/dev/null 2>&1); done
	@rm -rf $(addsuffix /build,$(EXAMPLES))

mrproper:
	@for d in $(EXAMPLES); do (cd $$d && latexmk -C -auxdir=build main.tex >/dev/null 2>&1); done
	@rm -rf $(addsuffix /build,$(EXAMPLES))
