function tree = ID3( examples, target_attr, attrs)
% ID3 Algorithm

% Read data from the training file into matrix
% train_file = 'horseTrain.txt';
% train_fid = fopen(train_file);
% train_raw_data = textscan(train_fid, '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f');
% example = train_raw_data;
% fclose(train_fid);

% Tree structure
%maintree = struct('root','','left','','right','');

% If all examples are positive
% return with label '+'
% If all examples are negative
% return with label '-'
% Otherwise further train

frac_size = size(examples,1);
attr_size = size(examples,2);

attr_names = {'K','Na','CL','HCO3','Endotoxin','Aniongap','PLA2','SDH','GLDH','TPP','Breath rate','PCV','Pulse rate','Fibrinogen','Dimer','FibPerDim'};

health_status = unique(examples(frac_size*(attr_size-1)+1:frac_size*attr_size))
if numel(health_status) == 1
    % All examples are either positive or negative
    if health_status(1) == 0
        tree = struct('root', 'healthy', 'threshold',0, 'less', [], 'more', []);
    elseif health_status(1) == 1
        tree = struct('root', 'colic','threshold',0, 'less', [], 'more', []);
    end
elseif isempty(attrs) == 1
    % Predicting attributes are empty
    % return the most common value
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
    
    if nega > pos
        tree = struct('root', 'healthy', 'threshold',0,'less', [], 'more', []);
    else
        tree = struct('root', 'colic', 'threshold',0,'less', [], 'more', []);
    end
else
    % Need to further proceed
    enS = entrophy(examples, 0); % sys entrophy
    attr_infogain = [];
    max_value = 0;
    max_attr = 0;
    
    % find the attr with max info gain
    for i=1:numel(attrs)
        temp = infogain(examples, attrs(i), enS);
        attr_infogain = [attr_infogain, temp];
    end
    [max_value max_attr] = max(attr_infogain);   
    
    % attributes left to be proceed
    subattr = [];
    for i=1:numel(attrs)
        if i ~= max_attr
            subattr = [subattr,i];
        end
    end
    % threshold
    attr_list = examples(frac_size*(max_attr-1)+1:frac_size*max_attr);
    threshold = mean(attr_list);
    % generate subset of examples 
    subEX = [];    
    for i = 1:frac_size
        if attr_list(i) < threshold % first branch
            temp = examples(i, :);
            subEX = [subEX;temp];
        end
    end
    
    if isempty(subEX) == false
        subtree1 = ID3(subEX, target_attr, subattr);       
    end
    
    subEX = [];
    for i = 1:frac_size
        if attr_list(i) > threshold % second branch
            temp = examples(i, :);
            subEX = [subEX;temp];
        end
    end
    
    if isempty(subEX) == false
        subtree2 = ID3(subEX, target_attr, subattr);
    end

    tree = struct('root',attr_names(max_attr),'threshold', threshold, 'less',subtree1,'more',subtree2);
end

end

