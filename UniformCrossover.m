% Uniform crossover
% takes 2 chromosome and returns 2 chromosome crossovered
function [chrome1,chrome2] = UniformCrossover(temp1,temp2)
[~,chromoSize] = size(temp1);
swappingProb = 0.5;
probArr = rand(1,chromoSize);
for i = 1:chromoSize
    if probArr(i)<swappingProb
        % do nothing
        continue;
    else
        % swap two values
        temp = temp1(i);
        temp1(i) = temp2(i);
        temp2(i) = temp;
    end
end
chrome1 = temp1;
chrome2 = temp2;
end

