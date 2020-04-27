def Lexer(filename):
    assert filename[-4:] == 'SARS', "Unsupported File Extension"

    tokenlist = []
    token = ""

    specialChar = ['/', '*', '+', '-', '=','~','==','<','>',';','(',')','>=','<=',',']
    words = ['begin','end','int','string','print','if','while','bool']

    with open(filename, 'r') as grabber:
        lines = grabber.readlines()

    for line in lines:
        for i in line:
            if i == '\n':
                continue
            if i == '\t':
                continue
            elif i == ' ':
                continue
            else:
                token += i
        # This is for word parsing
        each = ''
        for i in range(len(token)):
            if each in words:
                tokenlist.append(each)
                token = token[i:]
                break
            if each not in words:
                each += token[i]
            else:
                print(each)
                continue
        
        
        cond = ''
        i = 0
        while i < len(token):
            if cond == 'for':
                tokenlist.append(cond)
                token = token[i:]
                i = 0
                if token[i] != '(':
                    for j in range(len(token)):
                        try:
                            if token[j] == 'n' and token[j-1] == 'i':
                                ls = token[:j-1]
                                bs = 'in'
                                rs = 'range'
                                tokenlist.append(ls)
                                tokenlist.append(bs)
                                tokenlist.append(rs)
                                token = token[j+6:]
                        except:
                            continue
                break
            else:
                cond += token[i]
            i+=1
 