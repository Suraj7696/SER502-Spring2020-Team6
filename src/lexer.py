def Lexer(filename):
    assert filename[-4:] == 'SARS', "Unsupported File Extension"

    tokenlist = []
    token = ""

    specialChar = ['/', '*', '+', '-', '=','~','==','<','>',';','(',')','>=','<=',',','"']
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
        var = []    
        i = 0
        x = ''
        # print(token)
        while i < len(token):
            if x == '(ot':
                tokenlist.append('(')
                tokenlist.append('not')
                token = token[i+1:]
                i = 0
                x = ''
            elif x == 'not':
                tokenlist.append(x)
                token = token[i+1:]
                i = 0
                x = ''
            elif x == '(nt':
                tokenlist.append('(')
                tokenlist.append('int')
                var = []
                token = token[i:]
                i = 0
                x = ''
            else:
                
                x += token[i]
            if token[i] in specialChar:
                if token[:i] != '':
                    var.append(token[:i])
                    # print(token[:i])
                    # print(var)
                if token[i] == '<' or token[i] == '>' or token[i] == '=':
                    try:
                        if token[i+1] == '=':
                            ts = token[i]+token[i+1]
                            var.append(ts)
                            # print(token[i:])
                            i += 2
                            # print(token[i:])
                    except:
                        continue
                if token[i] == '+':
                    try:
                        if token[i+1] == '+':
                            ts = token[i]+token[i+1]
                            var.append(ts)
                            # print(token[i:])
                            i += 2
                            # print(token[i:])
                    except:
                        continue
                if token[i] == '-':
                    try:
                        if token[i+1] == '-':
                            ts = token[i]+token[i+1]
                            var.append(ts)
                            # print(token[i:])
                            i += 2
                            # print(token[i:])
                    except:
                        continue
                var.append(token[i])
                # print(var)
                try:
                    token[i:] == int(token[i:])
                    # print(token[i:])
                    var.append(token[i+1:])
                    token = token[i+4:]
                except ValueError:
                    try:
                        if token[i+1] == '"':
                            print(token[i+1:])
                            count = 1
                            index = i+2
                            string = ''
                            while count != 2:
                                if token[index] != '"':
                                    string += token[index]
                                    index += 1
                                else:
                                    var.append('"')
                                    var.append(string)
                                    var.append('"')
                                    token = token[index:]
                                    i = 0
                        else:
                            token = token[i+1:]
                            i = 0
                    except:
                        token = token[i+1:]
                        # print(var)
                        i = 0
            i+=1
        # print(var)
        # print(token)
        for i in var:
            try:
                i == int(i)
                tokenlist.append(int(i))
            except:
                tokenlist.append(i)
        
        if token != '':
            tokenlist.append(token)
        
        token = ''

    return tokenlist


if __name__ == "__main__":
    tokens = Lexer("string.SARS")
    print(tokens)
