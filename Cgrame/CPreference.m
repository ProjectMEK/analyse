%
% classdef CPreference < CGuiPreference
%
% METHODS
%    tO = CPreference()
%         auTravail(tO, varargin)
%
% Va hériter de CGuiPreference, qui fait la gestion du GUI
%
classdef CPreference < CGuiPreference

  methods

    %------------
    % CONSTRUCTOR
    %--------------------------
    function tO = CPreference()
      % on bâti le GUI
      tO.initGui();
    end

    %------------------------------
    % on sauvegarde et ferme le GUI
    %-------------------------------
    function auTravail(tO, varargin)
      auTravail@CGuiPreference(tO);
      OA =CAnalyse.getInstance();
      OA.Fic.pref.maj(tO.getObjData());
      OA.Fic.majFichRecent();
      OA.initLesPreferenciasGlobal();
      tO.terminus();
    end

  end % methods
end % classdef

%_________________________________________________________________________________________
%
%                     Gestion des préférences pour Analyse
%  
%  Il faut distinguer deux actions qui ont un comportement bien différent.
%  - L'Application conserve un objet CPref
%  - Les fichiers ouverts peuvent y référer sous certaines conditions.
%  
%  PREMIÈREMENT
%  ------------
%    _______________________
%    À l'ouverture d'Analyse
%    
%    - Si le fichier "grame.mat" n'existe pas
%      - Analyse héritera des valeurs par défaut de CPref()
%    - Si le fichier "grame.mat" existe
%      - mais ne contient pas de var "Pref"
%        - l'objet CPref() sera forgé à partir des var trouvé dans grame.mat
%      - s'il contient une var "Pref"
%        - Si la propriété "conserver" est false
%          - Analyse héritera des valeurs par défaut de CPref()
%        - Si la propriété "conserver" est true
%          - l'objet CPref() sera forgé à partir de la var "Pref" du fichier "grame.mat"
%  
%    On a maintenant un objet CPref() avec des propriétés qui ne seront pas modifiés
%    autrement que par l'interface prévu pour les changements de préférences
%  
%  
%  DEUXIÈMEMENT
%  ------------
%    __________________________
%    À l'ouverture d'un fichier
%    
%    - Si la propriété "conserver" est false
%      - les valeurs par défaut de l'objet CPref() sont imposées
%    - Si la propriété "conserver" est true
%      - Pour les "propriétésFix" qui sont true
%        - On impose la valeur de l'objet CPref pour ces propriétés
%      - Alors que pour les "propriétésFix" qui sont false
%        - La valeur sauvegardés dans le fichier a préséance.
%  
%  EXEMPLE
%  -------
%  
%    Soit V =CPref()
%    ou   V.conserver =true
%         V.legendeFix =true
%         V.legende =true
%         V.zoomonoffFix =false
%         V.zoomonoff =true
%    
%    À l'ouverture d'un fichier, comme la propriété "conserver =true", le fichier
%    va hériter de "legende =true" car "legendeFix =true". Mais si on regarde la
%    propriété "zoomonoff", celle du fichier ne sera pas changé car "zoomonoffFix =false"
%  
