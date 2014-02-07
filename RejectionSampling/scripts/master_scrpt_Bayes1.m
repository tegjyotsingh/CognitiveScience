%Problem 1: Predict that Sprinkler is on given grass is wet and that the
%cloudy is valid
% The Simple Bayes Net1 has the form: cloudy->Sprinkler, Rain; Sprinkler,Rain -> Wetgrass 
%The Conditional probability tables going from F to T are given below to
%specify the conditional probabilities of the states.The Joint probability distribution is simlpified using Markov ASsumption
% as: P(C,S,R,W)= P(W|S,R) . P(S|C). P(R|C). P(C) 

%Bayes_Net represented as the parent of  a given node: -1 node is the root,
%other entries give the parent of that node
Bayes_net={-1, 1, 1 ,[2,3]};


%The Conditional Probability tables for the variable in the net
CPT_cloudy=[0.5 0.5];
CPT_sprinkler=[0.5 0.5; 0.9 0.1];
CPT_rain=[0.8 0.2; 0.2 0.8];
CPT_wetgrass=[1 0; 0.1 0.9 ; 0.1 0.9 ; 0.01 0.99];

%vector of variable values is given by [c s r w] where each variable can have 0/1 or
%-1. Each evidence cell array represnts a query that the Bayes net can be
%used to reply
conditioned_variables=[2];
observed_variables=[1 4];
evidence_vector=[1 1 -1 1];
evidence={conditioned_variables, observed_variables,evidence_vector};

%Number of runs
N=100;
[probability_xe,matched_samples,generated_samples]= rejectionsampling(Bayes_net, evidence,N,CPT_cloudy,CPT_sprinkler,CPT_rain,CPT_wetgrass);

%effect of changing N
vals_N=[10 100 1000 10000];
evaluated_probability=[];
for i=1:length(vals_N),
    [probability_xe,matched_samples,generated_samples]= rejectionsampling(Bayes_net,evidence,vals_N(i),CPT_cloudy,CPT_sprinkler,CPT_rain,CPT_wetgrass);
    evaluated_probability=[evaluated_probability probability_xe];
end

%plot errors: Theoretical value from evaluation= P(S=T|W=T,C=T)= 0.1304
theretical_value=0.1304;
errors= evaluated_probability-theretical_value;
errors=abs(errors);
plot(log10(vals_N),errors), xlabel('log of N values to the base 10'), ylabel('errors(Theoretical value - approximate from Rejection Sampling)'),title('Error values of Rejection Sampling  with change in number of samples');
%Output error values:
vals_N, errors