% Fonction kbPress
%
% Gestion de certaines touches du clavier lors du marquage manuel.
% Sert � changer le canal ou l'essai ou la cat�gorie.
%
% La fa�on de fonctionner pour le marquage manuel sera comme suit.
%
% - Premi�rement cliquez le bouton de marquage
%
%   - Si vous voulez changer de canal, cliquez sur la lettre C puis:
%     - Cliquez sur les fl�ches haut ou bas pour changer de canal
%
%   - Si vous voulez changer d'essai, cliquez sur la lettre E puis:
%     - Cliquez sur les fl�ches haut ou bas pour changer d'essai
%
%   - Si vous voulez changer de Niveau/Cat�gorie, cliquez sur la lettre N puis:
%     - Cliquez sur les fl�ches haut ou bas pour changer de Niveau/Cat�gorie
%
%--------------------------
function kbPress(varargin)
  % r�cup�ration du handle de la classe principale d'Analyse
  OA =CAnalyse.getInstance();

  % Si il n'y a pas de fichier ouvert, on arr�te tout de go!
  if OA.Fic.nf == 0
    return;
  end

  % r�cup�ration du handle de la classe qui g�re l'affichage
  Oaff =OA.OFig;

  % r�cup�ration du handle de la classe du fichier courant
  Ofich =OA.findcurfich();

  % r�cup�ration du handle de la classe Variable Global de l'application
  VG =OA.Vg;

  % r�cup�ration du handle de la classe Variable Global du fichier courant
  vg =Ofich.Vg;

  % Lecture de la derni�re cl� press�e au clavier
  laclef =double(get(Oaff.fig,'CurrentCharacter'));

  if isempty(laclef)
    return
  end

  % traitement de la cl� press�e
  switch laclef
  %***********
  case {67,99}        % lettre C, Changer canaux avec fl�ches haut et bas
    VG.nextkey =0;
  %************
  case {69,101}       % lettre E, Changer essai avec fl�ches haut et bas
    VG.nextkey =1;
    if vg.affniv
      vg.affniv =0;
      Oaff.affiche();
    end
  %************
  case {78,110}       % lettre N, Changer niveau-cat�gorie avec fl�ches haut et bas
    if vg.niveau
      VG.nextkey =2;
      if ~vg.affniv
        vg.affniv =1;
        Oaff.affiche();
      end
    end
  %******
  case {30,45}        % fl�ches haut et signe -
    if VG.nextkey == 0
      guiToul('canal_precedent');
    elseif VG.nextkey == 1
      guiToul('essai_precedent');
    elseif VG.nextkey == 2
      lalist =OA.OFig.nivo.getValue();
      letop =length(OA.OFig.nivo.getString());
      if isempty(lalist)
        lalist =2;
      end
      lalist =lalist-1;
      if lalist(1) < 1
        lalist(1) =letop;
        lalist =sort(lalist);
      end
      OA.OFig.nivo.setValue(lalist);
      vg.cat =lalist;
      Oaff.affiche();
    end
  %******
  case {31,43}        % fl�ches bas et signe +
    if VG.nextkey == 0
      guiToul('canal_suivant');
    elseif VG.nextkey == 1
      guiToul('essai_suivant');
    elseif VG.nextkey == 2
      lalist =OA.OFig.nivo.getValue()
      letop =length(OA.OFig.nivo.getString());
      if isempty(lalist)
        lalist =0;
      end
      lalist =lalist+1;
      if lalist(end) > letop
        lalist(end) =1;
        lalist =sort(lalist);
      end
      OA.OFig.nivo.setValue(lalist);
      vg.cat =lalist;
      Oaff.affiche();
    end
  end
end
