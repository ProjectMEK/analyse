% Fonction kbPress
%
% Gestion de certaines touches du clavier lors du marquage manuel.
% Sert à changer le canal ou l'essai ou la catégorie.
%
% La façon de fonctionner pour le marquage manuel sera comme suit.
%
% - Premièrement cliquez le bouton de marquage
%
%   - Si vous voulez changer de canal, cliquez sur la lettre C puis:
%     - Cliquez sur les flèches haut ou bas pour changer de canal
%
%   - Si vous voulez changer d'essai, cliquez sur la lettre E puis:
%     - Cliquez sur les flèches haut ou bas pour changer d'essai
%
%   - Si vous voulez changer de Niveau/Catégorie, cliquez sur la lettre N puis:
%     - Cliquez sur les flèches haut ou bas pour changer de Niveau/Catégorie
%
%--------------------------
function kbPress(varargin)
  % récupération du handle de la classe principale d'Analyse
  OA =CAnalyse.getInstance();

  % Si il n'y a pas de fichier ouvert, on arrête tout de go!
  if OA.Fic.nf == 0
    return;
  end

  % récupération du handle de la classe qui gère l'affichage
  Oaff =OA.OFig;

  % récupération du handle de la classe du fichier courant
  Ofich =OA.findcurfich();

  % récupération du handle de la classe Variable Global de l'application
  VG =OA.Vg;

  % récupération du handle de la classe Variable Global du fichier courant
  vg =Ofich.Vg;

  % Lecture de la dernière clé pressée au clavier
  laclef =double(get(Oaff.fig,'CurrentCharacter'));

  if isempty(laclef)
    return
  end

  % traitement de la clé pressée
  switch laclef
  %***********
  case {67,99}        % lettre C, Changer canaux avec flèches haut et bas
    VG.nextkey =0;
  %************
  case {69,101}       % lettre E, Changer essai avec flèches haut et bas
    VG.nextkey =1;
    if vg.affniv
      vg.affniv =0;
      Oaff.affiche();
    end
  %************
  case {78,110}       % lettre N, Changer niveau-catégorie avec flèches haut et bas
    if vg.niveau
      VG.nextkey =2;
      if ~vg.affniv
        vg.affniv =1;
        Oaff.affiche();
      end
    end
  %******
  case {30,45}        % flèches haut et signe -
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
  case {31,43}        % flèches bas et signe +
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
