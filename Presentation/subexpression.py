def sbe():
    f = open("icfg.txt", 'r')
    data = f.readlines()
    data = data[1:]
    f.close()

    assign = dict()
    operator = dict()
    res = []
    op = ['+', '*']


    def in_assign_lists(ele):
        for i in assign:
            if ele in assign[i]:
                return i
        return None


    def same_tuple(arg1, symbol, arg2):
        for i in operator:
            if operator[i][0] == arg1 and operator[i][1] == symbol and operator[i][2] == arg2:
                return i
        else:
            return None


    for line in data:
        l_copy = line
        line = line.split('|\t')
        if line[0] == '=':
            # ar1 is a variable
            if line[1].find('#') != -1:
                # adding to assign
                if line[1] in assign.keys():
                    assign[line[1]].append(line[3])
                else:
                    assign[line[1]] = [line[3]]
                res.append(l_copy)

                # res.append('\t|'.join([line[0], line[1], '', assign[line[1]][0]]))

            # result is a variable
            elif line[3].find('#') != -1:
                # temporary that variable is equal to is not equal to another temporary
                if type(operator[line[1]]) is tuple:
                    res.append(l_copy)
                # temporary that variable is equal to is equal to another temporary
                else:
                    res.append('|\t'.join([line[0], operator[line[1]], '', line[3]]))

        elif line[0] in op:
            arg1 = in_assign_lists(line[1])
            arg2 = in_assign_lists(line[2])

            # arg1 and arg2 are keys in assign
            if arg1 is not None and arg2 is not None:
                operator_key = same_tuple(arg1, line[0], arg2)
                # tuple exists in operator
                if operator_key is not None:
                    operator[line[3]] = operator_key
                    res.append('|\t'.join(['=', operator[line[3]], '', line[3]]))
                # temporary that variable is equal to is equal to another temporary
                else:
                    operator[line[3]] = (arg1, line[0], arg2)
                    res.append(l_copy)

            elif arg1 is not None and arg2 is None:
                if line[2] in operator.keys():
                    # ar2 is a unique tuple
                    if type(operator[line[2]]) is tuple:
                        operator[line[3]] = (arg1, line[0], line[2])
                        res.append(l_copy)
                    # ar2 is same as another temporary variable
                    else:
                        operator[line[3]] = (arg1, line[0], operator[line[2]])
                        res.append('|\t'.join([line[0], assign[arg1][0], operator[line[2]], line[3]]))
                else:
                    operator[line[3]] = (arg1, line[0], line[2])
                    res.append(l_copy)

            elif arg1 is None and arg2 is not None:
                if line[1] in operator.keys():
                    # ar1 is a unique tuple
                    if type(operator[line[1]]) is tuple:
                        operator[line[3]] = (line[1], line[0], arg2)
                        res.append(l_copy)
                    # ar1 is same as another temporary variable
                    else:
                        operator[line[3]] = (operator[line[1]], line[0], arg2)
                        res.append('|\t'.join([line[0], operator[line[1]], assign[arg2][0], line[3]]))
                else:
                    operator[line[3]] = (line[1], line[0], arg2)
                    res.append(l_copy)

            else:
                zero = line[1]
                two = line[2]
                if line[1] in operator.keys():
                    # ar1 is a unique tuple
                    if type(operator[line[1]]) is not tuple:
                        zero = operator[line[1]]
                if line[2] in operator.keys():
                    # ar2 is a unique tuple
                    if type(operator[line[2]]) is not tuple:
                        two = operator[line[2]]
                '''
                if zero==line[1] and two==line[2]:
                    operator[line[3]] = (zero, line[0], two)
                    res.append(l_copy)
                else if zero==operator[line[1]] and two==line[2]:
                    operator[line[3]] = (zero, line[0], two)
                    res.append('|\t'.join([line[0], zero, two, line[3]]))
                else if zero==line[1] and two==operator[line[2]]:
                    operator[line[3]] = (zero, line[0], two)
                    res.append('|\t'.join([line[0], zero, two, line[3]]))
                else:
                    operator[line[3]] = (zero, line[0], two)
                    res.append('|\t'.join([line[0], zero, two, line[3]]))
                '''
                operator[line[3]] = (zero, line[0], two)
                res.append('|\t'.join([line[0], zero, two, line[3]]))

            if type(operator[line[3]]) is tuple:
                # print('for tuple', operator[line[3]])
                for i in list(operator.keys())[:-1]:
                    if operator[i] == operator[line[3]]:
                        # print('same i', i, operator[i])
                        operator[line[3]] = i
                        res[-1] = ('|\t'.join(['=', i, '', line[3]]))
                        break

        else:
            res.append(l_copy)
        # print('assign', assign)
        # print('operator', operator)
        # print()

    #print('res')
    f=open("subexpression.txt","w")
    #print(res)
    for quad in res:
        print(quad)
        f.write(quad)
    f.close()

if __name__=="__main__":
    sbe()