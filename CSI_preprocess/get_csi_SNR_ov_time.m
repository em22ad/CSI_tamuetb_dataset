clear;
close all;
csi_trace = read_bf_file('../CSI_dataset_scripts/csi_ng_1_17-36-41.dat'); %Actual data collection Started after delay of roughly 6.5 seconds
csi2 = zeros(1,3,30);
TX_Antenna=1;
RX_Antenna=2; %1:3
%figure;
%hold on;
%for i=int16(size(csi_trace,1)/2):int16(size(csi_trace,1)/1)
%for i=1:int16(size(csi_trace,1)/2)

avg_over=100;
fp=zeros(18,15);
fp_rssi=zeros(6,15);
for i=1:avg_over %int16(size(csi_trace,1))
    csi_entry = csi_trace{i};
    if (size(csi_entry,2)>0) && (csi_entry.Nrx   == 3) && (csi_entry.Ntx   == 3)
        sprintf('%1.1f',csi_entry.timestamp_low/67978);    
        csi = get_scaled_csi(csi_entry(1,:,:));
        for rx=1:3
            xsh=(rx-1);
            l=1;
            for j=1:6
                for k=1:5
                    if (rx == 1)
                        fp_rssi(j,k+(5*xsh))=fp_rssi(j,k+(5*xsh))+csi_entry.rssi_a;
                    elseif (rx == 2)
                        fp_rssi(j,k+(5*xsh))=fp_rssi(j,k+(5*xsh))+csi_entry.rssi_b;
                    else
                        fp_rssi(j,k+(5*xsh))=fp_rssi(j,k+(5*xsh))+csi_entry.rssi_c;
                    end
                end
            end
        end
        %plot(db(abs(squeeze(csi2).')))
    end
end

for i=1:avg_over %int16(size(csi_trace,1))
    csi_entry = csi_trace{i}
    if (size(csi_entry,2)>0) && (csi_entry.Nrx   == 3) && (csi_entry.Ntx   == 3)
        sprintf('%1.1f',csi_entry.timestamp_low/67978);    
        csi = get_scaled_csi(csi_entry(1,:,:));
        for tx=1:3
            xsh=(tx-1);
            for rx=1:3
                ysh=(rx-1);
                l=1;
                csi2=csi(tx,rx,:);
                for j=1:6
                    for k=1:5
                        fp(j+(6*ysh),k+(5*xsh))=fp(j+(6*ysh),k+(5*xsh))+abs(csi2(1,1,l));
                        l=l+1;
                    end
                end
            end
        end
        %plot(db(abs(squeeze(csi2).')))
    end
end

fp=fp./100
fp_rssi=fp_rssi./100

%I = mat2gray(fp);
figure
%imshow(I)
imshow(fp.*2, [0 150]);

%I_rssi = mat2gray(fp_rssi);
figure
%imshow(I_rssi)
imshow(fp_rssi.*2, [0 150]);

%legend(sprintf('RX Antenna: %d RX Antenna: %d',TX_Antenna,RX_Antenna));
%xlabel('Subcarrier index');
%ylabel('SNR [dB]');
%hold off;