---
title: "Hausaufgabe 02"
author:
  - "Hennig, Dustin"
date: "`r format(Sys.Date(), '%d. %B %Y')`"
output:
  html_document:
    theme: spacelab
    highlight: tango
    css: style.css
    code_folding: hide
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(
  echo = TRUE,tidy = TRUE,fig.align = "center",fig.width = 8.4, fig.height = 6.4
  )

pacman::p_load(
  "ggplot2","scales","viridis","data.table","gapminder","RColorBrewer"
  )
# Black-White Theme als Standard festlegen
theme_set(theme_bw()); setDTthreads(4)
# Wissenschaftliche Notation deaktivieren
options(scipen = 999)
# Workspace leeren
rm(list = ls())
```

## Aufgabe 1 {.tabset .tabset-fade}

Laden Sie das Paket ggplot2 und machen Sie sich mit dem Datensatz economics vertraut. Erstellen Sie jeweils die geforderten Grafiken und interpretieren Sie diese
kurz.

```{r Aufgabe 1 - Datenpraeparation}
data = data.table(economics)
data[, psavert := psavert/100]
# Fuer ansehnlichere Abszisse Prozentwerte im Vorhinein verschieben

knitr::kable(rbind(head(data), tail(data)))
```

Der Datensatz enthält monatliche Informationen über die Konsumausgaben der Bevölkerung in Milliarden Dollar (*pce*), die Gesamtbevölkerung in Tausend (*pop*), die Haushaltssparrate in Anteilen (*psavert*) sowie die mittlere Dauer der Arbeitslosigkeit in Wochen (*uempmed*) und die Zahl der Arbeitslosen in Tausend (*unemploy*) zwischen dem 01. Juli 1967 und dem 01. April 2015 (*date*).

###  Aufgabe 1.a) 

Erstellen Sie eine Grafik, die den Zusammenhang zwischen **Arbeitslosigkeit** und der **Sparrate** zeigt.

```{r Aufgabe 1a - Grafik, fig.cap="Abbildung 1: Zusammenhang zwischen Arbeitslosigkeit und Sparrate"}
ggplot(data) +
  geom_point(aes( psavert , unemploy ),
             col = viridis(1, begin = 0.25, option = "B"), size = 3, alpha = 0.7) +
  geom_smooth(aes( psavert , unemploy ), 
              method = "lm", formula = y ~ x, se = FALSE,
              col = viridis(1, begin = 0.75, option = "B")) +
  labs(
    title = "Zusammenhang zwischen Arbeitslosigkeit und Sparrate",
    subtitle = "Vereinigten Staaten von Amerika, Anzahl in 1.000",
    x = "Sparrate", y = "Anzahl Arbeitslose"
    ) +
  scale_x_continuous(labels = percent) +
  scale_y_continuous(labels = function(x) format(x, big.mark = ".", decimal.mark = ",") )
```

Die Grafik zeigt ein Streudiagramm für die beobachteten Datenpaare aus der Anzahl der Arbeitslosen (in 1.000) in den Vereinigten Staaten von Amerika und der Sparrate (in %) für den Beobachtungszeitraum zwischen 1967 und 2015. Im Großen und Ganzen zeigt sich ein Abwärtstrend, welchen auch die Regressionsgerade bestätigt. Mit zunehmender Sparrate scheint demnach die Zahl der Arbeitslosen abzunehmen. Hieraus ist aber nicht ersichtlich, ob auch die Arbeitslosenquote (Anteil der Arbeitslosen an den Erwerbspersonen) mit zunehmender Sparrate sinkt.

###  Aufgabe 1.b) 

Ergänzen Sie die Grafik aus [Aufgabe 1.a)] um den **Einfluss der Population**.

```{r Aufgabe 1b - Grafik, fig.cap="Abbildung 2: Zusammenhang zwischen Arbeitslosigkeit, Sparrate und Population"}
ggplot(data) +
  geom_point(aes( psavert , unemploy , fill = pop ),
             alpha = 0.75, shape = 21, size = 3) +
  labs(
    title = "Zusammenhang zwischen Arbeitslosigkeit, Sparrate und Population",
    subtitle = "Vereinigten Staaten von Amerika, Anzahl in 1.000",
    x = "Sparrate", y = "Anzahl Arbeitslose",
    fill = "Population"
    ) +
  scale_x_continuous(labels = percent) +
  scale_y_continuous(labels = function(x) format(x, big.mark = ".", decimal.mark = ",") ) +
  # Labels selbst definieren, um Tausendertrennzeichen in Legende einzufuegen
  scale_fill_viridis_c(option = "B",
                       labels = c("200.000","225.000","250.000","275.000","300.000","")) +
  theme(
    legend.position = c(0.975, 0.975),
    legend.justification = c("right", "top"),
    legend.box.just = "right"
    )
