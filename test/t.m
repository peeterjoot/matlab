
figure, close                    # must do this first, otherwise plot is empty
plot(1:10)                       # usual plotting
print file                       # save the figure as file.ps
saveas(gcf, 'file.eps', 'eps2c') # saveas aslo works
exit                  
