%%
% ExportCalculCOP(hObj)
%
% Exportation des paramètres de l'interface GUICalculCOP()
%
% hObj  handle de la classe CCalculCOP/CCalculCOPoptima
%
function ExportCalculCOP(hObj)
  [f, p] =uiputfile({'*.INI', 'Afficher les fichiers *.ini'; '*.*', 'Afficher tous les fichiers' });
  % si on a annulé, on sort
  if (length(f) == 1 && f == 0) || (length(p) == 1 && p == 0)
    return;
  end
  % avec quelle plateforme on a travaillé
  optima =hObj.getNewplt();
  leFichier =fullfile(p, f);
  fid =fopen(leFichier, 'w+');
  if optima
    fprintf(fid, '[OPTIMA]\n');
  else
    fprintf(fid, '[AMTI]\n');
  end
  fprintf(fid, '  [CANAUX]\n');
  fprintf(fid, '    Fx =%s\n', num2str(hObj.getCanFx));
  fprintf(fid, '    Fy =%s\n', num2str(hObj.getCanFy));
  fprintf(fid, '    Fz =%s\n', num2str(hObj.getCanFz));
  fprintf(fid, '    Mx =%s\n', num2str(hObj.getCanMx));
  fprintf(fid, '    My =%s\n', num2str(hObj.getCanMy));
  fprintf(fid, '    Mz =%s\n', num2str(hObj.getCanMz));
  fprintf(fid, '  [\\CANAUX]\n');
  %
  fprintf(fid, '  [CALIBRATION]\n');
  if optima
    matCal =hObj.getOptimaFC();
    fprintf(fid, '    FC =%s\n', num2str(matCal(1,:)));
    fprintf(fid, '  [\\CALIBRATION]\n');
    fprintf(fid, '[\\OPTIMA]\n');
  else
    matCal =hObj.getAmtiMC();
    for U =1:length(matCal(:,1))
      fprintf(fid, '    MC%s =%s\n', num2str(U), num2str(matCal(U,:)));
    end
    fprintf(fid, '  [\\CALIBRATION]\n');
    %
    fprintf(fid, '  [GAIN]\n');
    fprintf(fid, '    Fx =%s\n', num2str(hObj.getGainFx));
    fprintf(fid, '    Fy =%s\n', num2str(hObj.getGainFy));
    fprintf(fid, '    Fz =%s\n', num2str(hObj.getGainFz));
    fprintf(fid, '    Mx =%s\n', num2str(hObj.getGainMx));
    fprintf(fid, '    My =%s\n', num2str(hObj.getGainMy));
    fprintf(fid, '    Mz =%s\n', num2str(hObj.getGainMz));
    fprintf(fid, '  [\\GAIN]\n');
    fprintf(fid, '  [VEXT]\n');
    fprintf(fid, '    Fx =%s\n', num2str(hObj.getVFx));
    fprintf(fid, '    Fy =%s\n', num2str(hObj.getVFy));
    fprintf(fid, '    Fz =%s\n', num2str(hObj.getVFz));
    fprintf(fid, '    Mx =%s\n', num2str(hObj.getVMx));
    fprintf(fid, '    My =%s\n', num2str(hObj.getVMy));
    fprintf(fid, '    Mz =%s\n', num2str(hObj.getVMz));
    fprintf(fid, '  [\\VEXT]\n');
    fprintf(fid, '  [ZOFFSET]\n');
    fprintf(fid, '    Z =%s\n', num2str(hObj.getZOff));
    fprintf(fid, '  [\\ZOFFSET]\n');
    fprintf(fid, '[\\AMTI]\n');
  end
  fclose(fid);
end