```

Die Grafik zeigt das Streudiagramm und deren Aussagen aus [Aufgabe 1.a)], jedoch ergänzt um eine farbliche Hervorhebung der Populationsentwicklung. Die höchsten Sparraten zeigten sich demnach für Beobachtungszeitpunkte, zu denen die Gesamtbevölkerung nahe der unteren Grenze von `r format(min(data$pop), big.mark = ".", decimal.mark = ",")` gelegen hat.

Mit zunehmender Populationsgröße hat sich die Konsumneigung tendenziell erhöht (niedrigere Sparrate). Eine Veränderung der Arbeitslosigkeit ist gegenüber der vorherigen Darstellung ([Aufgabe 1.a)]) weniger in Abhängigkeit der Sparrate zu beobachten, als viel mehr in den Extrembereichen der Populationswerte (hohe Arbeitslosenzahl bei Population über 300 Millionen sowie niedrige Zahl der Arbeitslosen bei Population unter 225 Millionen).

###  Aufgabe 1.c) 

Ergänzen Sie die Grafik aus [Aufgabe 1.a)] um den **Einfluss des Datums**, indem Sie die Punkte entsprechend einfärben.

```{r Aufgabe 1c - Grafik, fig.cap="Abbildung 3: Zusammenhang zwischen Arbeitslosigkeit, Sparrate und Datum"}
ggplot(data) +
  geom_point(aes( psavert , unemploy , fill = date ),
             size = 3, shape = 21) +
  labs(
    title = "Zusammenhang zwischen Arbeitslosigkeit, Sparrate und Datum",
    subtitle = "Vereinigten Staaten von Amerika, Anzahl in 1.000",
    x = "Sparrate", y = "Anzahl Arbeitslose",
    fill = "Datum"
    ) +
  scale_x_continuous(labels = percent) +
  scale_y_continuous(labels = function(x) format(x, big.mark = ".", decimal.mark = ",") ) +
  scale_fill_viridis_c(option = "B", labels = c("1970","1980","1990","2000")) +
  theme(
    legend.position = c(0.975, 0.975),
    legend.justification = c("right", "top"),
    legend.box.just = "right"
  )
```

Die vorliegende Grafik zeigt einen vergleichbaren Zusammenhang wie die Grafik in [Aufgabe 1.b)]. Dies ist erklärbar durch den Populationszuwachs im Zeitverlauf, sodass Zeitfortschritt und Populationsentwicklung näherungsweise identisch verlaufen. Auch hier ist eine Zunahme der Konsumneigung und damit ein Rückgang der Sparrate im Zeitverlauf erkennbar. Besonders starke Abweichungen der Arbeitslosenzahl im Vergleich zum Median von `r format(median(data$unemploy) * 1000,big.mark = ".", decimal.mark = ",")` treten insbesondere in den Anfangszeitangaben sowie in den Daten des letzten Jahrzehnts der Aufzeichnung auf.

###  Aufgabe 1.d)

Untersuchen Sie den Einfluss des Datums genauer. Hat der **Monat oder das Jahr** einen Einfluss? Erzeugen Sie hierfür jeweils neue Faktoren, die den Monat, das Jahr bzw. das Jahrzehnt enthalten und erstellen Sie für diese neue Grafiken wie in [Aufgabe 1.c)].

```{r Aufgabe 1d - Datenpraeparation}
data[,`:=`(monat = factor(month(date),
                          levels = 1:12,
                          labels = c("Januar","Februar","März","April","Mai","Juni",
                                     "Juli","August","September","Oktober","November",
                                     "Dezember")),
           jahr = as.factor(year(date)),
           jahrzehnt = as.factor(fcase(year(date) %inrange% c(1960,1969),"1960er",
                                       year(date) %inrange% c(1970,1979),"1970er",
                                       year(date) %inrange% c(1980,1989),"1980er",
                                       year(date) %inrange% c(1990,1999),"1990er",
                                       year(date) %inrange% c(2000,2009),"2000er",
                                       year(date) %inrange% c(2010,2019),"2010er")))]
```

```{r Aufgabe 1d - Grafik 1, fig.cap="Abbildung 4: Zusammenhang zwischen Arbeitslosigkeit, Sparrate und Monaten"}
ggplot(data) +
  geom_point(aes( psavert , unemploy , col = monat ),
             size = 3) +
  labs(
    title = "Zusammenhang zwischen Arbeitslosigkeit, Sparrate und Jahrzehnt",
    subtitle = "Vereinigten Staaten von Amerika, Anzahl in 1.000",
    x = "Sparrate", y = "Anzahl Arbeitslose",
    col = "Monat"
    ) +
  scale_x_continuous(labels = percent) +
  scale_y_continuous(labels = function(x) format(x, big.mark = ".", decimal.mark = ",") ) +
  scale_color_manual(values = viridis(n = 12, option = "B"))
