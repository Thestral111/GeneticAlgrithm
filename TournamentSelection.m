% Tournament Selection. It takes  all fitness score in population, randomly
% choose five, and returns the index of highest one
function choice = TournamentSelection(fitScore)
[fitScoreNum,~] = size(fitScore);
P = randperm(fitScoreNum, 2);
selected = fitScore(P);
[selected, index] = sort(selected,"descend");
choice = P(index(1));
end
