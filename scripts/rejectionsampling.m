
%Rejection Sampling technique of MCMC is used to see if the approximate
%solution approaches the real solution
%Rejection Sampler for data X, evidence e and Number of turns N
function [probability_xe,matched_samples,generated_samples]= rejectionsampling(Bayes_net,evidence,N,CPT_cloudy,CPT_sprinkler,CPT_rain,CPT_wetgrass)
%X is the data consisting of 2^4=16 samples
% e is the evidence given as a cell of the form {x[],y[],z[]}, where x is the vector of array indices
%denoting variables which are to be conditioned on the variable with
%given in y. z is a vector which denotes T/F values for each of
%the variables in the network. A value -1 here denotes that the variable is
%nto a part of x[] or y[] and as such needs to be marginalized. 

count_xe=0;%Count of (x,e)
count_e=0;%count of evidence
sample=[];
matched_samples=[];
generated_samples=[];
conditioned_variables=evidence{1};
observed_variables=evidence{2};
evidence_vector=evidence{3};

%repeat till N trials
for i=1:N,
    sample=zeros(1,4);
    %generate sample based on conditional probabilities
    probability=CPT_cloudy(2);
    random_flip=coin_flip(probability);
    sample(1)=random_flip;
    probability=CPT_rain(sample(Bayes_net{3})+1,2);
    random_flip=coin_flip(probability);
    sample(3)=random_flip;
    probability=CPT_sprinkler(sample(Bayes_net{2})+1,2);
    random_flip=coin_flip(probability);
    sample(2)=random_flip;
    %converting three variable to two variable table lookup
    probability=CPT_wetgrass((sample(Bayes_net{4}(1))+ 2*sample(Bayes_net{4}(2)))+1,2);
    random_flip=coin_flip(probability);
    sample(4)=random_flip;
    generated_samples=[generated_samples; sample];
    %check if evidence and conditional probabilities are present
    if sample(observed_variables)==evidence_vector(observed_variables),
        count_e=count_e+1;
        if sample(conditioned_variables)==evidence_vector(conditioned_variables),
            count_xe=count_xe+1;
            matched_samples=[matched_samples ; sample];
        end
    end
end
probability_xe=count_xe/count_e;
end

%Function to randomly return 0/1, based on given probability of 1
function discrete_value= coin_flip(probability)
random_value=rand;
discrete_value=0;
if random_value<probability,
    discrete_value=1;
end
end