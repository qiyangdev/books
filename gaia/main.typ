#import "@preview/ilm:2.1.1": *

#set text(
  lang: "zh",
  region: "CN",
  font: (
    (name: "Libertinus Serif", covers: "latin-in-cjk"),
    "Noto Serif CJK SC",
  ),
)

#show: ilm.with(
  title: [图解人工智能算法],
  authors: "启阳",
  date: datetime(year: 2026, month: 10, day: 09),
  date-format: "[year]年[month padding:zero]月[day padding:zero]日",
  abstract: [
    本文档是_Grokking AI Algorithms_的非官方中文翻译。
  ],
  preface: [
    #align(center)[
      #text(size: 16pt, weight: "bold")[免责声明]
    ]
    本文档仅供个人学习、研究与参考使用。
    
    原书的著作权及相关知识产权归原作者及相关权利人所有。本译稿与原作者、出版方不存在官方合作或授权关系。
    
    翻译过程中可能存在理解偏差、术语不准确或表述不当等问题。如译文与原文存在差异，请以英文原著为准。
    
    未经相关权利人许可，请勿擅自复制、传播、公开发布本译稿或将其用于商业用途。
    
    本译稿不以替代原著为目的。如果本书对您有所帮助，建议购买正版原著，以支持原作者及出版方。
  ],
  figure-index: (enabled: true),
  table-index: (enabled: true),
  listing-index: (enabled: true),
)

#set heading(numbering: none)

#include "chapters/ch1.typ"