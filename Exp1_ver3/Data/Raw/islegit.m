function [legit]= islegit(ensumCon, targetCon, exclude ,ensumFace, targetFace)
if targetFace <=8  target  =1; %white face
else target = 2; end

legit = 0;

if ensumCon ~= 3 && targetCon ~= 3 && ensumCon == ensumFace && targetCon == target legit = 1; end
if ensumCon == 3 && targetCon ~= 3 && targetCon == target legit = 1; end
if ensumCon ~= 3 && targetCon == 3 && ensumCon == ensumFace legit = 1; end
if ensumCon == 3 && targetCon == 3 legit = 1; end

if exclude == 1 && (targetFace == 10 || targetFace == 15) legit = 0; end

end