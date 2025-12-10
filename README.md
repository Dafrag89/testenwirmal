# 2.5D Tower Defense (Godot 4)

Diese Kurz-Anleitung beschreibt, wie du das Projekt startest und steuerst.

## Voraussetzungen
- Godot Engine 4.2 oder neuer.
- Klone oder entpacke dieses Projekt so, dass sich die `project.godot` im Projektstamm befindet.

## Projekt öffnen und starten
1. Godot starten und **Project Manager** öffnen.
2. Über **Import** die Datei `project.godot` aus diesem Ordner wählen.
3. Danach **Run Project** (`F5`) drücken. Die Hauptszene ist bereits als Startszene hinterlegt.

## Steuerung
- Kamera links/rechts rotieren: **Q** / **E** (`action_rotate_left`, `action_rotate_right`).
- Tower platzieren: **Linksklick** auf das Spielfeld (`action_place_unit`).

## Gameplay-Hinweise
- Du startest mit 100 Ressourcen; ein Tower kostet 20. Plätze sind auf einem 6×3 Raster mit Snap auf die Bodengrundfläche begrenzt.
- Gegner laufen die vorgegebene Pfadlinie entlang; jede Welle spawnt automatisch mit steigender Gegnerzahl.
- Besiegte Gegner droppen zufällig Powerups (Doppelschaden oder schnellere Angriffe), die sich wie ein Magnet zum nächstgelegenen Tower bewegen und sich beim Einsammeln aktivieren.
- Wenn Gegner das Ziel erreichen, verlierst du Leben; bei 0 ist das Spiel pausiert.
