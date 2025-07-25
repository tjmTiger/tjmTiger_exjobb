function  G = sfg(n, alpha, beta, gamma, delta_in, delta_out, seed, create_using)
%     Gustav: This implementation is based on a python implementaion from 
%     https://networkx.github.io/documentation/latest/reference/generators.html
%
%     Returns a scale-free directed graph.
% 
%     Parameters
%     ----------
%     n : integer
%         Number of nodes in graph
%     alpha : float 
%         Probability for adding a new node connected to an existing node
%         chosen randomly according to the in-degree distribution.
%     beta : float
%         Probability for adding an edge between two existing nodes.
%         One existing node is chosen randomly according the in-degree 
%         distribution and the other chosen randomly according to the out-degree 
%         distribution.     
%     gamma : float
%         Probability for adding a new node conecgted to an existing node
%         chosen randomly according to the out-degree distribution.
%     delta_in : float
%         Bias for choosing ndoes from in-degree distribution.
%     delta_out : float
%         Bias for choosing ndoes from out-degree distribution.
%     create_using : graph, optional (default MultiDiGraph)
%         Use this graph instance to start the process (default=3-cycle).
%     seed : integer, optional
%         Seed for random number generator
% 
%     Examples
%     --------
%     Create a scale-free graph on one hundred nodes::
% 
%     >>> G = nx.scale_free_graph(100)
%   
%     Notes
%     -----
%     The sum of ``alpha``, ``beta``, and ``gamma`` must be 1.
% 
%     References
%     ----------  
%     .. [1] B. Bollob?s, C. Borgs, J. Chayes, and O. Riordan,
%            Directed scale-free graphs,
%            Proceedings of the fourteenth annual ACM-SIAM Symposium on
%            Discrete Algorithms, 132--139, 2003.



%------------------------------------------------------------------%
% Default parameters:

% delta_in=1;
% delta_out=1;
% create_using=false;
% seed=false;


% if isempty(create_using)
%     % start with 10-cycle
%     G = speye(9);
%     G = [[sparse(1,9) 1];[G sparse(9,1)]];
% else
%     % keep existing graph
%     G = create_using;
% end

switch nargin
    case 4
        G = speye(9);
        G = [[sparse(1,9) 1];[G sparse(9,1)]];
        delta_in = 1;
        delta_out = 1;
    case 5
        G = speye(9);
        G = [[sparse(1,9) 1];[G sparse(9,1)]];
    case 6
        G = speye(9);
        G = [[sparse(1,9) 1];[G sparse(9,1)]];
    case 7
        rng(seed);
        G = speye(9);
        G = [[sparse(1,9) 1];[G sparse(9,1)]];
    case 8
        G = create_using;
    otherwise
        disp('input argument invalid')
end

if alpha < 0
    disp('alpha must be >= 0.')
end
if beta < 0
    disp('beta must be >= 0.')
end
if gamma < 0
    disp('gamma must be >= 0.')
end

if abs(alpha+beta+gamma - 1)>1e-10
    disp('alpha+beta+gamma must equal 1.')
end
        
% G.name="directed_scale_free_graph(%s,alpha=%s,beta=%s,gamma=%s,delta_in=%s,delta_out=%s)"%(n,alpha,beta,gamma,delta_in,delta_out)

% seed random number generated (uses None as default)
% random.seed(seed)

while size(G,1) < n
    r = rand();
    
    n_now = size(G,1);
    % random choice in alpha,beta,gamma ranges
    if r<alpha
        % alpha
        % add new node v
        G = [G sparse(n_now,1);sparse(1,n_now+1)];
        v = n_now+1;
        % choose w according to in-degree and delta_in
        w = choose_node(G, sum(G,1),delta_in);
    elseif r < alpha+beta
        % beta
        % choose v according to out-degree and delta_out
        v = choose_node(G, sum(G,2),delta_out);
        % choose w according to in-degree and delta_in
        w = choose_node(G, sum(G,1),delta_in);
    else
        % gamma
        % choose v according to out-degree and delta_out
        v = choose_node(G, sum(G,2),delta_out);
        % add new node w
        G = [G sparse(n_now,1);sparse(1,n_now+1)];
        w = n_now+1;
    end
    G(v,w) = 1;

end

% GL: Remove self-loops
for i = 1:n
    G(i,i) = 0;
end

G = digraph(G); % matrix form
end

function i = choose_node(G,distribution,delta)
    cumsum_ = cumsum(distribution+delta);
    cumsum_ = cumsum_./cumsum_(end);
    % normalization 
%     psum=sum(distribution) + delta*length(distribution);
%     distribution+delta
    r=rand();
%     for i = 1:length(distribution)
%         cumsum_ = cumsum_ + (distribution(i)+delta)/psum;
%         if r < cumsum_
%             break
%         end
%     end
    i = find(r<cumsum_,1);
end