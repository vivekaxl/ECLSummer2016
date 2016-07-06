MAC_Struct2DS(RecStruct,ResName) := MACRO
  #EXPORTXML(out, RecStruct);
  #DECLARE(Ndx);
  #SET (Ndx, 0)
  #DECLARE(OutStr);
  #SET(OutStr,#TEXT(Resname) + ' := DATASET([')
  #FOR (out)
    #FOR (Field) 
      #SET (Ndx, %Ndx% + 1)
      #IF (%Ndx% > 1)
        #APPEND(OutStr,',') 
      #END
      #APPEND(OutStr,'{\'' + %'{@label}'% + '\',\'' + %'{@ecltype}'% + '\'}') 
    #END
  #END
   %'OutStr'%  //show the generated code
  //%'OutStr%;      //generate the code for use
ENDMACRO;

weatherRecord := RECORD
	INTEGER id;
	INTEGER outlook;
	INTEGER temperature;
	INTEGER humidity;
	INTEGER windy;
	INTEGER play;
END;
weather_Data := DATASET([
{1,0,0,1,0,0},
{2,0,0,1,1,0},
{3,1,0,1,0,1},
{4,2,1,1,0,1},
{6,2,2,0,1,0},
{7,1,2,0,1,1},
{8,0,1,1,0,0},
{9,0,2,0,0,1},
{10,2,1,0,0,1},
{11,0,1,0,1,1},
{12,1,1,1,1,1},
{13,1,0,0,0,1},
{14,2,1,1,1,0}],
weatherRecord);

MAC_Struct2DS(weatherRecord,weather_Data);
//ResultDS;

#DECLARE(out);
#EXPORT(out, weather_Data);

LOADXML(%'out'%, 'Fred');
#DECLARE(OutStr);
#SET(OutStr,'train_data_independent := TABLE(raw_train_data,{')
#FOR (Fred)
 #FOR (Field)
		#IF ((%'{@name}'% <> 'id') AND (%'{@name}'% <> 'play')) 
			#APPEND(OutStr,%'{@name}'% + ',') 
		#END
 #END
#END
#APPEND(OutStr,'});') 
%'OutStr'%
						