%
% On fait la moyenne autour des points marqu�s puis on �cris
% le r�sultat dans un fichier texte
%
function moyAutourPt(varargin)
  if nargin == 0                % condition sur les arguments de la fonction
    commande ='ouverture';
  else
    commande =varargin{1};
  end
  OA =CAnalyse.getInstance();
  Ofich =OA.findcurfich();
  hdchnl =Ofich.Hdchnl;
  vg =Ofich.Vg;
  %---------------
  switch(commande)

  %---------------
  case 'ouverture'

    % cr�ation de la figure
    if vg.nad>2;letop =vg.nad;else letop =vg.nad + 1;end
    if vg.ess>2;lemax =vg.ess;else lemax =vg.ess + 1;end
    separa =strcat('virgule','|','point virgule','|','Tab');
    Lfen=450; Hfen=450;
    lapos =positionfen('G', 'H', Lfen, Hfen);
    fig =figure('Name', 'MENU MOYENNE AUTOUR...', ...
            'Position',lapos, 'CloseRequestFcn','moyAutourPt(''fermer'')',...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'DefaultUIControlunits','pixels',...
            'DefaultUIControlFontSize',10,...
            'Resize', 'off');

    % titre pour le choix des canaux
    mx=25; mxtext=mx; posx=mxtext; large=round((Lfen-2*mxtext)/2); largstd=125; ddy=10; dy=2*ddy; posy=Hfen-45; Htext=22; haut=Htext;
    uicontrol('Parent',fig, ...
            'FontWeight','bold',...
            'Position',[posx posy large haut], ...
            'String','Choix du/des canal/aux', ...
            'Style','text');

    % titre pour le choix des essais
    uicontrol('Parent',fig, ...
            'FontWeight','bold',...
            'Position',[posx+large posy large haut], ...
            'String','Choix du/des essais:', ...
            'Style','text');

    % listbox pour le choix des canaux
    haut=100; posy=posy-haut;
    uicontrol('Parent',fig, 'Tag','LBchoixCan', ...
            'BackgroundColor',[1 1 1], ...
            'Position',[posx posy large haut], ...
            'String',hdchnl.Listadname, ...
            'Min',1, 'Max',letop,...
            'Style','listbox', ...
            'Value',1);

    % listbox pour le choix des essais
    uicontrol('Parent',fig, 'Tag','LBchoixEss', ...
            'BackgroundColor',[1 1 1], ...
            'Position',[posx+large posy large haut], ...
            'String',vg.lesess, ...
            'Min',1, 'Max',lemax,...
            'Style','listbox', ...
            'Value',1);

    % checkbox pour le choix des essais
    haut=Htext; posy=posy-haut;
    uicontrol('Parent',fig, 'Tag','CBchoixEss', ...
            'Position',[posx+large posy large haut], ...
            'String','tous les essais', 'Style','checkbox', ...
            'Value',0, 'Callback','moyAutourPt(''tous'')');

    % titre "s�parateurs"
    large=largstd; posy =posy-haut-dy;
    uicontrol('Parent',fig, 'FontWeight','bold',...
            'Position',[posx posy large haut], ...
            'String','S�parateur:', 'Style','text');

    % popupmenu pour le choix du "s�parateur"
    uicontrol('Parent',fig, 'Tag','PMchoixSep', 'FontSize',11, ...
            'Position',[posx posy-haut large haut], ...
            'String',separa, 'Style','popupmenu', 'Value',1);

    % titre fen�tre de travail
    large=largstd+2*mx; posx=posx+large;
    uicontrol('Parent',fig, 'FontWeight','bold',...
            'Position',[posx posy large haut], ...
            'String','Fen�tre de travail', 'Style','text');

    % fen�tre de travail (d�but)
    posx=posx+round(large/2); large=round(large/3); posx=posx-large; posy=posy-haut;
    quoi=sprintf('Valeur num�rique --> Amplitude\n\np0 ou pi --> premier �chantillon\npf --> dernier �chantillon\np1 p2 p... --> point marqu�');
    uicontrol('Parent',fig, 'Tag','EDfenTravDebut', 'FontSize',11,...
            'Position',[posx posy large haut], 'String','p0', 'Style','edit', ...
            'TooltipString',quoi);

    % fen�tre de travail (fin)
    uicontrol('Parent',fig, 'Tag','EDfenTravFin', 'FontSize',11,...
            'Position',[posx+large posy large haut], 'String','pf', 'Style','edit', ...
            'TooltipString',quoi);

    % checkbox pour le choix "Autour des points"
    posy=posy-haut-dy-ddy; posx=mx; large=largstd;
    uicontrol('Parent',fig, 'Tag','CBchoixAutour', 'Style','checkbox', ...
            'Position',[posx posy large haut], 'String','Autour des points', ...
            'Value',0, 'Callback','moyAutourPt(''MoyenneAutour'')');

    % nombre d'�chantillon ou de secondes � garder avant et apr�s
    quoi=sprintf('Valeur num�rique pour indiquer l''�tendue avant et\napr�s le point � consid�rer pour faire la moyenne');
    posx=mx+large+2*mx; large=large-50;
    uicontrol('Parent',fig, 'Tag','EDnombreAvantApres', 'FontSize',11,...
            'Position',[posx posy large haut], 'String','10', 'Style','edit', ...
            'TooltipString',quoi, 'Visible','off');

    % type d'unit�, �chantillon ou seconde
    posx =posx+large; large=large+50;
    uicontrol('Parent',fig, 'Tag','PMchoixUnit', 'FontSize',11, ...
            'Position',[posx posy large haut], 'Style','popupmenu', ...
            'String',{'�chantillons','secondes'}, 'Value',1, 'Visible','off');

    % bouton au travail
    large=85; posx=round((Lfen-large)/2); haut=Htext; posy=posy-haut-2*dy;
    uicontrol('Parent',fig, 'Callback','moyAutourPt(''travail'')', ...
            'Position',[posx posy large haut], 'String','Au travail');

    % info sommaire au bas de la fen�tre
    posy=posy-haut-dy;
    uicontrol('Parent',fig, 'FontWeight','bold', 'Position',[0 posy Lfen haut], 'Style','text', ...
            'String','-------------------------------------------------------------------------------------');
    posx=mx; large=Lfen-2*posx; haut=2*Htext; posy=posy-haut-5;
    uicontrol('Parent',fig, 'FontSize',9, 'Position',[posx posy large haut], 'Style','text', ...
            'String','Par d�faut, si on ne coche pas "Autour des points", la moyenne se fera sur les valeurs entre les deux bornes de la fen�tre de travail /si on la coche/ on fera les moyennes autour des points marqu�s.');

    set(fig,'WindowStyle','modal');

  case 'tous'
    %--------------------------------------------------
    % S�lection de tous les essais.
    % - on change la propri�t� value du listbox
    % - on reset la checkbox (elle a un r�le de bouton)
    %--------------------------------------------------
    listess =get(findobj('Tag','LBchoixEss'), 'String');
    set(findobj('Tag','LBchoixEss'), 'Value',[1:length(listess)]);
    set(findobj('Tag','CBchoixEss'), 'Value',0);

  case 'MoyenneAutour'
    %-----------------------------------------
    % ici on toggle les cases pour les infos
    % sur le nombres de points avant ou apr�s
    %-----------------------------------------
    foo =CEOnOff(get(findobj('Tag','CBchoixAutour'), 'Value'));
    set(findobj('Tag','EDnombreAvantApres'), 'Visible',char(foo));
    set(findobj('Tag','PMchoixUnit'), 'Visible',char(foo));

  %--------------
  case 'travail'
    % On ouvre une waitbar "modal" pour montrer o� on est rendu et en plus on
    % barre l'acc�s au GUI pour ne pas le modifier pendant le traitement.
    h1 =laWaitbarModal(0,'Moyennage en cours', 'G', 'C');

    % fichier pour l'�criture des moyennes
    try
      [nomfich,lieu] =uiputfile('*.*','R�sultat des Moyennes');
      pcourant =pwd;
      cd(lieu);
    catch
      disp('Erreur dans le fichier de sortie.');
      delete(h1);
      return;
    end

    % Lecture des param�tres du GUI
    P =lireLeGUI();

    % ouverture du fichier en �criture
    P.fid =fopen(nomfich,'w');

    % appel de la fonction qui va faire le vrai travail
    P.wb =h1;
    
    
    % Ligne d'ent�te g�n�rale
    contenu =['Fichier d''origine: ' Ofich.Info.finame saut];
    fprintf(P.fid, '%s', contenu);

    % Ligne de titre des canaux � exporter
    valcan ='No �chantillon';
    frequence ='Fr�quence';
    for m =1:nombre
      Dt{m} =CDtchnl();
      Ofich.getcaness(Dt{m}, essai, canaux(m));
      valcan =[valcan tab deblank(hdchnl.adname{canaux(m)})];
      frequence =[frequence tab num2str(hdchnl.rate(canaux(m),essai(1))) ' Hz'];
    end
    valcan =[valcan saut];
    frequence =[frequence saut];
    nbdonmax =max(hdchnl.nsmpls(canaux,1));
    for ij =1:nombress
      % Ligne de titre par essai � exporter
      contenu =[saut 'NO ESSAI: ' num2str(essai(ij)) ' (Stimulus: ' vg.nomstim{hdchnl.numstim(essai(ij))} ')' saut];
      fprintf(P.fid, '%s', contenu);
      fprintf(P.fid, '%s', frequence);
      fprintf(P.fid, '%s', valcan);
      for i =1:nbdonmax/pas
        ptrs =((i-1)*pas) + 1;
        contenu =num2str(ptrs);
        for can =1:nombre
          curDt =Dt{can};
          % au cas ou on a diff�rentes fr�quences d'�chantillonage
          if ptrs > hdchnl.nsmpls(canaux(can),essai(ij))
            contenu =[contenu, tab];
          else
            contenu =[contenu, tab, num2str(curDt.Dato.(curDt.Nom)(ptrs, ij))];
          end
        end
        contenu =[contenu saut];
        fprintf(P.fid, '%s', contenu);
        waitbar(i/(nbdonmax/pas));   
      end
    end
    for m =1:nombre
      delete(Dt{m});
    end
    fclose(P.fid);
    close(h1);
    delete(fig);
    cd(pcourant);
  %------------
  case 'fermer'
     delete(gcf);
  %--
  end
