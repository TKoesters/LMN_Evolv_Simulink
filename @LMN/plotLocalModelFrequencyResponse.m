function  fig = plotLocalModelFrequencyResponse(obj,Gref,diff)
%PLOTLOCALMODELFREQUENCYRESPONSE Summary of this function goes here
%   Detailed explanation goes here

if nargin==1
    Gref = [];
    diff = false;
    plotRef = false;
else
    plotRef = true;
end

fig = figure;
for i = 1 : obj.dimIn
    nexttile;
    z = tf('z');
    
    % create log space in frequency domain & scale to rad/s
    win = logspace(-4,0,400)*2.5*2*pi;

    if plotRef
        Gref.Ts = 0.2;
        [magRef,phase,wout] = bode(Gref(i),win);
    end

    for ii = 1 : obj.getNumberOfLocalModels
        G = 0;
        indexVector = obj.indexInput(i,1) : obj.indexInput(i,2);
        for iii = 1 : obj.xDynInputDelay{i}
             G = G + obj.localModels{ii}.theta(indexVector(iii)) * z^(-iii);
        end
        hold on;
        
        % set sample time
        G.Ts = 0.2;
       
        % calc frequency response
        [mag,phase,wout] = bode(G,win);

        % rescale to Hz
        wout = wout/2*pi;

        if diff
            lms{i} = semilogx(wout,squeeze(magRef)-squeeze(mag));
        else
            lms{i} = semilogx(wout,20*log10(squeeze(mag)));
        end
        names{ii} = ['LM$_' num2str(ii) '$'];
        set(gca,'Xscale','log')                                     
    end
    

    if plotRef && ~diff
        lms{i} = semilogx(wout,20*log10(squeeze(magRef)),'r-.');
        names{ii+1} = 'Ref';
    end

    title(['Input ' num2str(i)]);
    if diff
        ylabel('$\Delta $');
        ylim([-max(abs(mag-magRef)), max(abs(mag-magRef))]);
    else
        ylabel('amplitude [dB]');
    end
    xlabel('frequency $f$ [Hz]');
    if i == obj.dimIn
        legend(names);
    end

end



end

