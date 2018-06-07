####### Le format CSV des post est récupéré par requete SPARQL

### charger l'un de ces fichiers :
df <- read.table("data/IVG.csv",sep="\t",header=T, comment.char = "", quote="", stringsAsFactors = F)
df <- read.table("data/Contraception.csv",sep="\t",header=T, comment.char = "", quote="", stringsAsFactors = F)
df <- read.table("DEPRESSION.txt",sep="\t",header=F, comment.char = "", quote="", stringsAsFactors = F)
colnames(df) <- gsub("^X.","",colnames(df))
bool <- df$contentPost == ""
sum(bool) ## postes vides
df <- subset (df, !bool)

### nombre de caractères : 
ncar <- nchar(df$contentPost)
table(ncar)
## je supprime les posts qui n'ont quasiment pas de contenu : 
voir <- subset (df, ncar < 72)
bool <- ncar < 72 
sum(bool)
df <- subset (df, !bool)

##################### Etape1 lemmatisation
########### appeler treetagger en ligne de commande : 
library(koRpus)
## chemin vers TreeTagger pour lemattiser
cheminTT <- "/home/ERIAS/Documents/sebastien/test_java/treetagger"
## ecrire un fichier :
separateur <- "\nAAAAAZZZZZ\n"
df$contentPost <- tolower(df$contentPost)
exemples <- paste(df$contentPost,collapse=separateur)
writeLines(exemples, "exemples.txt")
system.time(
  tagged.text <- treetag("exemples.txt", treetagger="manual",
                         lang="fr", TT.options=list(path=cheminTT, preset="fr-utf8",
                                                    abbrev="french-abbreviations-utf8",tknz.opts="-f"), debug=F)
) ### 2 013 posts en 4,3 minutes pour IVG
#### 9 962 posts en 29 minutes pour Contraception

voir <- tagged.text@TT.res

### ces résultats sont sauvegardés :
# ivg.rdata pour les posts d'IVG
# contraception.rdata pour les posts contraception
## passer maintenant aux méthodes de clustering