end

%---------------------------------------
% Lecture des param�tres du GUI
% on retournera "K", une structure avec
% un champ par �l�ment du GUI
%---------------------------------------
function K =lireLeGUI();
  % lecture du choix des canaux
  K.can =get(findobj('Tag','LBchoixCan'),'Value')';
  K.Ncan =length(K.can);
  % lecture du choix des essais
  K.ess =get(findobj('Tag','LBchoixEss'),'Value')';
  K.Ness =length(K.ess);
  % pr�paration des variables de saut de lignes et s�parateur de champs
  K.saut =[char(13) char(10)];
  sep =get(findobj('Tag','PMchoixSep'),'Value');
  seplist ={','; ';'; char(9)};
  K.sep =seplist{sep};
  % D�but et fin de la fen�tre de travail
  K.debfentrav =get(findobj('Tag','EDfenTravDebut'), 'String');
  K.finfentrav =get(findobj('Tag','EDfenTravFin'), 'String');
  % checkbox pour travailler autour des points
  K.autour =get(findobj('Tag','CBchoixAutour'), 'Value');
  if K.autour
    K.av_ap =str2num(get(findobj('Tag','EDnombreAvantApres'), 'String'));
    K.unit =get(findobj('Tag','PMchoixUnit'), 'Value');
    % si on a choisi "�chantillon" alors le nombre pour
    % Avant/Apr�s doit �tre entier.
    if K.unit == 1
      K.av_ap =round(K.av_ap);
    end
  end
end

%
% 
%
function aFaire(K)
  % Pour �crire dans le fichier, on va faire toutes les moyennes, puis,
  % on va proc�der dans un ordre �tabli.
end
