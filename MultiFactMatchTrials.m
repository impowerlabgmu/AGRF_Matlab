%MatchTrials
clear
clc

load('NewData_v3.mat')

[r,c,j] = size(ForceDataUPD2);
[rM,cM,jM] = size(MotionData);

for sheet = 1:j
    SheetFP = ForceDataUPD2(:,:,sheet);
    SheetMot = MotionData(:,:,sheet);
    count = 1;

%     nextMatch = 1;
%     countIMU = 1;

    for iF = 1:r

        for iM = 1:rM
            try
                X = matches(SheetMot{iM,2},SheetFP{iF,2});
            catch
                X = 0;
            end

            if X %This checks if they are the same kind of file (Fast, SS, Slow)
                 if SheetMot{iM,5} == SheetFP{iF,5} % This checks if they were moving in the same direction
                    if abs((SheetMot{iM,4} - SheetFP{iF,4}/10)) <= 5
                        %                     Matches(nextMatch,:,k) = [i,countIMU];
                        if iF <= iM
 
                        AllMatches(count,1:2,sheet) = [iM,iF];
                        count = count + 1;

                        %                     countFP = countFP + 1;
                        %                     nextMatch = nextMatch + 1;
                        end
                    end
                 end
            end
        end
    end

    CurrMatches = AllMatches(:,1:2,sheet);
    Z = find((CurrMatches(:,1)<CurrMatches(:,2)));
    CurrMatches(Z,:) = [];

    match = 1;

    while match  < length(CurrMatches)-1
        if CurrMatches(match,2) == CurrMatches(match+1,2)
            CurrMatches(match+1,:) = [];
        else
            match = match + 1;
        end
    end

    check = 2;

    while check  < length(CurrMatches)
        if CurrMatches(check,1) <= CurrMatches(check-1,1)
            CurrMatches(check,:) = [];
        else
            check = check + 1;
        end
    end


    FinalMatches{sheet} = CurrMatches;

end

save('MatchedTrials_v4.mat','FinalMatches')

