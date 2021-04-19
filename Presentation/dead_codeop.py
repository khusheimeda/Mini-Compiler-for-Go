def dco():
    #don't reintialise variables
    f = open("icfg.txt",'r')
    data = f.readlines()
    data = data[1:]
    f.close()
    imc = list()

    for line in data:
        gay = line.split('|')
        imc.append({"op":gay[0],"ar1":gay[1],"ar2":gay[2],"res":gay[3]})

    f = open("st.txt",'r')
    data = f.readlines()
    data = data[1:]
    f.close()
    st = dict()

    for line in data:
        gay = line.split(':')
        if gay[0] not in st:
            st[gay[0]]={"name":gay[0],"type":gay[1],"dtype":gay[2],"val":gay[3].strip('\n')}
        
    #print(st)

    class Quad:

        def __init__(self,quadruple):
            self.quadruple = quadruple
            self.l = []
        
    #dict_obj=dict()
    p=0

    dead=dict()
    flag=0
    for line in imc:
        #print(type(line['ar1']))
        if line['res'] not in  list(dead.keys()):
            try:
                if line['res'] == '' and st[line['ar1']]['type']=="TempVariable":
                    line['res'] = "P"+str(p)
                    p+=1
                    print(line['ar1'])
                    
            except:
                line['ar1'].strip('')
                line['res'] = "P"+str(p)
                p+=1
                
            dead[line['res']]=Quad(line)
        
        if line['ar1'] in dead.keys():
            dead[line['ar1']].l.append(line['res'])
        if line['ar2'] in dead.keys():
            dead[line['ar2']].l.append(line['res'])

    for j in dead:
        print(j,dead[j].l,dead[j].quadruple,end="\n")
    print("\n\n")


    not_dead_code=dead
    dead_code=list()

    key=list(dead.keys())
    key.reverse()
    #print(key)



    for i in key:
        
        if dead[i].l != [] and dead[i].quadruple['op']!='Param':
            
            for j in dead[i].l:
                
                if dead[j].l == [] and dead[j].quadruple['op']!='ifFalse' and dead[j].quadruple['op']!='Param':
                    not_dead_code[i].l.remove(j)
                    dead_code.append(j)

    

    # for j in dead_code:
    #      print(j,dead_code[j].l,dead_code[j].quadruple,end="\n")
    # print("\n\n")

    f=open("deadcode_optimised.txt",'w')
    line=""
    for j in not_dead_code:
        q=not_dead_code[j].quadruple
        if not_dead_code[j].l!=[] :
            
            #print(j,dead_code[j].quadruple,dead_code[j].l,end="\n")
            
            
            if q["op"] != "=":
                print(q["res"],"=",q["ar1"],q["op"],q["ar2"])
                line= q["res"]+" = "+q["ar1"]+" "+q["op"]+" "+q["ar2"]+"\n"
                
            else:
                print(q["res"],q["op"],q["ar1"])
                line= q["res"]+" "+q["op"]+" "+q["ar1"]+"\n"
            f.write(line)
    

        elif not_dead_code[j].quadruple['op']=="Param":# and q["ar1"][0]!='"':
                print(q["op"],q["ar1"])
                line = q["op"]+" "+q["ar1"]+"\n"
                f.write(line)
    
    f.close()

if __name__=="__main__":
    dco()
       
