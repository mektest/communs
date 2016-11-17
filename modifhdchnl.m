function ss =modifhdchnl(varargin)
% Si un seul argument: hdchnl
% autrement on veut créer un nouveau hdchnl vide...
  hdchnl =varargin{1};
  lafin =0;
  if isempty(hdchnl)
    can =varargin{2};
    ess =varargin{3};
    lafin =1;
  else
    sss =size(hdchnl);
    can =sss(1);
    if length(sss) > 1
      ess =sss(2);
    else
      ess =1;
    end
  end
  ss.adname(can) ={[]};
  ss.cindx(can) ={[]};
  ss.sweeptime =zeros(can,ess,'single');
  ss.rate =zeros(can,ess,'single');
  ss.nsmpls =zeros(can,ess,'single');
  ss.max =zeros(can,ess,'single');
  ss.min =zeros(can,ess,'single');
  ss.npoints =zeros(can,ess,'single');
  ss.point =zeros(can,ess,'single');
  ss.frontcut =zeros(can,ess,'single');
  ss.numstim =zeros(1,ess,'single');
  ss.comment(can,ess) ={[]};
  if lafin
    return;
  end
  if isfield(hdchnl,'adname')
    for U =1:can
      ss.adname{U} =hdchnl(U,1).adname;
    end
  end
  if isfield(hdchnl,'sweeptime')
  	if ~isempty(hdchnl(1,1).sweeptime)
  	  ledef =hdchnl(1,1).sweeptime(1);
    else
  	  ledef =1;
  	end
    for ii =1:can
      for jj =1:ess
        if ~isempty(hdchnl(ii,jj).sweeptime)
          ss.sweeptime(ii,jj) =hdchnl(ii,jj).sweeptime(1);
        else
          ss.sweeptime(ii,jj) =ledef;
        end
      end
    end
  end
  if isfield(hdchnl,'rate')
  	if ~isempty(hdchnl(1,1).rate)
  		ledef =hdchnl(1,1).rate;
  	else
  		ledef =1;
  	end
    for ii=1:can
      for jj=1:ess
        if ~isempty(hdchnl(ii,jj).rate)
          ss.rate(ii,jj)=hdchnl(ii,jj).rate(1);
        else
          ss.rate(ii,jj)=ledef;
        end
      end
    end
  end
  if isfield(hdchnl,'nsmpls')
  	if ~isempty(hdchnl(1,1).nsmpls)
  		ledef =hdchnl(1,1).nsmpls;
  	else
  		ledef =1;
  	end
    for ii =1:can
      for jj =1:ess
        if length(hdchnl(ii,jj).nsmpls)
          ss.nsmpls(ii,jj) =hdchnl(ii,jj).nsmpls(1);
        else
          ss.nsmpls(ii,jj) =ledef;
        end
      end
    end
  end
  if isfield(hdchnl,'npoints')
    for ii =1:can
      for jj =1:ess
        if length(hdchnl(ii,jj).npoints)
          ss.npoints(ii,jj) =hdchnl(ii,jj).npoints(1);
        else
          ss.npoints(ii,jj) =0;
        end
      end
    end
  end
  if isfield(hdchnl,'point')
    for ii =1:can
      for jj =1:ess
        if length(hdchnl(ii,jj).point)
          ss.point(ii,jj) =hdchnl(ii,jj).point(1);
        end
      end
    end
  end
  if isfield(hdchnl,'frontcut')
    for ii =1:can
      for jj =1:ess
        if length(hdchnl(ii,jj).frontcut)
          ss.frontcut(ii,jj) =hdchnl(ii,jj).frontcut(1);
        else
          ss.frontcut(ii,jj) =hdchnl(1,1).frontcut(1);
        end
      end
    end
  end
  if isfield(hdchnl,'comment')
    for ii =1:can;for jj =1:ess
      ss.comment{ii,jj} =hdchnl(ii,jj).comment;
    end;end
  end
end
