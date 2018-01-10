%
% Interface (GUI) pour la gestion des échelle de temps
%
% Désormais, il y a place à amélioration dans la séparation des tâches...
% une classe de gestion du GUI pourrait voir le jour...
% peut-être un autre tantôt!
%
function GUITpchnl()
  try
    hA =CAnalyse.getInstance();
    Ofich =hA.findcurfich();
    tpchnl =Ofich.Tpchnl;
    Ofich.Vg.valeur =1;
    dep =tpchnl.FaireListEchel();
    if tpchnl.nbech
      lenom =tpchnl.Dato{1}.nom;
      lecanal =tpchnl.Dato{1}.canal;
      lepoint =tpchnl.Dato{1}.point;
      [listpt,lenb] =tpchnl.getpoint(lecanal);
      if lenb == 0
        lepoint =1;
      elseif lepoint > lenb
        lepoint =lenb;
      end
    else
      lepoint =1;
      lecanal =1;
      lenom =[''];
      [listpt,lenb] =tpchnl.getpoint(lecanal);
    end
    flarg =280; fhaut =450;
    flarg2 =flarg+150;
    lapos =positionfen('G','H', flarg2, fhaut, gcf);
    Fig =figure('Name', 'AU FIL DU TEMPS', 'Position',lapos, ...
            'CloseRequestFcn',{@quienllama,'FermerEdit'},...
            'DefaultUIControlBackgroundColor',[0.8 0.8 0.8],...
            'DefaultUIControlunits','pixels',...
            'DefaultUIControlFontSize',12, 'Resize', 'off');
    tpchnl.Fig =Fig;
    hauteur =fhaut-50;
    uicontrol('Parent',Fig, 'HorizontalAlignment','Center', 'Style','text', ...
            'Position',[10 hauteur flarg-20 25], 'String','Échelles de temps disponibles:');
    hauteur =hauteur-25;
    uicontrol('Parent',Fig, 'tag','PmnuEchelDispo', 'Position',[25 hauteur flarg-50 25], ...									%
            'String',dep, 'Callback',{@quienllama,'QuelEchel'}, 'Style','popupmenu', 'Value',1);
    hauteur =hauteur-45;
    uicontrol('Parent',Fig, 'HorizontalAlignment','Center', 'Style','text',...
            'Position',[10 hauteur flarg-20 25], 'String','Nom pour cette échelle de temps');
    hauteur =hauteur-25;
    uicontrol('Parent',Fig, 'tag','NomEchel', 'HorizontalAlignment','Left', 'String', lenom, ...
            'BackgroundColor',[1 1 1], 'Style', 'edit', 'Position', [25 hauteur flarg-50 25]);
    hauteur =hauteur-45;
    uicontrol('Parent',Fig, 'HorizontalAlignment','Center', 'Style','text',...
            'Position',[25 hauteur flarg-50 25], 'String','Canal et point de référence:');	
    hauteur =hauteur-200;
    uicontrol('Parent',Fig, 'tag','ETleCanal', 'BackgroundColor',[1 1 1], ...
            'Position',[25 hauteur flarg-95 200], 'String',Ofich.Hdchnl.Listadname, ...
            'Callback',{@quienllama,'ChangeCanal'}, 'Max',1, 'Style','listbox', 'Value',lecanal);
    uicontrol('Parent',Fig, 'tag','ETlePoint', 'BackgroundColor',[1 1 1], ...
            'Position',[flarg-70 hauteur 45 200], 'String',listpt, 'Max',1,...
            'Style','listbox','Value',lepoint);
    hauteur =floor(fhaut*0.7);
    xpos =flarg2-130;
    uicontrol('Parent',Fig, 'Callback',{@quienllama,'Ajouter'}, 'Position',[xpos hauteur 100 25], 'String','Ajouter');
    hauteur =hauteur-50;
    uicontrol('Parent',Fig, 'Callback',{@quienllama,'Modifier'}, 'Position',[xpos hauteur 100 25], 'String','Modifier');
    hauteur =hauteur-50;
    uicontrol('Parent',Fig, 'Callback',{@quienllama,'Supprimer'}, 'Position',[xpos hauteur 100 25], 'String','Supprimer');
    setappdata(Fig,'Ppa',tpchnl);
    set(Fig,'WindowStyle','modal');

  catch sss;
    disp(sss.message)
    for U=1:length(sss.stack)
      disp(sss.stack(U))
    end
    set(Fig,'WindowStyle','normal');
  end

end

%-----------------------------------------
% Callback des différents uicontrol du GUI
% on call la method "Ppa.(autre)"
% et on passe le param "src"
%-----------------------------------------
function quienllama(src,evt, autre)
  Ppa =getappdata(gcf,'Ppa');
  Ppa.(autre)(src);
end
