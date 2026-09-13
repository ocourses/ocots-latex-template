# Compilation des exemples du template — harnais de non-régression.
#
#   make                     compile tout : 16 supports, 12+6 variantes, verification
#   make themes              les 16 supports (4 themes x 4 supports)
#   make themes/legacy/poly  un seul document
#   make theme-variants      les 12 variantes de facette (une par theme x fonts/boxform/titles)
#   make variants            les 6 variantes independantes du theme (lang=, solutions=, compat...)
#   make check               revérifie les journaux sans recompiler
#   make clean               efface les auxiliaires (garde les PDF)
#   make mrproper             efface tout, PDF compris
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
#
# `check` relit aussi themes/ocots/poly.pdf avec check-numbering.sh : le
# chantier 1 promet qu'un numero ne designe qu'un seul objet (compteur
# partage), une propriete que « pas d'erreur LaTeX » ne peut pas verifier —
# elle echoue en silence. Necessite pdftotext ; sans lui cette verification
# est ignoree, pas bloquante. Fait une seule fois (pas pour les 4 themes) :
# c'est une invariante du noyau/compteurs, independante du theme — un theme
# ne repeint que des couleurs et des formes de boite, jamais les compteurs.
# L'etendre a $(THEMES) est un changement d'une ligne (boucle sur $(THEMES)
# dans la cible check) si on veut plus de redondance.

THEMES   := ocots legacy charter slate
SUPPORTS := poly slides td exam

# Variantes de facette, par theme : fonts (setfont=/calfont=), boxform-<alt>
# (une forme qui n'est pas celle du theme), titles-<alt> (idem pour le dessin
# des titres). L'alt differe par theme — voir doc/themes.md.
THEME_VARIANTS := ocots/fonts ocots/boxform-sidebar ocots/titles-bignum \
                   legacy/fonts legacy/boxform-shaded legacy/titles-plain \
                   charter/fonts charter/boxform-bracket charter/titles-rules \
                   slate/fonts slate/boxform-framed slate/titles-bignum

# Variantes independantes du theme : meme corps, options lang=/solutions=/
# compat/hooks differentes. Toutes utilisent le theme par defaut (`ocots`).
VARIANTS := fr-none fr-inline en-end compat header-article slides-hook

# Le template est trouvé par TEXINPUTS : les documents n'ont plus de chemin
# relatif à tenir à jour, contrairement au \relativePath de la v0 (défaut D12).
TEMPLATE := $(abspath ..)
export TEXINPUTS := $(TEMPLATE)/tex//:$(TEMPLATE)/assets//:$(TEXINPUTS)

LATEXMK := latexmk -pdf -f -interaction=nonstopmode -file-line-error \
           -emulate-aux-dir -auxdir=build

# Défauts tolérés, un motif grep -E par ligne. Vide = aucune tolérance.
# Le thème charter (newtxmath[charter], famille symbolsC désactivée pour tenir
# dans la limite des 16 familles mathématiques de TeX sous beamer) déclenche
# un \newcommand* \nplus déjà défini par stmaryrd : newtxmath tente un
# repli sur \centernot\plus, mais stmaryrd l'a déjà posé. « Your command was
# ignored » : \nplus garde la définition de stmaryrd, sans effet visible, et
# c'est le seul symbole des ~20 replis de newtxmath à entrer en collision.
KNOWN := newtxmath\.sty:[0-9]+:

# Ce qui compte comme une erreur dans un .log. Avec -file-line-error, une erreur
# est « <fichier>:<ligne>: <message> » — le fichier peut être ./x, ../../content/x,
# un chemin absolu ou nu. L'ancien motif « ^\./ » ratait les erreurs venues
# d'un \input de ../../content/ (piège découvert en portant les tableaux).
ERRPAT := ^[^ ]*:[0-9]+: |^! |^Emergency|^Fatal|Undefined control sequence

THEME_SUPPORT_TARGETS := $(foreach t,$(THEMES),$(foreach s,$(SUPPORTS),themes/$t/$s))

.PHONY: all themes theme-variants variants check clean mrproper $(THEME_SUPPORT_TARGETS)

all: themes theme-variants variants check

# --- Quatre supports x quatre themes -------------------------------------
themes: $(THEME_SUPPORT_TARGETS)

# Cible ergonomique : make themes/legacy/poly
$(THEME_SUPPORT_TARGETS):
	@t=$(word 2,$(subst /, ,$@)); s=$(word 3,$(subst /, ,$@)); \
	echo "==> themes/$$t/$$s"; \
	(cd themes/$$t && $(LATEXMK) $$s.tex >/dev/null 2>&1 || true); \
	(cd themes/$$t && $(LATEXMK) $$s.tex >/dev/null 2>&1 || true); \
	test -f themes/$$t/$$s.pdf || { echo "ÉCHEC : themes/$$t/$$s.pdf non produit"; exit 1; }

