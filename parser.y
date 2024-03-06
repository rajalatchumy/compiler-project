%{
/*********** C CODE (YOU DO NOT HAVE TO MODIFY IT) ******************/
#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include "ast.h"

#define CHECK_YYNOMEM(ptr) if ((ptr) == NULL) YYNOMEM;
#define CHECK_LENGTH(var, num) if ((num) >= 0) var = num; else { yyerror("negative length"); YYERROR; }

int yylex(void);
void yy_scan_string(char* s);
int yylex_destroy(void);
void yyerror(const char*);

extern char* strbuf;

const char *tokens[] = {
    "Document",
    "TextElement",
    "Paragraph",
    "Bold",
    "Italic",
    "Underline",
    "Strikethrough",
    "Header1",
    "Header2",
    "Header3",
    "Header4",
    "Header5",
    "Header6",
    "Quote",
    "InlineCode",
    "BlockCode",
    "HRule",
    "SVG"
};

const char* svg_tokens[] = {
    "Line",
    "Polyline",
    "Polygon",
    "Circle",
    "Ellipse",
    "Rect",
    "Text"
};

DOM* dom_root = NULL;

/*********** END OF C CODE ******************/
/** YOU WILL HAVE TO COMPLETE THE DOCUMENT BELOW **/
%}

%debug  // 启用调试

%define parse.lac full
%define parse.error detailed

%union {
    char* text;
    int number;
    DOM* dom;
    DomList* dom_list;
    SvgCoord* svg_coord;
    SvgCoordList* svg_coord_list;
    SvgInst* svg;
    SvgList* svg_list;
}

%destructor { free($$); } <text>
%destructor { free_dom($$); } <dom>
%destructor { free_dom_list($$); } <dom_list>
%destructor { free($$); } <svg_coord>
%destructor { free_svg_coord_list($$); } <svg_coord_list>
%destructor { free_svg_inst($$); } <svg>
%destructor { free_svg_list($$); } <svg_list>


%token NEWLINE BLANK_LINE
%token BOLD ITALIC UNDERLINE STRUCK H1 H2 H3 H4 H5 H6
%token BLOCK_CODE INLINE_CODE HR QUOTE
%token SVG_BEGIN SVG_END COMMA LINE POLYLINE CIRCLE ELLIPSE RECT
%token <text> STR
%token <number> NUMBER
%token <text> TEXT

%type <dom> document block svg
%type <dom_list> block_list paragraph line text
%type <svg_coord> svg_coord
%type <svg_coord_list> svg_coord_list
%type <svg> svg_instruction
%type <svg_list> svg_instruction_list

%start document


%%


document:
    block_list {
        dom_root = new_dom(Document, $1);
        $$ = dom_root;
        YYACCEPT;
    }
    ;


block_list:
    block BLANK_LINE block_list {
        $$ = new_dom_list($1);
        DomList* curr = $$;
        while (curr->next != NULL) curr = curr->next;
        curr->next = $3;
    }
    | block {
        $$ = new_dom_list($1);
    }
    ;


block:
    H1 TEXT {
        DOM* dom = new_dom(Header1, NULL);
        dom->text = $2;
        $$ = dom;
    }
    | H2 TEXT {
        DOM* dom = new_dom(Header2, NULL);
        dom->text = $2;
        $$ = dom;
    }
    | H3 TEXT {
        DOM* dom = new_dom(Header3, NULL);
        dom->text = $2;
        $$ = dom;
    }
    | H4 TEXT {
        DOM* dom = new_dom(Header4, NULL);
        dom->text = $2;
        $$ = dom;
    }
    | H5 TEXT {
        DOM* dom = new_dom(Header5, NULL);
        dom->text = $2;
        $$ = dom;
    }
    | H6 TEXT {
        DOM* dom = new_dom(Header6, NULL);
        dom->text = $2;
        $$ = dom;
    }
    | BLOCK_CODE paragraph BLOCK_CODE {
        DOM* code_dom = new_dom(BlockCode, NULL);
        code_dom->children = $2;
        $$ = code_dom;
    }
    | INLINE_CODE TEXT INLINE_CODE {
        DOM* inline_code_dom = new_dom(InlineCode, NULL);
        inline_code_dom->text = $2;
        $$ = inline_code_dom;
    }
    | HR {
        $$ = new_dom(HRule, NULL);
    }
    | QUOTE paragraph {
        DOM* quote_dom = new_dom(Quote, NULL);
        quote_dom->children = $2;
        $$ = quote_dom;
    }
    | svg {
        $$ = $1;
    }
    | paragraph {
        $$ = new_dom(Paragraph, $1);
    }
    ;

