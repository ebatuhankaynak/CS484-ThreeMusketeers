function ro = calc_ro(nSetM, nSetN, nLabels)
Tm = nSetM;
Tn = nSetN;
T = nLabels;

alpha = -log2((Tm + Tn) / T);
lambda = 6;
sigma = 0.1;
ro = 1 / (1 + exp((-(alpha - lambda) / sigma)));
end