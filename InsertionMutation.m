% Insertion mutation
% takes a chromo and returns a chromo mutated
function inserted = InsertionMutation(chromosome)
posOfAction = [1,4,7,10,13,16,19,22,25,28];
[~, chromoSize] = size(chromosome);
r1 = randperm(chromoSize,1);
r2 = randperm(chromoSize,1);
while true
    if ismember(r1,posOfAction) % is digit1 which could only be 1-4
        if ismember(r2,posOfAction)&&r2 == r1
            % perform insertion
            if r1<r2

                newChromosome = [chromosome(1:(r1-1)), chromosome(r2), chromosome(r1:(r2-1)), chromosome((r2+1):end)];
            else
                newChromosome = [chromosome(1:(r2-1)), chromosome(r1), chromosome(r2:(r1-1)), chromosome((r1+1):end)];
            end
            break;
        end
        r2 = randperm(chromoSize,1);
    else % not digit 1
        if ismember(r2,posOfAction)&&r2 == r1
            r2 = randperm(chromoSize,1);
        else
            % perform insertion
            if r1<r2

                newChromosome = [chromosome(1:(r1-1)), chromosome(r2), chromosome(r1:(r2-1)), chromosome((r2+1):end)];
            else
                newChromosome = [chromosome(1:(r2-1)), chromosome(r1), chromosome(r2:(r1-1)), chromosome((r1+1):end)];
            end
            break;
        end
    end 
end
inserted = newChromosome;
end