paragraph:
    line NEWLINE paragraph {
        $$ = $1;
        DomList* curr = $$;
        while (curr->next != NULL) curr = curr->next;
        curr->next = $3;
    }
    | line {
        $$ = $1;
    }
    ;

line:
    text line {
        $$ = $1;
        $$->next = $2;
    }
    | text {
        $$ = $1;
    }
    ;


text:
    TEXT {
        DOM* text_dom = new_dom(TextElement, NULL);
        text_dom->text = $1;
        $$ = new_dom_list(text_dom);
    }
    | BOLD text BOLD {
        DOM* dom_bold = new_dom(Bold, $2);
        $$ = new_dom_list(dom_bold);
    }
    | ITALIC text ITALIC {
        DOM* dom_italic = new_dom(Italic, $2);
        $$ = new_dom_list(dom_italic);
    }
    | UNDERLINE text UNDERLINE {
        DOM* dom_underline = new_dom(Underline, $2);
        $$ = new_dom_list(dom_underline);
    }
    | STRUCK text STRUCK {
        DOM* dom_struck = new_dom(Strikethrough, $2);
        $$ = new_dom_list(dom_struck);
    }
    | INLINECODE text INLINECODE{
        DOM* dom = new_dom(InlineCode, $2);
        $$ = new_dom_list(dom);
    };
    ;

svg:
    SVG_BEGIN svg_instruction_list SVG_END {
        DOM* svg_dom = new_dom(SVG, NULL);
        svg_dom->svg_children = $2;
        $$ = svg_dom;
    }
    ;

svg_instruction_list:
    svg_instruction svg_instruction_list {
        $$ = new_svg_list($1);
        $$->next = $2;
    }
    | svg_instruction {
        $$ = new_svg_list($1);
    }
    ;


// 定义 svg_coord
svg_coord:
    NUMBER COMMA NUMBER { $$ = new_svg_coord($1, $3); }
    ;

svg_coord_list:
    svg_coord {
        $$ = new_svg_coord_list($1);
    }
    | svg_coord_list COMMA svg_coord {
        SvgCoordList* new_list = new_svg_coord_list($3);
        SvgCoordList* curr = $1;
        while (curr->next != NULL) {
            curr = curr->next;
        }
        curr->next = new_list;
        $$ = $1;
    }
    ;



svg_instruction:
    LINE svg_coord svg_coord svg_attribute {
        SvgCoordList* coords = new_svg_coord_list($2);
        SvgCoordList* coord_next = new_svg_coord_list($3);
        coords->next = coord_next;
        $$ = new_svg_inst(Line, coords);

        $$->color_stroke = $4;
    }| POLYLINE svg_coord svg_coord svg_coord svg_attribute svg_attribute{
        SvgCoordList* coord_1 = new_svg_coord_list($2);
        SvgCoordList* coord_2 = new_svg_coord_list($3);
        SvgCoordList* coord_3 = new_svg_coord_list($4);
        coord_1->next = coord_2;
        coord_2->next = coord_3;
        $$ = new_svg_inst(Polyline, coord_1);

        $$->color_fill = $5;
        $$->color_stroke = $6;
    }| CIRCLE svg_coord NUMBER svg_attribute svg_attribute{
        SvgCoordList* coord = new_svg_coord_list($2);
        $$ = new_svg_inst(Circle, coord);

        $$->rayon = $3;
        $$->color_fill = $4;
        $$->color_stroke = $5;
    }| ELLIPSE svg_coord NUMBER NUMBER svg_attribute svg_attribute{
        SvgCoordList* coord = new_svg_coord_list($2);
        $$ = new_svg_inst(Ellipse, coord);

        $$->width = $3;
        $$->height = $4;
        $$->color_fill = $5;
        $$->color_stroke = $6;
    }| RECT svg_coord NUMBER NUMBER svg_attribute svg_attribute{
        SvgCoordList* coord = new_svg_coord_list($2);
        $$ = new_svg_inst(Rect, coord);

        $$->width = $3;
        $$->height = $4;
        $$->color_fill = $5;
        $$->color_stroke = $6;
    }| TEXT svg_coord STR svg_attribute{
        SvgCoordList* coord = new_svg_coord_list($2);
        $$ = new_svg_inst(Text, coord);

        $$->text = $3;
        $$->color_fill = $4;    
    }
    ;

