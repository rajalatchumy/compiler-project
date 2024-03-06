/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    NEWLINE = 258,                 /* NEWLINE  */
    BLANK_LINE = 259,              /* BLANK_LINE  */
    BOLD = 260,                    /* BOLD  */
    ITALIC = 261,                  /* ITALIC  */
    UNDERLINE = 262,               /* UNDERLINE  */
    STRIKETHROUGH = 263,           /* STRIKETHROUGH  */
    INLINE_CODE = 264,             /* INLINE_CODE  */
    BLOCK_CODE = 265,              /* BLOCK_CODE  */
    H1 = 266,                      /* H1  */
    H2 = 267,                      /* H2  */
    H3 = 268,                      /* H3  */
    H4 = 269,                      /* H4  */
    H5 = 270,                      /* H5  */
    H6 = 271,                      /* H6  */
    HR = 272,                      /* HR  */
    QUOTE = 273,                   /* QUOTE  */
    TEXT = 274,                    /* TEXT  */
    STR = 275,                     /* STR  */
    SVG_BEGIN = 276,               /* SVG_BEGIN  */
    SVG_END = 277,                 /* SVG_END  */
    COMMA = 278,                   /* COMMA  */
    LINE = 279,                    /* LINE  */
    POLYLINE = 280,                /* POLYLINE  */
    CIRCLE = 281,                  /* CIRCLE  */
    ELLIPSE = 282,                 /* ELLIPSE  */
    RECT = 283,                    /* RECT  */
    NUMBER = 284                   /* NUMBER  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define NEWLINE 258
#define BLANK_LINE 259
#define BOLD 260
#define ITALIC 261
#define UNDERLINE 262
#define STRIKETHROUGH 263
#define INLINE_CODE 264
#define BLOCK_CODE 265
#define H1 266
#define H2 267
#define H3 268
#define H4 269
#define H5 270
#define H6 271
#define HR 272
#define QUOTE 273
#define TEXT 274
#define STR 275
#define SVG_BEGIN 276
#define SVG_END 277
#define COMMA 278
#define LINE 279
#define POLYLINE 280
#define CIRCLE 281
#define ELLIPSE 282
#define RECT 283
#define NUMBER 284

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 58 "parser.y"

    char* text;
    int number;
    DOM* dom;
    DomList* dom_list;
    SvgCoord* svg_coord;
    SvgCoordList* svg_coord_list;
    SvgInst* svg;
    SvgList* svg_list;

#line 136 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
