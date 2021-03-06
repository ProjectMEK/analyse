%%
%  fpltAmti(V, sies)  en entr�e on aura un objet CCalculCOP
% 
%% Ce programme permet de calculer le centre de pression � partir d'une ou
% des force(s) [N] et des moments de forces [Nm] pour la plate forme de
% force AMTI conductive (mod�le OR6-6, laboratoire posture)
%
% Initi� par M. Simoneau, Janvier 2002
% Version 1.0
% Version 1.1 ptchnl save!
% Version 1.2, 02/2003 nombre de canaux hdchnl
% Version 1.3 05/2003: modification de CPx & CPy multiplication par 100 donc unit� maintenant CM
% Version 1.4 02/2006 : modification pour distinction entre 3 et 6 canaux et simplification du code
% Version 1.5 06/2007: modification pour que les fr�quences d'entr�es et de sorties soient les m�mes
% Version 1.6 08/2007: modification du Vexcitation de 10.004 � 4.988 car les jumpers sont placer � 5 Volts
%                      modification du Vexcitation de � 10.005 car les jumpers sont placer � 10 Volts
% Version 2.0 transformation pour le format Analyse-2009, d�c 2009 par MEK
%
% Introduit dans Analyse
% 30 octobre 2012, MEK
%
function fpltAmti(hObj, canal)
  oA =CAnalyse.getInstance();
  oF =oA.findcurfich();
  hdchnl =oF.Hdchnl;
  vg =oF.Vg;
  leWb =laWaitbar(0, 'Calcul du centre de pression...', 'C', 'C', gcf);
  leBout =vg.ess+5;
  renduA =0;
  % cr�ation des canaux
  hdchnl.duplic([canal canal(3) canal(3)]);
  hdchnl.adname{end-1} ='CPx';
  hdchnl.adname{end} ='CPy';
  nbcan =length(canal)+2;
  nCanal =nbcan-1;             % en fait c'est: length(canal)+2-1
  suivant =vg.nad+1;
  % Param utils
  amtiMC =hObj.getAmtiMC();
  %---         Do.. pour Data Output
  if length(canal) == 6
    hFx =CDtchnl();
    oF.getcanal(hFx, canal(1));
    nFx =hFx.Nom;
    hdchnl.adname{end-nCanal} ='New_Fx'; nCanal =nCanal-1;
    %--- num�ro du nouveau canal ---%
    n.fx =suivant; suivant =suivant+1;
    hFy =CDtchnl();
    oF.getcanal(hFy, canal(2));
    nFy =hFy.Nom;
    hdchnl.adname{end-nCanal} ='New_Fy'; nCanal =nCanal-1;
    n.fy =suivant; suivant =suivant+1;
    hFz =CDtchnl();
    oF.getcanal(hFz, canal(3));
    nFz =hFz.Nom;
    hdchnl.adname{end-nCanal} ='New_Fz'; nCanal =nCanal-1;
    n.fz =suivant; suivant =suivant+1;
    hMx =CDtchnl();
    oF.getcanal(hMx, canal(4));
    nMx =hMx.Nom;
    hdchnl.adname{end-nCanal} ='New_Mx'; nCanal =nCanal-1;
    n.mx =suivant; suivant =suivant+1;
    hMy =CDtchnl();
    oF.getcanal(hMy, canal(5));
    nMy =hMy.Nom;
    hdchnl.adname{end-nCanal} ='New_My'; nCanal =nCanal-1;
    n.my =suivant; suivant =suivant+1;
    hMz =CDtchnl();
    oF.getcanal(hMz, canal(6));
    nMz =hMz.Nom;
    hdchnl.adname{end-nCanal} ='New_Mz';
    n.mz =suivant; suivant =suivant+1;
    letop =max([size(hFx.Dato.(nFx),1), size(hFy.Dato.(nFy),1), size(hFz.Dato.(nFz),1), size(hMx.Dato.(nMx),1), size(hMy.Dato.(nMy),1), size(hMz.Dato.(nMz),1)]);
    DoFx =zeros(letop, vg.ess);
    DoFy =DoFx;
    DoFz =DoFx;
    DoMx =DoFx;
    DoMy =DoFx;
    DoMz =DoFx;
    DoCPx =DoFx;
    DoCPy =DoFx;
  elseif length(canal) == 3
    hFz =CDtchnl();
    oF.getcanal(hFz, canal(1));
    nFz =hFz.Nom;
    hdchnl.adname{end-nCanal} ='New_Fz'; nCanal =nCanal-1;
    n.fz =suivant; suivant =suivant+1;
    hMx =CDtchnl();
    oF.getcanal(hMx, canal(2));
    nMx =hMx.Nom;
    hdchnl.adname{end-nCanal} ='New_Mx'; nCanal =nCanal-1;
    n.mx =suivant; suivant =suivant+1;
    hMy =CDtchnl();
    oF.getcanal(hMy, canal(3));
    nMy =hMy.Nom;
    hdchnl.adname{end-nCanal} ='New_My';
    n.my =suivant; suivant =suivant+1;
    letop =max([size(hFz.Dato.(nFz), 1), size(hMx.Dato.(nMx), 1), size(hMy.Dato.(nMy), 1)]);
    DoFz =zeros(letop, vg.ess);
    DoMx =DoFz;
    DoMy =DoFz;
    DoCPx =DoFz;
    DoCPy =DoFz;
  end
  n.cpx =suivant; suivant =suivant+1;
  n.cpy =suivant;
  renduA =renduA+2;
  waitbar(renduA/leBout, leWb);
  %--- Param�tre amplificateur MSA-6 ---%
  FxVex =hObj.getVFx; MxVex =hObj.getVMx;
  FyVex =hObj.getVFy; MyVex =hObj.getVMy;
  FzVex =hObj.getVFz; MzVex =hObj.getVMz;
  %--- GAIN ---%
  Gain_Fx =hObj.getGainFx; Gain_Mx =hObj.getGainMx;
  Gain_Fy =hObj.getGainFy; Gain_My =hObj.getGainMy;
  Gain_Fz =hObj.getGainFz; Gain_Mz =hObj.getGainMz;
  %--- Facteur de correction ---%
  kFx =10^6/(Gain_Fx*FxVex);
  kFy =10^6/(Gain_Fy*FyVex);
  kFz =10^6/(Gain_Fz*FzVex);
  kMx =10^6/(Gain_Mx*MxVex);
  kMy =10^6/(Gain_My*MyVex);
  kMz =10^6/(Gain_Mz*MzVex);
  %--- Distance verticale entre le top de la plate forme et l'origine ---%
  %--- Selon AMTI pour notre plate forme voir C3 - SN3245 du manuel
  %--- d'instrustion dans bureau � Normand (Zoff = 35 mm)
  Zoff =hObj.getZOff;
  %--- Enfin le calcul ---%
  renduA =renduA+2;
  waitbar(renduA/leBout, leWb);
  for trial =1:vg.ess
    NS =min(hdchnl.nsmpls(canal, trial));
    waitbar((renduA+trial)/leBout, leWb);
    if length(canal) == 3
      %--- Fz ---%
      DoFz(1:NS,trial) =hMx.Dato.(nMx)(1:NS,trial).*(amtiMC(6,1)*kMx)+hMy.Dato.(nMy)(1:NS,trial).*(amtiMC(6,2)*kMy) +...
                        hFz.Dato.(nFz)(1:NS,trial).*(amtiMC(6,6)*kFz);
      hdchnl.max(n.fz, trial) =max(DoFz(1:NS,trial));
      hdchnl.min(n.fz, trial) =min(DoFz(1:NS,trial));
      %--- Mx ---%
      DoMx(1:NS,trial) =hMx.Dato.(nMx)(1:NS,trial).*amtiMC(1,1)*kMx+hMy.Dato.(nMy)(1:NS,trial).*(amtiMC(1,2)*kMy) +...
                        hFz.Dato.(nFz)(1:NS,trial).*(amtiMC(1,6)*kFz);
      hdchnl.max(n.mx, trial) = max(DoMx(1:NS,trial));
      hdchnl.min(n.mx, trial) = min(DoMx(1:NS,trial));
      %--- My ---%
      DoMy(1:NS,trial) =hMx.Dato.(nMx)(1:NS,trial).*amtiMC(2,1)*kMx+hMy.Dato.(nMy)(1:NS,trial).*(amtiMC(2,2)*kMy) +...
                        hFz.Dato.(nFz)(1:NS,trial).*(amtiMC(2,6)*kFz);
      hdchnl.max(n.my, trial) =max(DoMy(1:NS,trial));
      hdchnl.min(n.my, trial) =min(DoMy(1:NS,trial));
      %--- CPx [cm] ---%
      DoCPx(:,trial) =-(DoMy(:,trial)./DoFz(:,trial))*100;  % Unit�: cm
      hdchnl.max(n.cpx, trial) =max(DoCPx(1:NS,trial));
      hdchnl.min(n.cpx, trial) =min(DoCPx(1:NS,trial));
      %--- CPy [cm] ---%
      DoCPy(:,trial) =(DoMx(:,trial)./DoFz(:,trial))*100;   % Unit�: cm
      hdchnl.max(n.cpy, trial) =max(DoCPy(1:NS,trial));
      hdchnl.min(n.cpy, trial) =min(DoCPy(1:NS,trial));
    elseif length(canal) == 6  % [hFx, hFy, hFz, hMx, hMy, hMz]
      %--- Fx ---%
      DoFx(1:NS,trial) =hFx.Dato.(nFx)(1:NS,trial).*(amtiMC(4,4)*kFx)+hFy.Dato.(nFy)(1:NS,trial).*(amtiMC(4,5)*kFy) +...
                        hFz.Dato.(nFz)(1:NS,trial).*(amtiMC(4,6)*kFz)+hMx.Dato.(nMx)(1:NS,trial).*(amtiMC(4,1)*kMx) +...
                        hMy.Dato.(nMy)(1:NS,trial).*(amtiMC(4,2)*kMy)+hMz.Dato.(nMz)(1:NS,trial).*(amtiMC(4,3)*kMz);
      hdchnl.max(n.fx, trial) =max(DoFx(1:NS,trial));
      hdchnl.min(n.fx, trial) =min(DoFx(1:NS,trial));
      %--- Fy ---%
      DoFy(1:NS,trial) =hFx.Dato.(nFx)(1:NS,trial).*(amtiMC(5,4)*kFx)+hFy.Dato.(nFy)(1:NS,trial).*(amtiMC(5,5)*kFy) +...
                        hFz.Dato.(nFz)(1:NS,trial).*(amtiMC(5,6)*kFz)+hMx.Dato.(nMx)(1:NS,trial).*(amtiMC(5,1)*kMx) +...
                        hMy.Dato.(nMy)(1:NS,trial).*(amtiMC(5,2)*kMy)+hMz.Dato.(nMz)(1:NS,trial).*(amtiMC(5,3)*kMz);
      hdchnl.max(n.fy, trial) =max(DoFy(1:NS,trial));
      hdchnl.min(n.fy, trial) =min(DoFy(1:NS,trial));
      %--- Fz ---%
      DoFz(1:NS,trial) =hFx.Dato.(nFx)(1:NS,trial).*(amtiMC(6,4)*kFx)+hFy.Dato.(nFy)(1:NS,trial).*(amtiMC(6,5)*kFy) +...
                        hFz.Dato.(nFz)(1:NS,trial).*(amtiMC(6,6)*kFz)+hMx.Dato.(nMx)(1:NS,trial).*(amtiMC(6,1)*kMx) +...
                        hMy.Dato.(nMy)(1:NS,trial).*(amtiMC(6,2)*kMy)+hMz.Dato.(nMz)(1:NS,trial).*(amtiMC(6,3)*kMz);
      hdchnl.max(n.fz, trial) =max(DoFz(1:NS,trial));
      hdchnl.min(n.fz, trial) =min(DoFz(1:NS,trial));
      %--- Mx ---%
      DoMx(1:NS,trial) =hFx.Dato.(nFx)(1:NS,trial).*(amtiMC(1,4)*kFx)+hFy.Dato.(nFy)(1:NS,trial).*(amtiMC(1,5)*kFy) +...
                        hFz.Dato.(nFz)(1:NS,trial).*(amtiMC(1,6)*kFz)+hMx.Dato.(nMx)(1:NS,trial).*(amtiMC(1,1)*kMx) +...
                        hMy.Dato.(nMy)(1:NS,trial).*(amtiMC(1,2)*kMy)+hMz.Dato.(nMz)(1:NS,trial).*(amtiMC(1,3)*kMz);
      hdchnl.max(n.mx, trial) =max(DoMx(1:NS,trial));
      hdchnl.min(n.mx, trial) =min(DoMx(1:NS,trial));
      %--- My ---%
      DoMy(1:NS,trial) =hFx.Dato.(nFx)(1:NS,trial).*(amtiMC(2,4)*kFx)+hFy.Dato.(nFy)(1:NS,trial).*(amtiMC(2,5)*kFy) +...
                        hFz.Dato.(nFz)(1:NS,trial).*(amtiMC(2,6)*kFz)+hMx.Dato.(nMx)(1:NS,trial).*(amtiMC(2,1)*kMx) +...
                        hMy.Dato.(nMy)(1:NS,trial).*(amtiMC(2,2)*kMy)+hMz.Dato.(nMz)(1:NS,trial).*(amtiMC(2,3)*kMz);
      hdchnl.max(n.my, trial) =max(DoMy(1:NS,trial));
      hdchnl.min(n.my, trial) =min(DoMy(1:NS,trial));
      %--- Mz ---%
      DoMz(1:NS,trial) =hFx.Dato.(nFx)(1:NS,trial).*(amtiMC(3,4)*kFx)+hFy.Dato.(nFy)(1:NS,trial).*(amtiMC(3,5)*kFy) +...
                        hFz.Dato.(nFz)(1:NS,trial).*(amtiMC(3,6)*kFz)+hMx.Dato.(nMx)(1:NS,trial).*(amtiMC(3,1)*kMx) +...
                        hMy.Dato.(nMy)(1:NS,trial).*(amtiMC(3,2)*kMy)+hMz.Dato.(nMz)(1:NS,trial).*(amtiMC(3,3)*kMz);
      hdchnl.max(n.mz, trial) =max(DoMz(1:NS,trial));
      hdchnl.min(n.mz, trial) =min(DoMz(1:NS,trial));
      %--- CPx ---%
      DoCPx(1:NS,trial) =((-DoMy(1:NS,trial)+Zoff.*DoFx(1:NS,trial))./DoFz(1:NS,trial))*100;  % Unit�: cm
      hdchnl.max(n.cpx, trial) =max(DoCPx(1:NS,trial));
      hdchnl.min(n.cpx, trial) =min(DoCPx(1:NS,trial));
      %--- CPy ---%
      DoCPy(1:NS,trial) =((DoMx(1:NS,trial)-Zoff.*DoFy(1:NS,trial))./DoFz(1:NS,trial))*100;   % Unit�: cm
      hdchnl.max(n.cpy, trial) =max(DoCPy(1:NS,trial));
      hdchnl.min(n.cpy, trial) =min(DoCPy(1:NS,trial));
    end
  end
  % Destruction des canaux inutils pour le reste du traitement
  % et sauvegarde des datas utiles
  tmpDt =CDtchnl();
  nTmp ='tmp';
  if length(canal) == 3
    delete([hFz hMx hMy]);
    clear hFz hMx hMy;
    % sauve Fz
    sD.tmp =DoFz; clear DoFz;
    tmpDt.Dato =sD;
    oF.setcanal(tmpDt, n.fz);
    % sauve Mx
    sD.tmp =DoMx; clear DoMx;
    tmpDt.Dato =sD;
    oF.setcanal(tmpDt, n.mx);
    % sauve My
    sD.tmp =DoMy; clear DoMy;
    tmpDt.Dato =sD;
    oF.setcanal(tmpDt, n.my);
    % sauve Cpx
    sD.tmp =DoCPx; clear DoCPx;
    tmpDt.Dato =sD;
    oF.setcanal(tmpDt, n.cpx);
    % sauve CPy
    sD.tmp =DoCPy; clear DoCPy;
    tmpDt.Dato =sD;
    oF.setcanal(tmpDt, n.cpy);
  elseif length(canal) == 6
    delete([hFx hFy hFz hMx hMy hMz]);
    clear hFx hFy hFz hMx hMy hMz;
    % sauve Fx
    sD.tmp =DoFx; clear DoFx;
    tmpDt.Dato =sD;
    oF.setcanal(tmpDt, n.fx);
    % sauve Fy
    sD.tmp =DoFy; clear DoFy;
    tmpDt.Dato =sD;
    oF.setcanal(tmpDt, n.fy);
    % sauve Fz
    sD.tmp =DoFz; clear DoFz;
    tmpDt.Dato =sD;
    oF.setcanal(tmpDt, n.fz);
    % sauve Mx
    sD.tmp =DoMx; clear DoMx;
    tmpDt.Dato =sD;
    oF.setcanal(tmpDt, n.mx);
    % sauve My
    sD.tmp =DoMy; clear DoMy;
    tmpDt.Dato =sD;
    oF.setcanal(tmpDt, n.my);
    % sauve Mz
    sD.tmp =DoMz; clear DoMz;
    tmpDt.Dato =sD;
    oF.setcanal(tmpDt, n.mz);
    % sauve Cpx
    sD.tmp =DoCPx; clear DoCPx;
    tmpDt.Dato =sD;
    oF.setcanal(tmpDt, n.cpx);
    % sauve CPy
    sD.tmp =DoCPy; clear DoCPy;
    tmpDt.Dato =sD;
    oF.setcanal(tmpDt, n.cpy);
  end
  vg.nad =vg.nad+nbcan;
  vg.sauve =true;
  delete(leWb); 	
end
