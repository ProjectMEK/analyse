%
% classdef CPreference < CGuiPreference
%
% METHODS
%    tO = CPreference()
%         auTravail(tO, varargin)
%
% Va h�riter de CGuiPreference, qui fait la gestion du GUI
%
classdef CPreference < CGuiPreference

  methods

    %------------
    % CONSTRUCTOR
    %--------------------------
    function tO = CPreference()
      % on b�ti le GUI
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
%                     Gestion des pr�f�rences pour Analyse
%  
%  Il faut distinguer deux actions qui ont un comportement bien diff�rent.
%  - L'Application conserve un objet CPref
%  - Les fichiers ouverts peuvent y r�f�rer sous certaines conditions.
%  
%  PREMI�REMENT
%  ------------
%    _______________________
%    � l'ouverture d'Analyse
%    
%    - Si le fichier "grame.mat" n'existe pas
%      - Analyse h�ritera des valeurs par d�faut de CPref()
%    - Si le fichier "grame.mat" existe
%      - mais ne contient pas de var "Pref"
%        - l'objet CPref() sera forg� � partir des var trouv� dans grame.mat
%      - s'il contient une var "Pref"
%        - Si la propri�t� "conserver" est false
%          - Analyse h�ritera des valeurs par d�faut de CPref()
%        - Si la propri�t� "conserver" est true
%          - l'objet CPref() sera forg� � partir de la var "Pref" du fichier "grame.mat"
%  
%    On a maintenant un objet CPref() avec des propri�t�s qui ne seront pas modifi�s
%    autrement que par l'interface pr�vu pour les changements de pr�f�rences
%  
%  
%  DEUXI�MEMENT
%  ------------
%    __________________________
%    � l'ouverture d'un fichier
%    
%    - Si la propri�t� "conserver" est false
%      - les valeurs par d�faut de l'objet CPref() sont impos�es
%    - Si la propri�t� "conserver" est true
%      - Pour les "propri�t�sFix" qui sont true
%        - On impose la valeur de l'objet CPref pour ces propri�t�s
%      - Alors que pour les "propri�t�sFix" qui sont false
%        - La valeur sauvegard�s dans le fichier a pr�s�ance.
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
%    � l'ouverture d'un fichier, comme la propri�t� "conserver =true", le fichier
%    va h�riter de "legende =true" car "legendeFix =true". Mais si on regarde la
%    propri�t� "zoomonoff", celle du fichier ne sera pas chang� car "zoomonoffFix =false"
%  
