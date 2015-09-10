function [mh24,Opt]=mhit_get_MH24(discharge,Opt)
validateattributes(discharge,{'single','double'},{'column'});

%% Checking Options
if (nargin<2 || isempty(Opt))
  [~,Opt]=mhit_get_MA2(discharge);
else
  if (~isfield(Opt,'medianDischarge') || isempty(Opt.medianDischarge))
    [~,Opt]=mhit_get_MA2(discharge,Opt);
  end
end

%%
mask=discharge>(Opt.medianDischarge);

eventStart=find(diff([0;mask])>0);
eventEnd=find(diff([mask;0])<0);
if (numel(eventStart)~=numel(eventEnd))
  error('mhit_get_MH24: couldn''t properly recognize the events.')
end

peaksVec=arrayfun(@(eventID) max(discharge(eventStart(eventID):eventEnd(eventID))), 1:numel(eventStart));

mh24=mean(peaksVec)/Opt.medianDischarge;

end