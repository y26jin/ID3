function result = infogain( examples, attr, entrophyS )
result = entrophyS;
frac_size = size(examples, 1);
attr_size = size(examples, 2);

%diction = examples(frac_size * (attr_size - 1)+1:frac_size*attr_size);

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
    
frac = nega/(nega+pos);
if frac > 0
result = result - frac*entrophy(examples, attr, 0);
end

frac = pos/(nega+pos);
if frac > 0
result = result - frac*entrophy(examples, attr, 1);
end

end

