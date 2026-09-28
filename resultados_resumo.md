# Resultados — leitura automática

_Gerado em 28/09/2026 18:15 (UTC-3) a partir da execução do notebook._

## P1

Na janela analisada, **6.544 de 97.541 remessas entregues chegaram depois da data prometida**: taxa de **6,7%** (IC 95%: 6,6% a 6,9%). A taxa mensal variou de 1,1% (2018-06) a **18,8% (2018-03)**. Meses acima de 1,5× a média: **2017-11, 2018-02, 2018-03**. Nos mesmos meses (jan a ago), a taxa foi 3,5% em 2017 e 7,6% em 2018 (diferença significativa, qui-quadrado p < 0,001). A correlação entre volume mensal e taxa de atraso é ρ = 0,55 (p = 0,012), ou seja, os meses de maior demanda tendem a atrasar mais. Em média, o prazo prometido supera o realizado em **11,8 dias**: a promessa é folgada **na média**, e mesmo assim 6,7% das remessas atrasam. O problema está na **variabilidade** do prazo, não no seu valor médio.

## P2

A taxa nacional é 6,7%. **14 UF(s) estão significativamente acima da média**: AL (21,4%), MA (17,4%), SE (15,2%), PI (13,8%), CE (13,7%), BA (12,0%), RJ (12,0%), PA (11,2%), ES (10,6%), PB (10,4%), MS (9,6%), PE (9,6%), RN (9,3%), SC (8,1%). Entre as UFs com pelo menos 300 entregas, a mais afetada (AL, 21,4%) tem **5,3 vezes** a taxa da menos afetada (PR, 4,0%). Por região: Nordeste 12,6%, Norte 8,6%, Centro-Oeste 6,5%, Sudeste 6,1%, Sul 5,8%. A correlação entre a folga média da promessa e a taxa de atraso é ρ = -0,70 (p < 0,001). **Calibração:** em 11 UFs o prazo mediano prometido é **menor** que o P90 do prazo realizado (maiores déficits: AL +9 d, RR +9 d, SE +6 d, MA +4 d, RJ +4 d); em 14 UFs a promessa já é **maior** que o P90 (maiores folgas: AP -12 d, AC -10 d, RO -8 d, AM -6 d, MT -4 d), o que abre espaço para prometer prazos menores sem aumentar o risco.

## P3

A taxa de atraso vai de **4,4%** (até 100 km) a **12,0%** (2.000 km ou mais): **2,72 vezes** (qui-quadrado entre faixas p < 0,001). Na regressão só com a distância, cada +500 km multiplica a chance de atraso por 1,24 (IC 95%: 1,22 a 1,26). **Controlando região de destino, peso, postagem e mês, o OR da distância passa a 1,18 (IC 95%: 1,14 a 1,22).** A distância continua sendo fator de risco mesmo depois dos controles. Regiões de destino com risco diferente do Sudeste, mantida a distância: Nordeste (OR 1,56), Sul (OR 0,88). Entre os controles, a postagem fora do prazo tem OR = 4,84 (IC 95%: 4,54 a 5,15), um efeito detalhado em P4.

## P4

Remessas postadas **depois** do prazo-limite atrasam **21,0%** das vezes, contra 5,3% das postadas no prazo: **3,9 vezes** mais (qui-quadrado p < 0,001). Elas são 8,9% das remessas e respondem por **27,7% dos atrasos**. Ou seja, a maior parte dos atrasos acontece **mesmo com o vendedor cumprindo o prazo de postagem**. Na decomposição, as remessas atrasadas levam em média 23,0 dias a mais que as no prazo: 2,9 dias a mais na **preparação** e 19,9 dias a mais no **transporte** (87% da diferença está no transporte). **Concentração:** 3,3% dos vendedores concentram 50% das entregas atrasadas (e 41,9% do volume); 13,5% concentram 80% (e 70,0% do volume). 56,8% dos vendedores não tiveram nenhum atraso. Taxa de atraso por porte: pequeno 6,7%, médio 6,6%, grande 6,8%.

## P5

Pedidos entregues no prazo têm nota média **4,29**; pedidos atrasados, **2,27**: diferença de **2,02 ponto(s)** (IC 95%: 1,98 a 2,06; Mann-Whitney p < 0,001). A proporção de avaliações negativas sobe de 9,2% para **62,4%** (6,7 vezes). O efeito cresce com o tamanho do atraso: na faixa '15+ dias de atraso', a nota média cai para 1,72 e 78,3% das avaliações são negativas, enquanto na faixa '15+ dias antes' a nota é 4,32. Os pedidos atrasados, 6,7% do total avaliado, geram **32,6% de todas as avaliações negativas**.

## Avaliação das hipóteses

| hipotese | criterio | resultado | veredito |
|---|---|---|---|
| H2 — a promessa não compensa as diferenças regionais | maior/menor taxa de atraso por UF (≥ 300 entregas) ≥ 3× | 5,3× (AL 21,4% × PR 4,0%) | Confirmada |
| H3 — a distância aumenta o risco, mesmo com controles | taxa ≥ 2.000 km / taxa até 100 km ≥ 1,5× e OR ajustado (+500 km) com IC 95% > 1 | razão 2,72×; OR ajustado 1,18 (IC 1,14 a 1,22) | Confirmada |
| H4 — parte relevante do atraso nasce no vendedor | taxa com postagem fora do prazo ≥ 2× taxa no prazo, p < 0,05 | 21,0% × 5,3% = 3,9× (p < 0,001); 27,7% dos atrasos | Confirmada |
| H5 — o atraso derruba a satisfação | nota média no prazo − nota média atrasado ≥ 1 ponto, p < 0,05 | 4,29 − 2,27 = 2,02 (p < 0,001) | Confirmada |

## Síntese

6,7% das remessas atrasam, com pico de 18,8% em 2018-03. O risco não é uniforme entre destinos: AL atrasa 5,3 vezes mais que PR, e em 11 UFs a promessa mediana é menor que o P90 do prazo realizado. A distância multiplica a chance de atraso por 1,24 a cada +500 km no modelo bruto e por 1,18 depois dos controles. Postar fora do prazo multiplica a taxa de atraso por 3,9 e responde por 27,7% dos atrasos; a maior parte dos atrasos nasce no transporte, que concentra 87% dos dias extras das remessas atrasadas. O custo em satisfação é alto: a nota cai 2,02 ponto(s), e os pedidos atrasados geram 32,6% das avaliações negativas.

## Custo de operação

Uma execução completa processa **45,1 MB** no BigQuery e ocupa **24,0 MB** de armazenamento: 0,0043% e 0,23% das franquias gratuitas. Mesmo com 30 execuções por mês (atualização diária), o consumo seria de 0,129% da franquia de consultas. **Custo operacional: US$ 0,00.** Sem franquia nenhuma, uma execução custaria cerca de US$ 0,0003 em consultas. O mínimo cobrado de 10 MB por tabela consultada eleva isso para alguns centavos de dólar, valor irrelevante diante do problema de negócio.
