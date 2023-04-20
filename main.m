
Ngen = 1000;
fitness_data = zeros(1,Ngen);
filename_world = 'muir_world.txt';
world_grid = dlmread(filename_world,' ');
hello = 'hi, you will be asked to provide 3 parameters to choose types of selection, cross-over and mutation';
disp(hello);
% get user input
prompt1 = 'Pls input value for selection, 1-RouletteWheelSelection, 2-TournamentSelection, 3-LinearRankSelection\n';
selectionChoice = input(prompt1);
if isempty(selectionChoice)
    selectionChoice = 1;
end
prompt2 = 'Pls input value for crossover, 1-k point, 2-uniform\n';
crossoverChoice = input(prompt2);
if isempty(crossoverChoice)
    crossoverChoice = 1;
end
prompt3 = 'Pls input value for mutation, 1-Flip, 2-Insertion\n';
mutationChoice = input(prompt3);
if isempty(mutationChoice)
    mutationChoice = 1;
end


tic;
%lookup table for euclidian distances between cities
%DistMat = pdist2(xy, xy);

iter = 1000;% Number of iterations: repeat "iter" times 
population_size = 100; % Number of chromosomes in population

fittest = zeros(iter, 1); %initialize vector to store fitness score of fittest individual each generation for plotting

%% generate random population of "population_size" chromosomes
population_size = 150;
population = zeros(population_size,30);
posOfAction = [1,4,7,10,13,16,19,22,25,28];
for i = 1:population_size
    population(i,:) = randi([0 9],1,30);
    population(i, posOfAction) = randi([1 4],1,10);
end

%% extra column at end for fitness scores
population = [population zeros(population_size,1)];

%% repeat iter times; each time generates a new population
for k = 1:iter
    %% evaluate fitness scores
    for i = 1:population_size
        %fitness function: higher values, the smaller the distance
        [population(i,31),~] = (simulate_ant(world_grid,population(i, 1:30)));%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %% Another End condition
    % this end condition checks 90% of the chromosomes in the population have the same fitness value
    % the default one is check for Ngen as it offers better performance
    % pls change the condition to true if you want to use this
    if false
        modeValue = mode(population(:,31));
        proportion = numel(find(population(:,31)==modeValue))/population_size;
        if proportion > 0.9
            S = 'Breaked, end condition 90% of the chromosomes in the population have the same fitness value';
            disp(S);
            break;
        end
    end
    %% elite, keep best 30%
    population = sortrows(population,31);
    fittest(k, 1) = population(end, 31); %save score of fittest in this generation k for plotting
    fitness_data(k) = population(end, 31);

    population_new = zeros(population_size,30);
   
    % elite replacement
    if true

        population_new(1:(0.3*population_size),:) = population(population_size-(0.3*population_size-1):population_size,1:30);
        population_new_num = (0.3*population_size);
    end
    %% general replacement
    % pls change this condition to true if you want to use general
    % elite is used by default because it offers better performance
    if false
        population_new_num = 1;
    end
    %% repeat until new population is full
    while (population_new_num < population_size)
        %% use a selection method and pick two chromosomes
        % Roulette Wheel Selection.
        weights = population(:,31)/sum(population(:,31));
        if selectionChoice == 1
            choice1 = RouletteWheelSelection(weights);
            choice2 = RouletteWheelSelection(weights);
        elseif selectionChoice == 2
            % Tournament Selection.
            choice1 = TournamentSelection(population(:,31));
            choice2 = TournamentSelection(population(:,31));
        elseif selectionChoice == 3
            % Linear Rank Selection
            choice1 = LinearRankSelection(population(:,31));
            choice2 = LinearRankSelection(population(:,31));
        end
        temp_chromosome_1 = population(choice1, 1:30);
        temp_chromosome_2 = population(choice2, 1:30);


        %% crossover operator
        if (rand < 0.8)
            % need to add you crossover code
            if crossoverChoice == 1
                % k point crossover, k = 1
                [temp_chromosome_1, temp_chromosome_2] = kPointCrossover(temp_chromosome_1, temp_chromosome_2);
            elseif crossoverChoice == 2
                % uniform crossover
                [temp_chromosome_1, temp_chromosome_2] = UniformCrossover(temp_chromosome_1, temp_chromosome_2);
            end
        end
        
        %% mutation operator
        if (rand < 0.3)
            if mutationChoice == 1
                % Flip Mutation
                temp_chromosome_1 = FlipMutation(temp_chromosome_1);
            elseif mutationChoice == 2
                % Insertion Mutation
                temp_chromosome_1 = InsertionMutation(temp_chromosome_1);
            end
        end
        if (rand < 0.3)
            if mutationChoice == 1
                % Flip Mutation
                temp_chromosome_2 = FlipMutation(temp_chromosome_2);
            elseif mutationChoice == 2
                % Insertion Mutation
                temp_chromosome_2 = InsertionMutation(temp_chromosome_2);
            end

        end
        %% put in new population, add first new chromosome
        population_new_num = population_new_num + 1;
        population_new(population_new_num,:) = temp_chromosome_1;
        % add second chromosome
        if (population_new_num < population_size)
            population_new_num = population_new_num + 1;
            population_new(population_new_num,:) = temp_chromosome_2;
        end
    end
    
    %% replace, last column not updated yet
    population(:,1:30) = population_new;
end

%% at end: evaluate fitness scores and rank them
for i = 1:population_size
    [population(i,31),~] = (simulate_ant(world_grid,population(i, 1:30)));%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
population = sortrows(population,31);
best_fitness = population(end,31);
toc;



% a plot showing the fitness score of the most-fit ant in each generation
hf = figure(1); set(hf,'Color',[1 1 1]);
hp = plot(1:Ngen,100*fitness_data/89,'r');
set(hp,'LineWidth',2);
axis([0 Ngen 0 100]); grid on;
xlabel('Generation number');
ylabel('Ant fitness [%]');
title('Ant fitness as a function of generation');
%a plot showing the trail of the most-fit ant in the final generation
% read the John Moir Trail (world)
filename_world = 'muir_world.txt'; 
world_grid = dlmread(filename_world,' ');
% display the John Moir Trail (world)
world_grid = rot90(rot90(rot90(world_grid)));
xmax = size(world_grid,2);
ymax = size(world_grid,1);
hf = figure(2); set(hf,'Color',[1 1 1]);
for y=1:ymax
    for x=1:xmax
        if(world_grid(x,y) == 1)
            h1 = plot(x,y,'sk');
            hold on
        end
    end
end
grid on
% display the fittest Individual trail
for k=1:size(trail,1)
    h2 = plot(trail(k,2),33-trail(k,1),'*m');
    hold on
end
axis([1 32 1 32])
title_str = sprintf('John Muri Trail - Hero Ant fitness %d%% in %d generation ',uint8(100*best_fitness/89), Ngen);
title(title_str)
lh = legend([h1 h2],'Food cell','Ant movement');
set(lh,'Location','SouthEast');
