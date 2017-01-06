%
% Classe CGuiMLLire
%
% Gère les informations du GUI Lire
%
% MEK
% 2016/03/04
%
classdef CGuiMLLire < CBaseStringGUI
  %_____________________________________________________________________________
  properties
  %-----------------------------------------------------------------------------

    % mnouvre2
    txtwbar ='Ouverture du fichier: ';

    % Waitbar
    lectfich ='Lecture du fichier ';
    lectfichs ='Lecture des fichiers ';
    vide ='';
    vides ='';
    patience =', veuillez patienter';
    lectcanal ='Lecture du canal: ';
    fichier ='Fichier: ';
    concatinfo ='Concaténation des infos: ';
    canal ='Canal ';
    fairess ='Construction des essais: ';

    % Keithley
    kiname ='Lecture des fichiers Keithley';
    kichoixfich ='Choix du fichier keithley';
    kiinscripath ='Inscrire le PATH au complet';
    kiutilisezvous ='Utilisez-vous plusieurs...?';
    kitxtsess ='session';
    kitxtcond ='condition';
    kitxtseqtyp ='seq-type';
    kibuttonGo ='Au travail';
    kinomfich ='fichier d''acquisition de la Keithley'
    kilectwbar ='Lecture du fichier Keithley, veuillez patienter';

    % HDF5
    h5ouvfich ='Ouverture d''un fichier H5 ()';
    h5wbarinfocan ='Lecture des informations sur les canaux';

    % A21XML
    a21ouvfich ='Ouverture d''un fichier XML (Auto 21)';

  end  %properties

  %_____________________________________________________________________________
  methods
  %-----------------------------------------------------------------------------

    %___________________________________________________________________________
    % CONSTRUCTOR
    %---------------------------------------------------------------------------

    function tO =CGuiMLLire()

      % La classe CBaseStringGUI se charge de l'initialisation
      tO.init('lire');

    end

  end
  %_____________________________________________________________________________
  % fin des methods
  %-----------------------------------------------------------------------------
end
