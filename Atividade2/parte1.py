import sys
import re

# Definições de tokens para a linguagem da Parte 1 (Linguagem C simplificada)
TOKEN_TYPES_P1 = {
    'KEYWORD': r'\b(int|float|if|else|while|for|return|void|char|double|bool|true|false)\b',
    'INTEGER': r'\b\d+\b',
    'REAL': r'\b\d+\.\d+\b',
    'STRING': r'"[^"\n]*"',
    'OPERATOR': r'\+|-|\*|/|%|==|!=|<=|>=|<|>|&&|\|\||!|=',
    'DELIMITER': r'\(|\)|\{|\}|\[|\]|;|,',
    'IDENTIFIER': r'\b[a-zA-Z_][a-zA-Z0-9_]*\b',
    'COMMENT_LINE': r'//.*',
    'COMMENT_BLOCK': r'/\*[\s\S]*?\*/',
    'WHITESPACE': r'[ \t\n\r]+'
}

def analyze_p1(source_code):
    tokens = []
    line_num = 1
    pos = 0
    length = len(source_code)

    while pos < length:
        match_ws = re.match(TOKEN_TYPES_P1['WHITESPACE'], source_code[pos:])
        if match_ws:
            line_num += match_ws.group(0).count('\n')
            pos += match_ws.end()
            continue

        match_comment_line = re.match(TOKEN_TYPES_P1['COMMENT_LINE'], source_code[pos:])
        if match_comment_line:
            pos += match_comment_line.end()
            continue
            
        match_comment_block = re.match(TOKEN_TYPES_P1['COMMENT_BLOCK'], source_code[pos:])
        if match_comment_block:
             line_num += match_comment_block.group(0).count('\n')
             pos += match_comment_block.end()
             continue

        if pos >= length:
            break

        match_found = False
        
        for token_type in ['KEYWORD', 'REAL', 'INTEGER', 'STRING', 'OPERATOR', 'DELIMITER', 'IDENTIFIER']:
             match = re.match(TOKEN_TYPES_P1[token_type], source_code[pos:])
             if match:
                 lexeme = match.group(0)
                 tokens.append((line_num, token_type, lexeme))
                 pos += match.end()
                 match_found = True
                 break

        if not match_found:
             char = source_code[pos]
             tokens.append((line_num, 'ERRO_LEXICO', char))
             if char == '\n':
                 line_num += 1
             pos += 1

    return tokens

if __name__ == "__main__":
    if len(sys.argv) > 1:
        with open(sys.argv[1], 'r') as f:
            code = f.read()
            tokens = analyze_p1(code)
            for line, t_type, lexeme in tokens:
                print(f"LINHA {line}: {t_type} ({lexeme})")