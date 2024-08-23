%% Using Any set of Coefficients for Regression, reconstruct the GRF from the inputs, 
% calculate residuals from the new curve, and calulate R-squared for each trial.

function [RSquared, RMSE, maxRecon, minRecon] = Calc_RSquared(Coeffs,X,y,display)
    Reconstructed = X*Coeffs';
    maxRecon = max(Reconstructed); minRecon = min(Reconstructed);

    Residuals = y - Reconstructed;
    mean_y = mean(y);
    
    SSR = sum(Residuals.^2);
    SST = sum((y - mean_y).^2);
    
    RSquared = 1 - (SSR/SST);

    RMSE = (sqrt((sum(Residuals.^2)/length(Residuals))))/(max(y)-min(y));

    if display == 1
    tiledlayout(1,3)
    nexttile
    hold on
    plot(y,'-','Color','blue')
    plot(Reconstructed,'--','Color','red')
    hold off
    nexttile
    plot(X(:,2:3))
    legend('Hip','Knee')
    nexttile
    plot(X(:,4:5))
    end
    
end