```

Die erste Grafik zeigt den Zusammenhang der Sparrate mit der arbeitslosen Bevölkerung je Monat. Es ergeben sich keine erkennbaren Muster eines saisonalen Einflusses.

```{r Aufgabe 1d - Grafik 2, fig.cap="Abbildung 5: Zusammenhang zwischen Arbeitslosigkeit, Sparrate und Jahr"}
ggplot(data) +
  geom_point(aes( psavert , unemploy , col = jahr ),
             size = 3) +
  labs(
    title = "Zusammenhang zwischen Arbeitslosigkeit, Sparrate und Jahr",
    subtitle = "Vereinigten Staaten von Amerika, Anzahl in 1.000",
    x = "Sparrate", y = "Anzahl Arbeitslose",
    col = "Jahr"
    ) +
  scale_x_continuous(labels = percent) +
  scale_y_continuous(labels = function(x) format(x, big.mark = ".", decimal.mark = ",") ) +
  scale_color_manual(values = viridis(n = 49, option = "B"))
```

Die zweite Grafik lässt einen Zusammenhang zwischen dem Zeitfortschritt, der Sparrate und der Arbeitslosigkeit erkennen. In späteren Jahren sinkt die Sparrate, während sich die Zahl der Arbeitslosen insbesondere in den ersten und letzten Jahren der Aufzeichnung signifikant verändert (vgl. [Aufgabe 1.c)]).

```{r Aufgabe 1d - Grafik 3,fig.cap="Abbildung 6: Zusammenhang zwischen Arbeitslosigkeit, Sparrate und Jahrzehnt"}
ggplot(data) +
  geom_point(aes( psavert , unemploy , col = jahrzehnt ),
             size = 3) +
  labs(
    title = "Zusammenhang zwischen Arbeitslosigkeit, Sparrate und Monat",
    subtitle = "Vereinigten Staaten von Amerika, Anzahl in 1.000",
    x = "Sparrate", y = "Anzahl Arbeitslose",
    col = "Jahrzehnt"
    ) +
  scale_x_continuous(labels = percent) +
  scale_y_continuous(labels = function(x) format(x, big.mark = ".", decimal.mark = ",") ) +
  scale_color_manual(values = viridis(n = 6, option = "B")) +
  theme(
    legend.position = c(0.975, 0.99),
    legend.justification = c("right", "top"),
    legend.box.just = "right"
  )
```

Die dritte Grafik bestärkt die Vermutung aus der vorhergehenden Abbildung, dass die Sparrate im Zeitverlauf ab- und die Zahl der Arbeitslosen zunimmt, wobei sich der Anstieg der Arbeitslosenzahl besonders im ersten (von sehr niedrig in Richtung Mitte) sowie letzten Jahrzehnt vollzieht.

###  Aufgabe 1.e)

Ergänzen Sie für die Grafik aus [Aufgabe 1.d)], die den Zusammenhang zwischen Arbeitslosigkeit und Sparrate für die einzelnen Jahrzehnte zeigt, **lineare Regressionsgeraden für die entsprechenden Jahrzehnte sowie die Gesamtregressionsgerade aller Datenpunkte**.

```{r Aufgabe 1e - Grafik, fig.cap="Abbildung 7: Zusammenhang zwischen Arbeitslosigkeit, Sparrate und Jahrzehnt"}
ggplot(data, aes( psavert , unemploy )) +
  geom_point(aes( col = jahrzehnt ),
             size = 3) +
  geom_smooth(aes( group = jahrzehnt , col = jahrzehnt ),
              method = "lm", formula = y ~ x, se = FALSE) +
  geom_smooth(aes( col = "Gesamt" ),
              method = "lm", formula = y ~ x, se = FALSE) +
  scale_color_manual(values = c(viridis(n = 6, begin = 0.3, option = "B"),
                                "black")) +
  labs(
    title = "Zusammenhang zwischen Arbeitslosigkeit, Sparrate und Jahrzehnt",
    subtitle = "Vereinigten Staaten von Amerika, Anzahl in 1.000, inkl. Regressionsgeraden",
    x = "Sparrate", y = "Anzahl Arbeitslose",
    col = "Jahrzehnt"
    ) +
  scale_x_continuous(labels = percent) +
  scale_y_continuous(labels = function(x) format(x, big.mark = ".", decimal.mark = ",") ) +
  theme(
    legend.position = c(0.945, 0.99),
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.box.background = element_rect(color = "transparent", fill = "transparent"),
    legend.background = element_rect(fill = "transparent")
  )
