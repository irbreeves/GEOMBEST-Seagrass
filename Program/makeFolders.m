function makeFolders(LastInput)
%makeFolders Makes Input/Output folders

for i = 2:LastInput
    InName = strcat('C:/GEOMBEST+/Input',num2str(i));
    OutName = strcat('Output',num2str(i));
    copyfile ('C:/GEOMBEST+/Input1', InName)
    mkdir ('C:/GEOMBEST+', OutName)
end

