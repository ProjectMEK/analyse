%
% Laboratoire GRAME
% MEK, avril 2000, et ça continue...
%
% On travaille maintenant avec une Classe Enum: CEFich
%
% MNOUVRE est la première fonction appelée lors de l'ouverture de tout
% type de fichier.
%
% entrada est un objet de la classe --> CEFich   (une énumération)
% frecent -->  la valeur du sous-menu des fichiers ouverts récemment
%              0 si on a pas cliqué dans ces sous-menu
%
function mnouvre(entrada, frecent)
  try
    % on récupère le handle de l'intance de l'application
    OA =CAnalyse.getInstance();
    % le fichier courant deviendra le dernier ouvert
    lastfich =OA.Fic.curfich;
    %-----------------------------------------------------------------------------
    % lappel est une fonction "générique" fabriqué à partir du suffixe "CLir"
    % et de la valeur texte du type de fichier que l'on retrouve dans la classe
    % ENUMERATION: CEFich
    %-----------------------------------------------------------------------------
    lappel =str2func(['CLir' char(entrada)]);
    FICHANALYSE =CEFich('analyse');
    %-----------------------------------------------------------------------------
    % On se fabrique un fichier "Analyse" vide qui sera passé au constructeur
    % du fichier à ouvrir.
    %-----------------------------------------------------------------------------
    hF =CLiranalyse(FICHANALYSE);
  
    if entrada == FICHANALYSE
      % On ouvre un fichier au format "Analyse"
      if frecent
      % on l'a choisi à partir du menu "Fichier récent"
        if isempty(dir(OA.Fic.recent{frecent}))
          % le fichier n'existe plus à cette endroit
          return;
        end
        hF.Vg.valeur =1;
        [hF.Info.prenom,b,c] =fileparts(OA.Fic.recent{frecent});
        hF.Info.finame =[b c];
      else
      % on l'a choisi à partir du menu "Ouvrir"
        hF.Info.prenom =OA.Fic.ddir;
        hF.Vg.valeur =0;
      end
      % on finalise l'ouverture
      mnouvre2(hF, entrada);
  
      if ~isempty(hF)
        if ~isempty(lastfich) && lastfich
          OA.Fic.lastfich =lastfich;
          OA.AuSuivant();
        end
      end
    else
      % On ouvre un fichier au format "Autre"
      hF.Info.prenom =pwd();
      hF.Vg.valeur =1;
      hT =lappel(hF);
    end
  catch moo;
    CQueEsEsteError.dispOct(moo);
    rethrow(moo);
  end
end
  