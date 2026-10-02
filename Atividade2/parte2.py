import sys
import re

TOKEN_TYPES_MINILANG = {
    'KEYWORD': r'\b(inicio|fim|inteiro|real|texto|booleano|se|faz|senao|repita_enquanto|para|de|ate|faca|leia|mostre|sim|nao|retorne|funcao)\b',
    'REAL': r'\b\d+,\d+\b',
    'INTEGER': r'\b\d+\b',
    'STRING': r"'(?:[^'\\\n]|\\.)*'",
    'OPERATOR': r'==|!=|<=|>=|<|>|&&|\|\||!|\+|-|\*|/|%|=',
    'DELIMITER': r'\(|\)|\[|\]|\{|\}|\$|;',
    'IDENTIFIER': r'\b[a-zA-Z_][a-zA-Z0-9_]*\b',
    'COMMENT_LINE': r'#coment.*',
    'COMMENT_BLOCK': r'\{---[\s\S]*?---\}',
    'WHITESPACE': r'[ \t\n\r]+'
}

def analyze_minilang(source_code):
    tokens = []
    line_num = 1
    pos = 0
    length = len(source_code)

    while pos < length:
        match_ws = re.match(TOKEN_TYPES_MINILANG['WHITESPACE'], source_code[pos:])
        if match_ws:
            line_num += match_ws.group(0).count('\n')
            pos += match_ws.end()
            continue

        match_comment_line = re.match(TOKEN_TYPES_MINILANG['COMMENT_LINE'], source_code[pos:])
        if match_comment_line:
            pos += match_comment_line.end()
            continue

        match_comment_block = re.match(TOKEN_TYPES_MINILANG['COMMENT_BLOCK'], source_code[pos:])
        if match_comment_block:
             line_num += match_comment_block.group(0).count('\n')
             pos += match_comment_block.end()
             continue

        # Verifica comentario de bloco que nao foi fechado
        if source_code[pos:].startswith("{---"):
            erro_comentario = source_code[pos:]
            tokens.append((line_num, 'ERRO_LEXICO (comentario bloco nao fechado)', erro_comentario[:15] + "..."))
            break 

        if pos >= length:
            break

        match_found = False
        
        # KEYWORD, REAL, INTEGER, STRING, OPERATOR, DELIMITER, IDENTIFIER (A ordem importa)
        for token_type in ['KEYWORD', 'REAL', 'INTEGER', 'STRING', 'OPERATOR', 'DELIMITER', 'IDENTIFIER']:
             match = re.match(TOKEN_TYPES_MINILANG[token_type], source_code[pos:])
             if match:
                 if token_type == 'DELIMITER' and match.group(0) == '{' and source_code[pos:].startswith('{---'):
                     pass # Escapa para não detetar incorretamente
                 else:
                     lexeme = match.group(0)
                     tokens.append((line_num, token_type, lexeme))
                     pos += match.end()
                     match_found = True
                     break

        if not match_found:
             # Tratamento de erro lexico 
             if source_code[pos] == '"':
                 end_pos = pos + 1
                 while end_pos < length and source_code[end_pos] != '"' and source_code[end_pos] != '\n':
                     end_pos += 1
                 if end_pos < length and source_code[end_pos] == '"':
                     end_pos += 1
                 tokens.append((line_num, 'ERRO_LEXICO', source_code[pos:end_pos]))
                 pos = end_pos
             elif source_code[pos] == "'":
                 end_pos = pos + 1
                 while end_pos < length and source_code[end_pos] != "'" and source_code[end_pos] != '\n':
                     end_pos += 1
                 tokens.append((line_num, 'ERRO_LEXICO (string nao fechada)', source_code[pos:end_pos]))
                 pos = end_pos
             else:
                 match = re.match(r'[^\s]+', source_code[pos:])
                 if match:
                     if re.match(r'\d+[a-zA-Z_]', match.group(0)):
                         erro_len = re.match(r'\d+[a-zA-Z_0-9]*', source_code[pos:]).end()
                         tokens.append((line_num, 'ERRO_LEXICO (identificador invalido)', source_code[pos:pos+erro_len]))
                         pos += erro_len
                     else:
                         char = source_code[pos]
                         tokens.append((line_num, 'ERRO_LEXICO', char))
                         pos += 1
                 else:
                     char = source_code[pos]
                     tokens.append((line_num, 'ERRO_LEXICO', char))
                     pos += 1

    return tokens

if __name__ == "__main__":
    if len(sys.argv) > 1:
        with open(sys.argv[1], 'r') as f:
            code = f.read()
            tokens = analyze_minilang(code)
            for line, t_type, lexeme in tokens:
                print(f"LINHA {line}: {t_type} ({lexeme})")