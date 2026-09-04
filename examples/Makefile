# Compilation des exemples du template — harnais de non-régression.
#
#   make            compile les quatre exemples, puis vérifie les journaux
#   make poly       n'en compile qu'un
#   make check      revérifie les journaux sans recompiler
#   make clean      efface les auxiliaires (garde les PDF)
#   make mrproper   efface tout, PDF compris
#
# `make` est VERT si aucune erreur n'est rencontrée. La liste KNOWN sert à
# tolérer un défaut connu et documenté le temps qu'il soit corrigé ; elle est
# vide depuis que l'étape 2 a remplacé le chargement de paquets de la v0.
#
# grep -a, pas grep : sous locale C (LANG vide), grep decide qu'un .log
# contenant de l'UTF-8 (accents francais dans le texte source cite par les
# messages d'erreur) est binaire et ne renvoie RIEN — ni erreur, ni "0",
# juste silence. Le harnais annoncerait alors VERT sur un document qui ne
# compile pas. Piege decouvert en verifiant poly/ a la main, cf. 04-journal.md.

EXAMPLES := poly slides td exam

# Variantes d'options : meme corps, options differentes. Elles prouvent que
# lang=, theme= et solutions= agissent sans toucher au contenu.
VARIANTS := fr-none fr-inline en-end bw-end compat theme-n7 theme-v2

# Le template est trouvé par TEXINPUTS : les documents n'ont plus de chemin
# relatif à tenir à jour, contrairement au \relativePath de la v0 (défaut D12).
TEMPLATE := $(abspath ..)
export TEXINPUTS := $(TEMPLATE)/tex//:$(TEMPLATE)/assets//:$(TEXINPUTS)

LATEXMK := latexmk -pdf -f -interaction=nonstopmode -file-line-error \
           -emulate-aux-dir -auxdir=build

# Défauts tolérés, un motif grep -E par ligne. Vide = aucune tolérance.
KNOWN :=

.PHONY: all check variants clean mrproper $(EXAMPLES)

all: $(EXAMPLES) variants check

$(EXAMPLES):
	@echo "==> $@"
	@cd $@ && $(LATEXMK) main.tex >/dev/null 2>&1 || true
	@test -f $@/main.pdf || { echo "ÉCHEC : $@/main.pdf non produit"; exit 1; }

variants:
	@echo "==> variants"
	@cd variants && for v in $(VARIANTS); do \
	  $(LATEXMK) -jobname=$$v $$v.tex >/dev/null 2>&1 || true; \
	done

check:
	@status=0; \
	for v in $(VARIANTS); do \
	  log=variants/build/$$v.log; \
	  [ -f "$$log" ] || { echo "  variants/$$v : pas de journal"; status=1; continue; }; \
	  errs=$$(grep -aE '^\./|^!' "$$log" || true); \
	  if [ -n "$$errs" ]; then \
	    echo "  variants/$$v : ERREUR"; echo "$$errs" | sed 's/^/      /'; status=1; \
	  else \
	    echo "  variants/$$v : ok ($$(sed -n 's/.*Output written on.*(\([0-9]*\) pages\{0,1\}.*/\1 p./p' "$$log" | tail -1))"; \
	  fi; \
	done; \
	for d in $(EXAMPLES); do \
	  log=$$d/build/main.log; \
	  [ -f "$$log" ] || { echo "  $$d : pas de journal"; status=1; continue; }; \
	  errs=$$(grep -aE '^\./|^!' "$$log" $(if $(KNOWN),| grep -vE '$(KNOWN)') || true); \
	  if [ -n "$$errs" ]; then \
	    echo "  $$d : ERREUR"; echo "$$errs" | sed 's/^/      /'; status=1; \
	  else \
	    echo "  $$d : ok ($$(sed -n 's/.*Output written on.*(\([0-9]*\) pages\{0,1\}.*/\1 p./p' "$$log" | tail -1))"; \
	  fi; \
	done; \
	[ $$status -eq 0 ] && echo "==> harnais VERT" || { echo "==> harnais ROUGE"; exit 1; }

clean:
	@for d in $(EXAMPLES); do (cd $$d && latexmk -c -auxdir=build main.tex >/dev/null 2>&1); done
	@rm -rf $(addsuffix /build,$(EXAMPLES)) variants/build

mrproper:
	@for d in $(EXAMPLES); do (cd $$d && latexmk -C -auxdir=build main.tex >/dev/null 2>&1); done
	@rm -rf $(addsuffix /build,$(EXAMPLES)) variants/build
	@rm -f $(addprefix variants/,$(addsuffix .pdf,$(VARIANTS)))
