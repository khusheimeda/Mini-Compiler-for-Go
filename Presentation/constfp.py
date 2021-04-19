def cfp():
    f = open("icfg.txt",'r')
    data = f.readlines()
    data = data[1:]
    f.close()
    imc = list()

    for line in data:
        gay = line.split('|')
        imc.append({"op":gay[0],"ar1":gay[1],"ar2":gay[2],"res":gay[3]})
    #print(imc)

    f = open("st.txt",'r')
    data = f.readlines()
    data = data[1:]
    f.close()
    st = list()

    for line in data:
        gay = line.split(':')
        st.append({"name":gay[0],"type":gay[1],"dtype":gay[2],"val":gay[3].strip('\n')})
    #print(st)

    def getVal (st,var):
        for i in st:
            if var == i["name"]:
                return int(i["val"]) if not i["val"] == '' else None
        return None

    def setVal (st,var,val):
        for i in st:
            if var == i["name"]:
                tmp = i
                tmp["val"] = val
                st[st.index(i)] = tmp
        return None

    for line in imc:
        if "#" in line["ar1"] and line["op"] == "=":
            tmpToBeUpdated = line["res"] #t4
            varibleName = line["ar1"] #a
            valueOfVarible = None
            # go up to find vAL OF VARIABLE
            for j in imc:
                if j["res"] == varibleName: #line 3
                    break
            # j["ar1"] has tmp value
            valueOfVarible = getVal(st,j["ar1"]) #t0
            #print(varibleName,tmpToBeUpdated,valueOfVarible,j)
            setVal(st,tmpToBeUpdated,valueOfVarible)

    for test in range(1):
        for line in imc:
            try:
                if line["op"] != "=" and line["op"] != "Lable" and line["op"] != "goto" and line["op"] != "ifFalse" and line["op"] != "if":
                    arg1 = line["ar1"]
                    arg2 = line["ar2"]
                    val1 = getVal(st,arg1)
                    val2 = getVal(st,arg2)
                    newLine = dict()
                    newLine["res"] = line["res"]
                    newLine["op"] = line["op"] 
                    newLine["ar1"] = line["ar1"] 
                    newLine["ar2"] = line["ar2"] 
                    if val1 != None and val2 != None:
                        if line["op"] == "*" and (val1 == "0.0" or val1 == "0" or val2 == "0.0" or val2 == "0"):
                            newLine["op"] = "="
                            newLine["ar1"] = 0
                            newLine["ar2"] = ''
                            setVal(st,newLine["res"],newLine["ar1"])    
                            continue
                        newLine["op"] = "="
                        newLine["ar1"] = eval(str(val1)+line["op"]+str(val2)) #changed
                        newLine["ar2"] = ''
                        setVal(st,newLine["res"],newLine["ar1"])
                    imc[imc.index(line)] = newLine
                else:
                    val = getVal(st,line["ar1"])
                    if True:
                        newLine = dict()
                        newLine["res"] = line["res"]
                        newLine["op"] = "=" 
                        newLine["ar1"] = val
                        newLine["ar2"] = ''
                        imc[imc.index(line)] = newLine

            except Exception as TypeError:
                continue

    for line in imc:
        if line["op"] == "=":
            setVal(st,line["res"],line["ar1"])


    f=open("const_fp.txt","w")
    print("########################## OPTIMIZED IC ###################################")
    f.write("########################## OPTIMIZED IC ###################################\n\n")
    print()
    print()
    f=open("const_fp.txt","w")
    line=""

    print("Oper\t|Arg1\t|Arg2\t|Result|")
    for i in imc:
        if i["ar1"]!=None:
            print (i["op"],"\t|",i["ar1"],"\t|",i["ar2"],"\t|",i["res"])
            line=str(i["op"])+"\t|"+str(i["ar1"])+"\t|"+str(i["ar2"])+"\t|"+str(i["res"])+"\n"
            f.write(line)

    print()
    print()



    line=""
    f.write("\n\n")
    print("name\t|Value\t|")
    for i in st:
        print (i["name"],"\t|",i["val"],"\t|")
        line= str(i["name"])+"\t|"+str(i["val"])+"\t|"+"\n"
        f.write(line)
    f.close()

if __name__=="__main__":
    cfp()

