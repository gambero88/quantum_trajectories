function wf=StoreWf(it,in,wfnew,wf);

if in.flagwf=='y'
    wf(it,:)=wfnew/norm(wfnew); 
elseif in.flagwf=='n'
    wf=[];
else
    fprintf('ERROR: flagwf not valid')
    error()
end

end