function [] = checkplots(FP1,FP2,FP3,FP4)

tiledlayout(2,3)
nexttile
plot(FP3)
title('1')
nexttile
plot(FP2)
title('2')
nexttile
plot(FP1)
title('3')
nexttile
plot(FP4)
title('4')
nexttile
plot(FP3+FP2)
title('12')
nexttile
plot(FP1+FP2)
title('23')

end