```

Die gruppierten Regressionsgeraden zeigen unterschiedliche Sichtweisen je Jahrzehnt auf, sodass in Abhängigkeit vom Betrachtungsjahrzehnt verschiedene Schlussfolgerungen denkbar sein können. Ingesamt ergibt sich eine fallende lineare Regressionsgerade, sodass eine steigende Sparrate mit einer sinkenden Zahl der Arbeitslosen einhergeht. Für die Jahrzehnte der 1980er bis 2000er zeigt sich indes eine umgekehrte Beziehung, sodass hier eine steigende Sparrate mit einer zunehmenden Zahl der Arbeitslosen auftritt (1960er ebenfalls leicht steigend).

###  Aufgabe 1.f) 
Ergänzen Sie für die Grafik aus [Aufgabe 1.d)], die den Zusammenhang zwischen Arbeitslosigkeit und Sparrate für die einzelnen Monate zeigt, **lineare Regressionsgeraden für alle Monate sowie die Gesamtregressionsgerade aller Datenpunkte**.

```{r Aufgabe 1f - Grafik, fig.cap="Abbildung 8: Zusammenhang zwischen Arbeitslosigkeit, Sparrate und Monaten"}
economics_lm = lm(unemploy ~ psavert, data = data)

ggplot(data, aes( psavert , unemploy )) +
  geom_point(aes( col = monat ),
             size = 3) +
  geom_smooth(aes(group = monat, color = monat),
              method = "lm", formula = y ~ x, se = FALSE) +
  # Einschub, da geom_smooth/stat_smooth die Faktor-Reihenfolge durcheinander bringt
  geom_abline(intercept = economics_lm$coefficients[['(Intercept)']],
              slope = economics_lm$coefficients[['psavert']],
              size = 1.3) +
  labs(
    title = "Zusammenhang zwischen Arbeitslosigkeit, Sparrate und Monaten",
    subtitle = "Vereinigten Staaten von Amerika, Anzahl in 1.000, inkl. Regressionsgeraden",
    caption = "Regression über alle Punkte in Schwarz",
    x = "Sparrate", y = "Anzahl Arbeitslose",
    col = "Monat") +
  scale_x_continuous(labels = percent) +
  scale_y_continuous(labels = function(x) format(x, big.mark = ".", decimal.mark = ",") ) +
  scale_color_manual(values = viridis(n = 12, option = "B")) +
  theme(
    plot.caption = element_text(hjust = 0)
    )
```

Die letzte Abbildung aus [Aufgabe 1.f)] zeigt die einzelnen Regressionsgeraden je Monat. Sämtliche Regressionsgeraden verlaufen annähernd gleich zur Regressionsgeraden des gesamten Datensatzes, sodass hier keine saisonalen Effekte ableitbar sind.

```{r Abschluss Aufgabe 1,include=FALSE}
# Arbeitsspeicher leeren
rm(list = ls()); gc()
```

## Aufgabe 2 {.tabset .tabset-fade}

###  Aufgabe 2.a) 

Laden Sie das Paket ggplot2. Finden Sie heraus, was durch folgenden Code genau dargestellt wird. Berechnen Sie mit R die dargestellten Werte selbstständig.

```{r Aufgabe 2a - Grafik,fig.cap="Abbildung 9: Basisplot"}
ggplot(mpg,aes( class )) +
  geom_bar(aes( weight = displ ))
```

Der Code lädt ein Histogramm aus dem mpg Datensatz, welcher die nach dem Durchschnitt von *displ* je *class* gewichtete Anzahl (=*count*) unterschiedlicher Fahrzeugklassen im Datensatz abbildet. Die Variable *displ* entspricht dabei dem Hubraum des Fahrzeugs in Litern. Die Grafik zeigt die höchste gewichtete Anzahl bei den SUVs, was aufgrund der Gewichtung mit dem Hubraum (*displ*) zustandekommt.

```{r Aufgabe 2a - Berechnungen, fig.cap="Abbildung 10: Nachgebaute Grafik"}
data = data.table(mpg)

berechnete_werte = data[,.(count = sum(.N * mean(displ))),by = class]
ggplot(berechnete_werte) +
  geom_bar(aes( class , count ),
           stat = "identity")
