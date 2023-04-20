% k point crossover, k = 1
% takes 2 chromosome and returns 2 chromosome crossovered
function [chromo1, chromo2] = kPointCrossover(temp1, temp2)

temp_chromosome_1 = temp1;
temp_chromosome_2 = temp2;
r = randi(30,1);
tempArr1 = temp_chromosome_1;
temp_chromosome_1(1:r) = temp_chromosome_2(1:r);
temp_chromosome_2(1:r) = tempArr1(1:r);
temp_chromosome_1((r+1):30) = temp_chromosome_2((r+1):30);
temp_chromosome_2((r+1):30) = tempArr1((r+1):30);
chromo1 = temp_chromosome_1;
chromo2 = temp_chromosome_2;
end