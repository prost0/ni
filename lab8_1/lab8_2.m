k1 = 0 : 0.025 : 1;
p1 = sin(4 * pi * k1);
t1 = -ones(size(p1));
k2 = 2.9 : 0.025 : 4.55;
%g = @(k)cos(-cos(k) .* k .* k + k);
g = @(k) 1.5*sin(-5 .* k .* k + 10 .* k - 5) + 0.4;
p2 = g(k2);
t2 = ones(size(p2));

R = {6; 7; 1};
P = [repmat(p1, 1, R{1}), p2, repmat(p1, 1, R{2}), p2, repmat(p1, 1, R{3}), p2];
T = [repmat(t1, 1, R{1}), t2, repmat(t1, 1, R{2}), t2, repmat(t1, 1, R{3}), t2];

Pseq = con2seq(P);
Tseq = con2seq(T);

net = distdelaynet({0: 4, 0: 4}, 10, 'trainoss');
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'tansig';
net.divideFcn = '';

net = configure(net, Pseq, Tseq);
[Xs, Xi, Ai, Ts] = preparets(net, Pseq, Tseq);

net.trainParam.epochs = 1000;
net.trainParam.goal = 1.0e-5;

net = train(net, Xs, Ts, Xi, Ai);

Y = net(Xs, Xi, Ai);

figure;
hold on;
grid on;
plot(cell2mat(Tseq), '-b');
plot([cell2mat(Xi) cell2mat(Y)], '-r');

Yc = zeros(1, numel(Xi) + numel(Y));
for i = 1 : numel(Xi)
    if Xi{i} >= 0
        Yc(i) = 1;
    else
        Yc(i) = -1;
    end
end
for i = numel(Xi) + 1 : numel(Y)
    if Y{i} >= 0
        Yc(i) = 1;
    else
        Yc(i) = -1;
    end
end


display(nnz(Yc == cell2mat(Tseq)) / length(Tseq) * 100)

R = {6; 3; 1};
P = [repmat(p1, 1, R{1}), p2, repmat(p1, 1, R{2}), p2, repmat(p1, 1, R{3}), p2];
T = [repmat(t1, 1, R{1}), t2, repmat(t1, 1, R{2}), t2, repmat(t1, 1, R{3}), t2];

Pseq = con2seq(P);
Tseq = con2seq(T);

[Xs, Xi, Ai, Ts] = preparets(net, Pseq, Tseq);

Y = net(Xs, Xi, Ai);

figure;
hold on;
grid on;
plot(cell2mat(Tseq), '-b');
plot([cell2mat(Xi) cell2mat(Y)], '-r');

Yc = zeros(1, numel(Xi) + numel(Y));
for i = 1 : numel(Xi)
    if Xi{i} >= 0
        Yc(i) = 1;
    else
        Yc(i) = -1;
    end
end
for i = numel(Xi) + 1 : numel(Y)
    if Y{i} >= 0
        Yc(i) = 1;
    else
        Yc(i) = -1;
    end
end

display(nnz(Yc == cell2mat(Tseq)) / length(Tseq) * 100)