# --- Variantes par theme (fonts / boxform-* / titles-*) -------------------
theme-variants:
	@for tv in $(THEME_VARIANTS); do \
	  t=$${tv%/*}; v=$${tv#*/}; \
	  echo "==> themes/$$t/variants/$$v"; \
	  (cd themes/$$t/variants && $(LATEXMK) $$v.tex >/dev/null 2>&1 || true); \
	  (cd themes/$$t/variants && $(LATEXMK) $$v.tex >/dev/null 2>&1 || true); \
	done

# --- Variantes theme-agnostiques (lang=/solutions=/compat/hooks) ---------
variants:
	@echo "==> variants"
	@cd variants && for v in $(VARIANTS); do \
	  $(LATEXMK) -jobname=$$v $$v.tex >/dev/null 2>&1 || true; \
	  $(LATEXMK) -jobname=$$v $$v.tex >/dev/null 2>&1 || true; \
	done

check:
	@status=0; \
	for t in $(THEMES); do \
	  for s in $(SUPPORTS); do \
	    log=themes/$$t/build/$$s.log; \
	    [ -f "$$log" ] || { echo "  themes/$$t/$$s : pas de journal"; status=1; continue; }; \
	    errs=$$(grep -aE '$(ERRPAT)' "$$log" $(if $(KNOWN),| grep -vE '$(KNOWN)') || true); \
	    if [ -n "$$errs" ]; then \
	      echo "  themes/$$t/$$s : ERREUR"; echo "$$errs" | sed 's/^/      /'; status=1; \
	    else \
	      echo "  themes/$$t/$$s : ok ($$(sed -n 's/.*Output written on.*(\([0-9]*\) pages\{0,1\}.*/\1 p./p' "$$log" | tail -1))"; \
	    fi; \
	  done; \
	done; \
	for tv in $(THEME_VARIANTS); do \
	  t=$${tv%/*}; v=$${tv#*/}; \
	  log=themes/$$t/variants/build/$$v.log; \
	  [ -f "$$log" ] || { echo "  themes/$$t/variants/$$v : pas de journal"; status=1; continue; }; \
	  errs=$$(grep -aE '$(ERRPAT)' "$$log" $(if $(KNOWN),| grep -vE '$(KNOWN)') || true); \
	  if [ -n "$$errs" ]; then \
	    echo "  themes/$$t/variants/$$v : ERREUR"; echo "$$errs" | sed 's/^/      /'; status=1; \
	  else \
	    echo "  themes/$$t/variants/$$v : ok"; \
	  fi; \
	done; \
	for v in $(VARIANTS); do \
	  log=variants/build/$$v.log; \
	  [ -f "$$log" ] || { echo "  variants/$$v : pas de journal"; status=1; continue; }; \
	  errs=$$(grep -aE '$(ERRPAT)' "$$log" $(if $(KNOWN),| grep -vE '$(KNOWN)') || true); \
	  if [ -n "$$errs" ]; then \
	    echo "  variants/$$v : ERREUR"; echo "$$errs" | sed 's/^/      /'; status=1; \
	  else \
	    echo "  variants/$$v : ok"; \
	  fi; \
	done; \
	if [ -f themes/ocots/poly.pdf ]; then \
	  dups=$$(./check-numbering.sh themes/ocots/poly.pdf 2>&1) || { \
	    echo "  themes/ocots/poly : DOUBLON DE NUMEROTATION (chantier 1)"; echo "$$dups" | sed 's/^/      /'; status=1; }; \
	fi; \
	[ $$status -eq 0 ] && echo "==> harnais VERT" || { echo "==> harnais ROUGE"; exit 1; }

clean:
	@for t in $(THEMES); do \
	  (cd themes/$$t && latexmk -c -auxdir=build $(addsuffix .tex,$(SUPPORTS)) >/dev/null 2>&1); \
	  (cd themes/$$t/variants && latexmk -c -auxdir=build *.tex >/dev/null 2>&1); \
	done
	@rm -rf $(foreach t,$(THEMES),themes/$t/build themes/$t/variants/build) variants/build

mrproper: clean
	@rm -f $(foreach t,$(THEMES),$(addprefix themes/$t/,$(addsuffix .pdf,$(SUPPORTS))))
	@for tv in $(THEME_VARIANTS); do rm -f themes/$${tv%/*}/variants/$${tv#*/}.pdf; done
	@rm -f $(addprefix variants/,$(addsuffix .pdf,$(VARIANTS)))