```

Die erzeugte Grafik mit den selbst berechneten Werten gleicht der vorgegebenen Grafik, sodass von einer richtigen Berechnung ausgegangen werden kann. Die zugehörigen Werte der einzelnen Fahrzeugklassen finden sich in der untenstehenden Tabelle.

```{r Aufgabe 2a - Tabelle,echo=FALSE}
knitr::kable(berechnete_werte)
```

```{r Abschluss 2a,include=FALSE}
rm(list = ls()); gc()
```

###  Aufgabe 2.b) 
Wählen Sie sich einen eigenen Datensatz und stellen Sie für diesen jeweils ein geeignetes

```{r Aufgabe2b - Setup}
data = data.table(gapminder)
```

1. Balkendiagramm 

```{r Aufgabe 2b.1 - Grafik, fig.cap="Abbildung 11: Bvölkerung je Kontinent"}
ggplot(data[
  year == 2007,
  .(pop.mill = pop/1000000,
    continent = factor(continent, levels = c("Asia","Africa","Americas","Europe","Oceania")))]) +
  geom_bar(aes( continent, pop.mill ),
           stat = "identity", fill = viridis(n = 1, begin = 0.05, option = "B")) +
  labs(
    title = "Bevölkerung je Kontinent",
    subtitle = "2007, Anzahl in Millionen",
    y = "Bevölkerungszahl") +
  scale_y_continuous(labels = function(x) format(x, big.mark = ".", decimal.mark = ",") ) +
  theme(
    axis.title.x = element_blank()
    )
```

Das Balkendiagramm zeigt die Zahl der Einwohner je Kontinent im Jahr 2007.

2. Boxplot 

```{r Aufgabe 2b.2 - Grafik, fig.cap="Abbildung 12: Verteilung der Lebenserwartung je Kontinent"}
ggplot(data[year == 2007,
            .(lifeExp = lifeExp,
              maxExp = max(lifeExp)),
            by = continent][
              order(maxExp, decreasing = TRUE),
              .(maxExp,
                lifeExp,
                continent = factor(continent, levels = unique(continent)))
            ]) +
  geom_boxplot(aes( continent , lifeExp ),
               fill = viridis(n = 1, begin = 0.75, option = "B")) +
  labs(
    title = "Verteilung der Lebenserwartung",
    subtitle = "2007, in Jahren",
    caption = "Die Sortierung folgt der jeweils höchsten Lebenserwartung je Kontinent",
    y = "Lebenserwartung"
    ) +
  theme(
    axis.title.x = element_blank(),
    plot.caption = element_text(hjust = 0)
    )
```

Der Boxplot zeigt die Verteilung der Lebenserwartung je Kontinent im Jahr 2007 in Jahren. Aus der Sortierung wird ersichtlich, dass das Land mit der höchsten Lebenserwartung in Asien liegt (vgl. Caption). Insgesamt sind die Kontinente Asien, Europa, Amerika und Australien & Ozeanien in der Lebenserwartung um einen Median von ca. 70 Jahren verteilt. Demgegenüber ist die Lebenserwartung in Afrika deutlich niedriger mit im Mittel `r round(median(data[continent == "Africa" & year == 2007]$lifeExp))` Jahren.

3. Histogramm mit Dichteschätzer 

```{r Aufgabe 2b.3 - Grafik, fig.cap="Abbildung 13: Histogramm der Lebenserwartung mit Dichteschätzer"}
ggplot(data[year == 2007], aes( lifeExp )) +
  geom_histogram(aes( y = ..density.. ),
                 bins = 25, fill = viridis(n = 1, begin = 0.15, option = "B"), col = "black") +
  geom_density(col = viridis(n = 1, begin = 0.65, option = "B"), lwd = 1) +
  labs(
    title = "Verteilung der Lebenserwartungen",
    subtitle = "2007, alle Kontinente, Angaben in Jahren bzw. Anteilen",
    x = "Lebenserwartung"
    ) +
  theme(
    axis.title.y = element_blank()
    )
```

Die letzte Grafik zeigt ein Histogramm für die Verteilung der Lebenserwartungen über alle Länder aller Kontinente im Jahr 2007 inklusive eines Dichteschätzers. Es zeigt sich eine Verdichtung zwischen 70 und 80 Jahren Lebenserwartung, was mit dem vorher gezeigten Boxplot zusammenpasst. Dort war die Verteilung um jeweils etwa 70 Jahre Lebenserwartung für vier der fünf Kontinente ersichtlich, sodass für die gesamte Verteilung im Histogramm eine Häufung um diesen Wert plausibel scheint.

###  Aufgabe 2.c)

Stellen Sie für den Datensatz, den Sie in [Aufgabe 2.b)] gewählt haben den **Zusammenhang zwischen 3 Variablen dar**.

```{r Aufgabe 2c - Grafik, fig.cap="Abbildung 14: Lebenserwartungen im Zeitverlauf"}
ggplot(data[,
            .(mean.lifeExp = mean(lifeExp)),
            by = c("year","continent")]) +
  geom_point(aes( as.factor(year) , mean.lifeExp , col = continent ),
             alpha = 0.8, size = 3) +
  labs(
    title = "Lebenserwartung im Zeitverlauf",
    subtitle = "1952 bis 2007, Angaben in Jahren",
    x = "Jahre", y = "mittlere Lebenserwartung",
    col = "Kontinent"
    ) +
  scale_color_manual(values = viridis(n = 5, begin = 0.1, end = 0.9, option = "B")) +
  theme(
    axis.title.x = element_blank(),
    legend.position = "bottom"
    )
