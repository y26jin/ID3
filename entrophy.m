function result = entrophy( examples, attr, neg )
result = 0;
frac_size = size(examples, 1);
attr_size = size(examples, 2);

diction = examples(frac_size * (attr_size - 1)+1:frac_size*attr_size);

if attr == 0
    % system entrophy
    nega = 0;
    pos = 0;
    
    for i = 1:size(examples, 1)
        if examples(attr_size*(frac_size - 1) + i) == 0
        % 'healthy'
        nega = nega+1;
        else 
        % 'colic.'
        pos = pos + 1;
        end
    end
        
    frac = nega/frac_size;
    if frac > 0
    result = result - frac*log(frac)/log(2);
    end
    
    frac = pos/frac_size;
    if frac > 0
    result = result - frac*log(frac)/log(2);    
    end
elseif attr > 0 
    % entrophy of certain attribute
    attr_list = examples(frac_size*(attr-1)+1:frac_size*attr);
    threshold = mean(attr_list);
    fprintf('%f\n',threshold);
    negaweak = 0;
    negastrong = 0;
    posweak = 0;
    posstrong = 0;
    
    for i=1:frac_size
        if examples(frac_size*(attr-1)+i) < threshold 
            if diction(i) == 0
                negaweak = negaweak+1;
            else
                posweak = posweak+1;
            end
        else
            if diction(i) == 0
                negastrong = negastrong+1;
            else
                posstrong = posstrong+1;
            end
        end
    end
    
    if neg == 0
        frac = negaweak/(negaweak+posweak);
        if frac > 0            
            result = result - frac*log(frac)/log(2);
        end
        
        frac = posweak/(negaweak+posweak);
        if frac > 0
            result = result - frac*log(frac)/log(2);
        end
    else
        frac = negastrong/(negastrong+posstrong);
        if frac > 0
            result = result - frac*log(frac)/log(2);
        end
        
        frac = posstrong/(negastrong+posstrong);
        if frac > 0
            result = result - frac*log(frac)/log(2);
        end
    end
end

end