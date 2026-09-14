# Place le PDF dans poly/ et les fichiers auxiliaires dans poly/build/.
$out_dir = '.';
$aux_dir = 'build';

# Le template est trouvé par TEXINPUTS : plus de \relativePath a tenir a jour
# (cf. template/README.md).
$ENV{'TEXINPUTS'} = '../../../tex//:../../../assets//:' . ($ENV{'TEXINPUTS'} // '');

# Les corriges s'ecrivent desormais a plat dans build/ (mode solutions=end) :
# plus besoin du lien symbolique vers solutions/ qu'exigeait la v0.
