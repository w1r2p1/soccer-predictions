function [tTree mTree mi] = optimizeRatings(tTree, mTree, mi, ...
    winTiesRatio, isOptimized)
  qTCostRatio = 0.01;
  rOptions = RatingsOptions(qTCostRatio, winTiesRatio);
  rOutput = RatingsOutput(0, zeros(1, 8));
  nu = 0.7613;
  lambda = 0.3008;
  k = 1.1789;
  homeAdvantage = 0.8591;
  qWeight = 0.092;
  tWeight = 0.2026;
  x = [nu lambda k homeAdvantage qWeight tWeight];
  
  if (isOptimized)
    options = optimset('Display', 'iter', 'TolFun', 0.1, 'TolX', 0.1);
    f = @(x) modelRatings(x, tTree, mTree, mi, rOptions, rOutput);
    x = fminsearch(f, x, options)
  end
  
  [y tTree mTree mi rOptions rOutput] = modelRatings(x, ...
      tTree, mTree, mi, rOptions, rOutput);
  display(rOutput);
  display(cell2mat(values(rOptions.contestWeights)));
end

function [y tTree mTree mi rOptions rOutput] = modelRatings(x, ...
    tTree, mTree, mi, rOptions, rOutput)
  rOptions = rOptions.update(x(1), x(2), x(3), x(4), x(5), x(6));
  [tTree mTree mi rOptions rOutput] = rateTeams(tTree, mTree, mi, ...
      rOptions, rOutput);
  y = rOutput.results(2) ^ 2;
end
