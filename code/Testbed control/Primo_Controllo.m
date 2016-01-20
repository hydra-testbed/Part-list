function Primo_controllo()    
    
    global a;
    a = arduino('COM3');


    %SENSORI DI PRESSIONE
    p_sensor_1 = 1; %analogico
    p_sensor_2 = 0; %analogico

    %MICROPOMPA
    transistorPin = 4; %digitale 
    %connected to the base of the transistor

    %SENSORI DI FLUSSO 
    f_sensor_A = 2; %digitale
    f_sensor_B = 3; %digitale

    sensorInterrupt_A = 0; 
    sensorInterrupt_B = 1;

    calibrationFactor = 4.9;
    
    pulseCount_0 = 0;
    pulseCount_1 = 0;
    
    %flowRate_A = 0.0;
    %flowRate_B = 0.0;
    
    %flowMillilitres_A = 0;
    totalMillilitres_A = 0;
    %flowMillilitres_B = 0;
    totalMillilitres_B = 0;
        
    %oldTime = 0;
    oldTime = tic;
    
    %setup
  
        a.pinMode(transistorPin,'output'); 
  
        a.pinMode(f_sensor_A, 'input');
        a.pinMode(f_sensor_B, 'input');
  
        a.digitalWrite(f_sensor_A, 1); % prendo i fronti di salita
        a.digitalWrite(f_sensor_B, 1);
  
        level_0 = SP_AutoZero(p_sensor_1); %passo il pin come parametro
        level_1 = SP_AutoZero(p_sensor_2); 
  
%         a.attachInterrupt(sensorInterrupt_A, pulseCounter_0(pulseCount_0), 0);
%         a.attachInterrupt(sensorInterrupt_B, pulseCounter_1(pulseCount_1), 0);



    %loop

        while(1)
            
                %time = tic;
                time = toc;
                                
                if((time - oldTime) > 1)

                    %Diasabilito gli interrupt mentre calcolo il flow rate e invio il valore
                    %a.detachInterrupt(sensorInterrupt_A);
                    %a.detachInterrupt(sensorInterrupt_B);

                    flowRate_A = ((1 / (time - oldTime)) * pulseCount_0) / calibrationFactor;
                    flowRate_B = ((1 / (time - oldTime)) * pulseCount_1) / calibrationFactor;

                    %    Poichè il loop non si completa esattamente in un secondo, calcoliamo i millisecondi
                    %    che passano dall'unlima esecuzione e usiamo questi per calcolare l'output.
                    %    Utilizziamo il fattore di calibrazione per scalare l'output sulla base del numero
                    %    di impulsi al secondo (abbiamo modificato da 1000 ms = 1 sec a 100 millisecondi )
                    %    per determinare la misura (in litri/ minuto) derivante dal sensore

                    oldTime = tic;

                    %    Dividiamo il flow rate in litri/minuto per 60 per ottenere il totale di litri 
                    %    passati attraverso il sensore in tale intervallo (100 millisecondi) e dopo
                    %    moltiplichiamo per 1000 per convertire in millilitri

                    flowMillilitres_A = (flowRate_A / 60) * 1000; % con 1000=1 sec
                    totalMillilitres_A = totalMillilitres_A + flowMillilitres_A;

                    flowMillilitres_B = (flowRate_B / 60) * 1000; % con 1000= 1 sec
                    totalMillilitres_B = totalMillilitres_B + flowMillilitres_B;


%                     frac_A = 0;
%                     frac_B = 0;

                    if(level_0 < 0)
                        level_0 = 0;
                    end
                    
                    if(level_1 < 0)
                        level_1 = 0;
                    end


                    print('SENSORE DI FLUSSO A: ');
                    print(floor(flowRate_A));
                    print('.');
                    parte_intera_A = floor(flowRate_A);
                    frac_A = flowRate_A - parte_intera_A * 10;
                    print(frac_A);
                    print('L/min');
                    print('   '); 
                    disp(flowRate_A);


                    print('SENSORE DI FLUSSO B: ');
                    print(floor(flowRate_B));
                    print('.');
                    parte_intera_B = floor(flowRate_B);
                    frac_B = flowRate_B - parte_intera_B * 10;
                    print(frac_B);
                    print('L/min');

                    test_pompa();

                    pulseCount_0 = 0;
                    pulseCount_1 = 0;

                    a.attachInterrupt(sensorInterrupt_A, pulseCounter_0(pulseCount_0), 0);
                    a.attachInterrupt(sensorInterrupt_B, pulseCounter_1(pulseCount_1), 0);
    
                end
        end
end
    
    
    function test_pompa()
        global a;
        a.analogWrite(transistorPin, 200); %delay(10);
    end
    
    function [pulseCount_0] = pulseCounter_0(pulseCount_0)
        pulseCount_0 = pulseCount_0 + 1;
    end

    function [pulseCount_1] = pulseCounter_1(pulseCount_1)
        pulseCount_1 = pulseCount_1 + 1;
    end
  