% Linear rank selection. Assign probability value according to rank of
% fitness value. Returns the chosen index.
function choice = LinearRankSelection(fitScore)
[fitScoreNum,~] = size(fitScore);
%sort fitness score and save index
[scoreSorted, index] = sort(fitScore,"descend");
%create new fitness score acoording to rank
prob = [fitScoreNum:-1:1];
prob = prob./(fitScoreNum);
prob = prob(index);
accumulation = cumsum(prob);
chosen_index = 0;
%p = rand(1,fitScoreNum);
p = rand();
p = p.*((fitScoreNum+1)/2);
for i = 1 : length(accumulation)
    if (accumulation(i) > p)
      chosen_index = i;
      break;
    end
end
choice = chosen_index;
end