```

Die Darstellungen unter [Aufgabe 2.b)] sind fortwährend Bestandsaufnahmen im Jahr 2007. Obige Grafik stellt nun die Entwicklung der mittleren Lebenserwartung je Kontinent im Zeitverlauf dar. Bemerkenswert ist hierbei ein starker Anstieg der mittleren Lebenserwartung in Asien und Amerika, während die Lebenserwartung in Australien & Ozeanien sowie Europa bereits zu Beginn sehr hoch ist und im Zeitverlauf nur mäßig weiter ansteigt. Ebenfalls heraus sticht die Entwicklung der mittleren Lebenserwartung in Afrika, welche zwischen 1952 und 1987 fortwährend, wenn auch langsam, ansteigt und zwischen 1987 und 2002 wieder fällt. Der Knick zwischen 1997 und 2002 wurde durch eine Stagnation zwischen 1987 und 1997 eingeleitet, was mit Blick auf die Lebenserwartungen der Einzelländer mit dem Völkermord in Ruanda zusammenhängt, durch welchen die Lebenserwartung von vormals `r data[country == "Rwanda" & year == 1987, lifeExp]` Jahren in 1987 auf `r data[country == "Rwanda" & year == 1992, lifeExp]` Jahren in 1992 gefallen ist.

```{r Abschluss Aufgabe 2, include=FALSE}
rm(list = ls()); gc()
```

## Aufgabe 3 {.tabset .tabset-fade}

Laden Sie sich aktuelle Zahlen zu Corona-Infektionen in Deutschland mithilfe des RSkriptes corona-jhu-data-from-git.r der Johns Hopkins Universität unter https://github.com/CSSEGISandData/COVID-19 herunter.

<font color = "purple"> *Das Skript wurde erstellt bevor das R-Skript zum Download im Aufgabenverzeichnis hochgeladen wurde. Der nachfolgende Code-Chunk zeigt den Datenimport.* </font>

```{r Aufgabe 3 - Datensammlung}
# Einlesen der Daten mittels data.table::fread()
confirmed = fread("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")
confirmed_GER = melt.data.table(confirmed[`Country/Region` == "Germany"],
                                id.vars = c("Country/Region","Province/State","Lat","Long"),
                                variable.name = "Date", variable.factor = FALSE,
                                value.name = "Infektionen")
# Unnoetige Spalten loeschen
confirmed_GER[,c("Country/Region","Lat","Long","Province/State") := NULL]