%%

/*********** C CODE (YOU DO NOT HAVE TO MODIFY IT) ******************/

void svg_display(SvgInst* svg, int depth) {
    if (svg == NULL) return;
    for (int i = 0; i < depth - 2; i++) {
        printf("│   ");
    }
    printf("├─── %s", svg_tokens[svg->kind]);
    SvgCoordList* curr_coord = svg->coords;
    printf(" [");
    while (curr_coord != NULL) {
        printf(" (%d, %d)", curr_coord->coord->x, curr_coord->coord->y);
        curr_coord = curr_coord->next;
    }
    printf("]");
    printf(" w=%d", svg->width);
    printf(" h=%d", svg->height);
    if (svg->text != NULL) printf(" \"%s\"", svg->text);
    if (svg->anchor != NULL) printf(" anchor=%s", svg->anchor);
    if (svg->color_stroke != NULL) printf(" cs=%s", svg->color_stroke);
    if (svg->color_fill != NULL) printf(" cf=%s", svg->color_fill);
    printf("\n");
}

void dom_display(DOM* dom, int depth) {
    if (dom == NULL) return;
    int i = 0;

    if (depth == 1) {
        printf("%s", tokens[dom->dom_el]);
    } else {
        for (i = 0; i < depth - 2; i++) {
            printf("│   ");
        }
        printf("├─── %s", tokens[dom->dom_el]);
    }
    if (dom->text != NULL) {
        printf(" (%s)", dom->text);
    }
    if (dom->url != NULL) {
        printf(" (%s)", dom->url);
    }
    printf("\n");

    SvgList* svg_child = dom->svg_children;

    while (svg_child != NULL) {
        svg_display(svg_child->svg, depth + 1);

        svg_child = svg_child->next;
    }

    DomList* current_child = dom->children;

    while (current_child != NULL) {
        dom_display(current_child->dom, depth + 1);

        current_child = current_child->next;
    }
}

void yyerror(const char* s) {
    fprintf(stderr, "%s\n", s);
}

int yywrap(void) {
    return 1;
}

int main(int argc, char* argv[]) {
#if YYDEBUG
    extern int yydebug;
    yydebug = 1;// 启用 Bison 调试输出
#endif

    char* input = NULL;
    if (argc == 2) {
        FILE* f = fopen(argv[1], "r");
        if (!f) {
            fprintf(stderr, "Cannot open file");
            return -1;
        }
        fseek(f, 0, SEEK_END);
        int length = ftell(f);
        rewind(f);
        input = malloc(sizeof(char) * (length + 1));
        if (input == NULL) {
            fprintf(stderr, "Cannot allocate enough memory for file");
            return -2;
        }
        fread(input, sizeof(char), length, f);
        fclose(f);
        *(input + length) = 0;
        unsigned int i = 0;
        while (i < length && isspace(*input)) {
            input++;
            i++;
        }
        unsigned int j = length - i - 1;
        while (j > i && isspace(*(input + j))) *(input + j--) = 0;
        yy_scan_string(input);
    }
    int ret = yyparse();

    if (input != NULL) {
        free(input);
    }
    if (argc == 2) {
        yylex_destroy();
    }
    if (strbuf != NULL) {
        free(strbuf);
    }

    if (ret > 0) return ret;
    else {
        dom_display(dom_root, 1);

        free_dom(dom_root);
    }
}

/*********** END OF C CODE ******************/
