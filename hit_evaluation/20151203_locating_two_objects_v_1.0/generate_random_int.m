function [ r ] = generate_random_int(number, lower_bound, upper_bound)
    r = randperm(upper_bound - lower_bound, number);
end