deaths = fread("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
deaths_GER = melt.data.table(deaths[`Country/Region` == "Germany"],
                                id.vars = c("Country/Region","Province/State","Lat","Long"),
                                variable.name = "Date", variable.factor = FALSE,
                                value.name = "Gestorbene")
deaths_GER[,c("Country/Region","Lat","Long","Province/State") := NULL]

recovered = fread("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv")
recovered_GER = melt.data.table(recovered[`Country/Region` == "Germany"],
                                id.vars = c("Country/Region","Province/State","Lat","Long"),
                                variable.name = "Date", variable.factor = FALSE,
                                value.name = "Genesene")
recovered_GER[,c("Country/Region","Lat","Long","Province/State") := NULL]

data = confirmed_GER[deaths_GER[recovered_GER, on = "Date"], on = "Date"] # Doppelter Join
data$Date = as.IDate(data$Date, format = "%m/%d/%y") # Umformatieren
data = melt.data.table(data, id.vars = "Date", variable.name = "type", value.name = "count") # Long Format

rm(list = setdiff(ls(), "data")) # Alles außer data loeschen
```

###  Aufgabe 3.a)

Stellen Sie den **zeitlichen Verlauf** der **kumulierten Infektionen**, **Todesfälle** sowie der **Genesenen** grafisch dar.

```{r Aufgabe 3a - Grafik, fig.cap="Abbildung 15: Verlauf des Pandemiegeschehens in Deutschland"}
ggplot(data) +
  geom_line(aes( Date , count ),
            color = viridis(n = 1, begin = 0.15, option = "B")) +
  labs(
    title = "Verlauf des Pandemiegeschehens",
    subtitle = "Deutschland, absolute kumulierte Anzahl"
    ) +
  facet_wrap(~ type, scale = "free_y") +
  scale_y_continuous(labels = function(x) format(x, big.mark = ".", decimal.mark = ",")) +
  theme(
    axis.text.x = element_text(angle = 45, vjust = 0.6),
    axis.title = element_blank()
    )
```

Als allererstes fällt auf, dass die Beobachtungen für Genesene im Datensatz ab Mitte des Jahres 2021 eingestellt wurden, sodass ein Abfall auf 0 erfolgte. Die kumulierte Zahl der Todesfälle ist zwischen dem späten zweiten Halbjahr 2020 und Mitte des Jahres 2021 stark angestiegen, ein erneuter Anstieg läuft seit dem Jahreswechsel 2021/2022. Mit Blick auf die kumulierten Infektionsfälle ist zwischen dem Beginn der Pandemie und etwa September 2021 nur ein mäßiger Anstieg zu sehen, während dieser sodann extrem stark steigt.

###  Aufgabe 3.b)

Stellen Sie den zeitlichen Verlauf der **Zunahmen** von **Infektionen**, **Todesfällen** sowie **Genesenen** grafisch dar.

```{r Aufgabe 3b - Praeparation}
# Datum des Abbruchs der Genesenen-Meldung
stop_Date = data[count == max(data[type == "Genesene", count]), Date]
max_val = max(data[type == "Genesene", count])
# Um Fehlskalierung (Aenderung um -3.6m) zu vermeiden, konstanthalten ab Abbruchdatum
set(data,
    i = which(data[["Date"]] > stop_Date & data[["type"]] == "Genesene"),
    j = "count",
    value = max_val)
# Erstellen der Zuwaechse
data[,
     growth := count - shift(count, 1,type = "lag"),
     keyby = type]
# Durch Nachmeldungen und Korrekturen kommt es vereinzelt zu negativen Zuwaechsen,
# welche durch 0 ersetzt werden, da negative Zuwaechse im Kontext genesener
# Personen keinen Sinn ergeben (außer schlechte Datenqualitaet).
set(data,
    i = which(data[["growth"]] < 0),
    j = "growth",
    value = 0)
```

```{r Aufgabe 3b - Grafik, warning=FALSE, fig.cap="Abbildung 16: Verlauf des Pandemiegeschehens in absoluten Zuwächsen"}
ggplot(data) +
  geom_line(aes( Date , growth ),
            lwd = 0.3, color = viridis(n = 1, begin = 0.15, option = "B")) +
  labs(
    title = "Verlauf des Pandemiegeschehens",
    subtitle = "Deutschland, absolutes Wachstum"
    ) +
  facet_wrap(~ type, scale = "free_y") +
  scale_y_continuous(labels = function(x) format(x, big.mark = ".", decimal.mark = ",")) +
  theme(
    axis.text.x = element_text(angle = 45, vjust = 0.6),
    axis.title = element_blank()
    )
```

Aus den kumulierten Fällen ist der starke Anstieg der Infektionen seit dem Jahreswechsel 2021 2022 bereits hervorgegangen. Dieser bestätigt sich nunmehr in der Betrachtung der absoluten Zuwächse. Für die Todesfälle zeigt sich hingegen ein stärkerer Anstieg pro Tag zwischen August 2020 und Januar 2021 als dies derzeit im Frühjahr 2022 zu beobachten ist.

###  Aufgabe 3.c) 
Stellen Sie den zeitlichen Verlauf geeignet in einer **Heatmap** dar.

```{r Aufgabe 3c - Praeparation}
data[, `:=` (year = factor(year(Date)),
             month = month(Date),
             week = lubridate::week(Date),
             weekday = weekdays(Date))]

data[, monthweek := 1 + week - min(week), by = c("month","year")]
# Da die Daten erst ab 22.01.2020 starten, wird fuer diese Zeilen die
# Monatswoche der Wochenzaehlung gleichgesetzt.
set(data,
    i = which(data[["Date"]] %inrange% c(as.Date("2020-01-01"),as.Date("2020-01-31")) &
                data[["week"]] == 4),
    j = "monthweek", value = 4)
set(data,
    i = which(data[["Date"]] %inrange% c(as.Date("2020-01-01"),as.Date("2020-01-31")) &
                data[["week"]] == 5),
    j = "monthweek", value = 5)

data[, monthweek := as.factor(monthweek)]

data[, `:=` (week = as.factor(week),
             weekday = factor(weekday,
                         levels = c("Sonntag","Samstag","Freitag",
                                    "Donnerstag","Mittwoch","Dienstag","Montag")),
             month = factor(month, labels = c("Jan","Feb","Mrz","Apr","Mai","Jun",
                                              "Jul","Aug","Sep","Okt","Nov","Dez")))]
```

```{r Aufgabe 3c - Grafik Infektionen1, fig.cap="Abbildung 17: Heatmap der Infektionszuwächse zwischen 2020 und 2022"}
ggplot(data[type == "Infektionen"],
       aes( monthweek , weekday, fill = growth )) +
  geom_tile(color = "white") +
  facet_grid(year ~ month) +
  scale_fill_gradient(low =viridis(n = 1, begin = 0.45, option = "B"),
                      high=viridis(n = 1, begin = 0.75, option = "B")) +
  labs(
    title = "Heatmap der täglichen Neuinfektionen",
    subtitle = "Alle Jahre der Pandemie bis zum aktuellen Rand",
    x = "Woche im Monat",
    fill = "Neuinfektionen"
    ) +
  theme(
    axis.title.y = element_blank()
    )
```

```{r Aufgabe 3c - Grafik Infektionen2, fig.cap="Abbildung 18: Heatmap der Infektionszuwächse zwischen 2020 und 2021"}
# Da die Neuinfektionen ab 2022 in die Hoehe schiessen, zeigt die zweite Heatmap
# den Verlauf bis Ende 2021
ggplot(data[type == "Infektionen" & year %in% c(2020,2021)],
       aes( monthweek , weekday, fill = growth )) +
  geom_tile(color = "white") +
  facet_grid(year ~ month) +
  scale_fill_gradient(low =viridis(n = 1, begin = 0.45, option = "B"),
                      high=viridis(n = 1, begin = 0.75, option = "B")) +
  labs(
    title = "Heatmap der täglichen Neuinfektionen",
    subtitle = "2020 und 2021",
    x = "Woche im Monat",
    fill = "Neuinfektionen"
    ) +
  theme(
    axis.title.y = element_blank()
    )
```

Der Verlauf der Heatmap zeigt, dass, gemessen an den Ausschlägen mit Beginn der Omikronwelle, die Zahl der Neuinfektionen pro Tag bis in den Januar 2022 äußerst niedrig liegt (bis zu etwa 100.000 pro Tag). Danach kommen vereinzelt Tage mit bis zu 500.000 Neuinfektionen an nur einem Tag.

In der zweiten Grafik für die Jahre 2020 und 2021 sind die vereinzelten Zuwächse der Neuinfektionen besser sichtbar, da diese hier nicht von den Werten jenseits der 100.000 in 2022 dominiert werden. Die einzelnen Wellen in November 2020 bis Januar 2021, April 2021 sowie ab November 2021 sind hier besser erkenbar.

```{r Aufgabe 3c - Grafik Todesfaelle, fig.cap="Abbildung 19: Heatmap der Todesfallzuwächse zwischen 2020 und 2022"}
ggplot(data[type == "Gestorbene"],
       aes( monthweek , weekday, fill = growth )) +
  geom_tile(color = "white") +
  facet_grid(year ~ month) +
  scale_fill_gradient(low =viridis(n = 1, begin = 0.45, option = "B"),
                      high=viridis(n = 1, begin = 0.75, option = "B")) +
  labs(
    title = "Heatmap der täglichen neuen Todesfälle",
    subtitle = "Alle Jahre der Pandemie bis zum aktuellen Rand",
    x = "Woche im Monat",
    fill = "Todesfälle"
    ) +
  theme(
    axis.title.y = element_blank()
    )
```

Die Grafik der täglichen neuen Todesfälle zeigt ein erhöhtes Sterbeaufkommen zwischen Dezember 2020 und Februar/März 2021 sowie ein erneutes Aufflammen ab etwa Dezember 2021, welches vereinzelt bis in den April 2022 anhält.

```{r Aufgabe 3c - Grafik Genesene, fig.cap="Abbildung 20: Heatmap der Genesenenzuwächse zwischen 2020 und 2022"}
ggplot(data[type == "Genesene"],
       aes( monthweek , weekday, fill = growth )) +
  geom_tile(color = "white") +
  facet_grid(year ~ month) +
  scale_fill_gradient(low =viridis(n = 1, begin = 0.45, option = "B"),
                      high=viridis(n = 1, begin = 0.75, option = "B")) +
  labs(title = "Heatmap der täglichen Genesenen (Zuwächse zum Vortag)",
       subtitle = "Alle Jahre der Pandemie bis zum aktuellen Rand",
       x = "Woche im Monat",
       fill = "Genesene") +
  theme(axis.title.y = element_blank())
```

Die letzte Grafik bezieht sich auf den täglichen Zuwachs genesener Personen im Verlauf der Pandemie. Die Grafik ist aufgrund der abbrechenden Datenerfassung der Genesenen ab `r format(stop_Date, "%d. %B %Y")` nur eingeschränkt interpretierbar, zeigt jedoch ein versetztes Auftreten höherer Genesenenzahlen zu den Infektionsfällen, was im Kontext einer Infektionskrankheit mit etwa zweiwöchigem Krankheitsbestehen plausibel scheint.
