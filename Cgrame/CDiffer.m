%
% Class CDiffer
%
% On suit la démarche retrouvé dans le programme differ.pas développé pour
% l'environnement DOS. Tous les calculs se font avec la fonction DIFFER.M
%
% METHODS
%       CDiffer()                    CONSTRUCTOR
%
%
%
classdef CDiffer < handle

  properties
    fig =[];
  end

  methods

    %------------------
    % DESTRUCTOR
    %------------------
    function delete(tO)
      if ~isempty(tO.fig)
        delete(tO.fig);
        tO.fig =[];
      end
    end

    %------------------------------------------------------
    % Affiche le GUI pour définir les paramètres de travail
    %------------------------------------------------------
    function guiDiffer(tO)
      OA =CAnalyse.getInstance();
      Ofich =OA.findcurfich();
      hdchnl =Ofich.Hdchnl;
      GUIDiffer(tO, hdchnl.Listadname);
    end

    %--------------------------------------------------------------------
    % On procède au calcul à partir des valeurs de l'interface graphique.
    %--------------------------------------------------------------------
    function travail(tO,varargin)
      hA =CAnalyse.getInstance();
      hF =hA.findcurfich();
      % lecture des paramètres du GUI
      foo.nad =get(findobj('tag','ListeCan'),'Value')';           % canaux à différencier
      foo.ovw =get(findobj('tag','memeCan'),'Value');             % on écrase le canal source
      foo.lar =get(findobj('Tag','LargeurFenLissage'),'String');  % Nb de point pour le lissage en char
      % on appel la fonction qui va faire le travail
      tO.cParti(hF,foo);
    end

    %---------------------------------------------------
    % Ici on effectue le travail pour la fonction Differ
    % même chose en mode batch
    % En entrée  Ofich  --> handle du fichier à traiter
    %                S  --> structure des param du GUI
    %---------------------------------------------------
    function cParti(tO,Ofich,S)
      OA =CAnalyse.getInstance();
      % paramètres du GUI
      Vcan =S.nad;
      nouveau =~S.ovw;
      fen =S.lar;
      % infos utiles du fichier
      hdchnl =Ofich.Hdchnl;
      vg =Ofich.Vg;
      dtchnl =CDtchnl();
      window =str2double(fen);                                  % Nb de point pour le lissage en chiffre
      auTravail =str2func('differ');
      if window < 2
        auTravail =@tO.rawDiffer;
      end
      nombre =length(Vcan);
      if nouveau
        hdchnl.duplic(Vcan);
        Ncan =vg.nad+1:vg.nad+nombre;
      else
      	Ncan =Vcan;
      end
      % gestion du waitbar
      wbval =0;
      wbstep =1/nombre;
      wbstep2 =1/(nombre*vg.ess);
      leTit ='Differ sur le canal: ';
      tt =false;
      hwb =findobj('type','figure','name',OA.wbnom);
      if isempty(hwb)
        hwb =waitbar(wbval, leTit, 'name',OA.wbnom);
        tt =true;
      end
      for U =1:nombre
     	  % on vérifie la grosseur en mémoire pour un canal complet
       	% on permet 400 Mo max
       	comodato =vg.ess*max(hdchnl.nsmpls(Vcan(U),:))*4/1024/1024;
     	  if comodato > 400
     	    disp(['Le canal ' num2str(U) ' dépasse 400 Mo en mémoire']);
     	  	continue;
     	  end
        Ofich.getcanal(dtchnl, Vcan(U));
        if (min(hdchnl.nsmpls(Vcan(U),:)) ~= max(hdchnl.nsmpls(Vcan(U),:)) ||...
            min(hdchnl.rate(Vcan(U),:)) ~= max(hdchnl.rate(Vcan(U),:)))
          hdchnl.adname{Ncan(U)} =['D.' deblank(hdchnl.adname{Ncan(U)})];
          for V =1:vg.ess
          	try
              Ftit =[leTit num2str(Vcan(U)) ', essai: ' num2str(V)];
              waitbar(wbval,hwb,Ftit);
              wbval =wbval+wbstep2;
              lemoins =hdchnl.nsmpls(Vcan(U),V);
              auTravail(dtchnl, lemoins, V, window, hdchnl.rate(Vcan(U) ,V));
              hdchnl.comment{Ncan(U), V} =[hdchnl.comment{Ncan(U), V} ' Differ,Fen=' fen '//'];
              hdchnl.max(Ncan(U),V) =max(dtchnl.Dato.(dtchnl.Nom)(1:lemoins,V));
              hdchnl.min(Ncan(U),V) =min(dtchnl.Dato.(dtchnl.Nom)(1:lemoins,V));
            catch auvol
              disp(['Erreur, canal: ' num2str(Vcan(U)) ' essai: ' num2str(V)]);
              disp(auvol.message);
            end
          end
        else
          Ftit =[leTit num2str(Vcan(U))];
          waitbar(wbval,hwb,Ftit);
          wbval =wbval+wbstep;
          lemoins =hdchnl.nsmpls(Vcan(U),1);
          auTravail(dtchnl, lemoins, [1:vg.ess], window, hdchnl.rate(Vcan(U), 1));
          hdchnl.adname{Ncan(U)} =['D.' deblank(hdchnl.adname{Vcan(U)})];
          for V =1:vg.ess
            hdchnl.comment{Ncan(U), V} =[hdchnl.comment{Ncan(U), V} ' Differ,Fen=',fen,'//'];
            hdchnl.max(Ncan(U),V) =max(dtchnl.Dato.(dtchnl.Nom)(1:lemoins,V));
            hdchnl.min(Ncan(U),V) =min(dtchnl.Dato.(dtchnl.Nom)(1:lemoins,V));
          end
        end
        Ofich.setcanal(dtchnl, Ncan(U));
      end
      delete(dtchnl);
      if tt
        delete(hwb);
      end
      delete(tO.fig);
      vg.sauve =1;
      if nouveau
        vg.nad =vg.nad+nombre;
        gaglobal('editnom');
      else
        OA.OFig.affiche();
      end
    end

    %-------------------------------------------------------------
    % Fonction pour faire la "dérivé brute":  (Xi+1)-(Xi)
    % En entrée
    %   hndt    Objet de la classe CDtchnl
    %   smpls   nombre de sample à traiter  hdchnl.nsmpls(can,ess)
    %   ess     numéro de l'essai
    %   fen     largeur de la fenêtre pour le lissage
    %   rate    fréquence d'échantillonage  hdchnl.rate(can,ess)
    %-------------------------------------------------------------
    function rawDiffer(tO,hndt, smpls, ess, fen, rate)
      hndt.Dato.(hndt.Nom)(1:smpls-1, ess) =hndt.Dato.(hndt.Nom)(2:smpls, ess)-hndt.Dato.(hndt.Nom)(1:smpls-1, ess);
      hndt.Dato.(hndt.Nom)(smpls, ess) =hndt.Dato.(hndt.Nom)(smpls-1, ess);
      hndt.Dato.(hndt.Nom)(:, ess) =hndt.Dato.(hndt.Nom)(:, ess)*rate;
    end

  end

end