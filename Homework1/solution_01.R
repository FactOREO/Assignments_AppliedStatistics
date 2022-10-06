### Hausaufgabe 01 ###
### R Version: 4.1.3

### Pakete laden
library("GGally"); library("data.table"); setDTthreads(4)
theme_set(theme_bw())

# Problem 1
# a) Erzeugen des Datensatzes
mydata.unternehmen = data.table(name = c("Vitol","Glencore","Cargill","Trafigura","Mercuria",
                                         "Nestle","Glinvor","LouisDreyfusCommodities","Novartis","Ineos"),
                                branche = c("Mineraloelhandel",rep("Welthandel/Rohstoffhandel",4),"Nahrungsmittel","Mineraloelhandel","Welthandel/Rohstoffhandel",rep("Chemie/Pharma",2)),
                                umsatz_CH = c(253.8,207.81,126.81,119.94,106,91.61,86,64,55.72,50.76)) # (Umsatz in Milliarden Franken)
mydata.unternehmen$branche = as.factor(mydata.unternehmen$branche)
mydata.unternehmen$name = as.factor(mydata.unternehmen$name)

# b) Erzeugen der Umsatzvariable in Euro
mydata.unternehmen[,umsatz_EUR := round(umsatz_CH * 0.9163,2)]
  # Runden auf 2 Nachkommastellen im Sinne der gegebenen Franken-Umsaetze sinnvoll

# c) Zugriff auf Novartis-Umsatz
mydata.unternehmen[name == "Novartis",.(umsatz_CH,umsatz_EUR)]
  # Da nicht weiter spezifiziert Zugriff auf beide Umsaetze

# d) Neue Datensaetze fuer
  # 1) branche == "Welthandel/Rohstoffhandel"
  mydata.welthandel = mydata.unternehmen[branche == "Welthandel/Rohstoffhandel"]
  # 2) Umsatz >100Mrd Franken
  mydata.MRD.FR = mydata.unternehmen[umsatz_CH > 100]

# e) Erstellung von Grafiken als .png
  # 1) Zusammenhang Umsatz und Unternehmenssparte
  png(file = "grafik1.png", width = 1024, height = 744,units = "px")
  ggplot(data = mydata.unternehmen) +
    geom_boxplot(aes(branche,umsatz_CH)) +
    labs(x = "Unternehmenssparte",y = "Umsatz",
         title = "Zusammenhang zwischen Umsatz und Unternehmenssparte",
         subtitle = "in Mrd. Schweizer Franken")
  dev.off()
  # 2) Verteilung der Unternehmenssparten
  png(file = "grafik2.png", width = 1024, height = 744,units = "px")
  ggplot() +
    # nuetzliche Sortierung + angenehmere Farbe (dunkleres grau)
    geom_bar(data = mydata.unternehmen[,count := .N, by = branche],
             aes(x = reorder(branche,-count)), fill = "gray25") +
    labs(title = "Anzahl Unternehmen je Unternehmenssparte") +
    theme(axis.title = element_blank())
  dev.off()
  mydata.unternehmen[,count := NULL] # Zwischenergebnis wieder loeschen
  
# f) Abspeichern des Datensatzes
save(mydata.unternehmen, file = "mydata.unternehmen.RData")

# Workspace und Arbeitsspeicher leeren
rm(list = ls())
gc()
####
# Aufgabe 2
mydata = data.table(iris)

# a) Scatter Matrix fuer den kompletten Datensatz
# Einfaerben nach Gruppenzugehoerigkeit, um mehr Informationen zu visualisieren
farben <- c("setosa" = "blue", "versicolor" = "green", "virginica" = "red")
ggpairs(mydata, aes(color = Species)) +
  scale_fill_manual(values = farben)
### Base-R Loesung
# pairs(mydata, col = mydata$Species)

# b) Hat die Pflanzenart einen Einfluss auf die Breite der Kelchblaetter?
# Boxplot erstellen
ggplot(mydata) +
  geom_boxplot(aes(x = as.factor(Species),
                   y = Sepal.Width)) +
  labs(title = "Zusammenhang zwischen Spezies und Kelchblattbreite",
       x = "Spezies", y = "Kelchblattbreite")

# c)
  # 1) Histogramm fuer die Breite der Kelchblaetter aller Pflanzenarten
  ggplot(mydata) +
    geom_histogram(aes(Sepal.Width), bins = 15, color = "grey25") +
    labs(title = "Verteilung der Kelchblattbreite ?ber alle Pflanzen",
         subtitle = "Ordinate: Anzahl",
         x = "Kelchblattbreite") +
    theme(axis.title.y = element_blank())
  # 2) Histogramm fuer die Breite der Kelchblaetter je Pflanzenart
  ggplot(mydata) +
    geom_histogram(aes(Sepal.Width), bins = 15, color = "grey25") +
    facet_wrap(~ Species) +
    labs(title = "Verteilung der Kelchblattbreite nach Pflanzenarten",
         subtitle = "Ordinate: Anzahl",
         x = "Kelchblattbreite") +
    theme(axis.title.y = element_blank())

# d) Jeweils fuer die Pflanzenarten
  mydata = melt.data.table(mydata, id.vars = "Species", variable.name = "Type", value.name = "Value")
  mydata[, .(minimum = min(Value),
             maximum = max(Value),
             mean_val = mean(Value),
             variance = var(Value)),
         by = c("Type","Species")]
  
