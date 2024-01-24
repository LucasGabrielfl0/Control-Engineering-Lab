function Fun_Calc(time, yt)
    yss =yt(length(yt));
    index_array= find(yt==yss);
    Tr=time(index_array(1)); 

%------------------  Ts (using the 2% criteria)
    index =(yt<1.2*yss & yt>0.8*yss);
    for i= length(index): -1: 1
        if(index(i)==0)
            index_Ts=i+1;
            Ts_aux= time(index_Ts);
            break
        end
    end
    Ts = Ts_aux;

    %------------------ Tp
    %searches y(t) for its maximum value,variable "i" is the value's index
    %uses that index to find the peak time
    [Ymax,i]=max(yt);
    Tp= time(i);

    %------------------ PO
    PO= (Ymax-yss)*100/yss;
    
    if(PO<0.5) %SuperAmortecido/ criticamente Amortecido
        X = ['Tempos:     Tr: ',num2str(Tr),',    Ts: ',num2str(Ts)];
    else %SubAmortecido
        X = ['Tempos:     Tr: ',num2str(Tr),',    Ts: ',num2str(Ts),',   Tp: ',num2str(Tp), ',   P0: ',num2str(PO),'%'];
    end
    disp(X);

end
