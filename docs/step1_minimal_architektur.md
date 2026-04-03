# Schritt 1 – Minimale Architektur (Godot 4.x, 2D Arena Survival)

## Knapper Umsetzungsplan (Reihenfolge)
1. **Architektur festziehen**: minimale modulare Struktur, Verantwortlichkeiten, Node-Bäume für Kernszenen.
2. Projektordner + leere Basisszenen/-skripte gemäß Struktur anlegen.
3. Basis-Navigation (MainMenu → CharacterSelect → Game → GameOver) anschließen.
4. Generisches Player- und Datenmodell (CharacterResource/Dictionary-basiert) integrieren.
5. Erste Gameplay-Loop-Version: Gegner-Spawn, XP-Orbs, Level-Up-Trigger, rudimentäres Upgrade-Panel.

> In diesem Schritt wird **nur Schritt 1** umgesetzt.

## Zielbild: minimale, erweiterbare Architektur

### Leitprinzipien
- **Datengetrieben**: Charaktere, Waffen, Gegner, Upgrades liegen als Daten, nicht als harte Klassenkopien.
- **Lose gekoppelte Systeme**: Kommunikation primär über Signale und klare Manager-Verantwortung.
- **Kleine, verständliche Skripte**: Jede Datei hat eine klare Aufgabe.
- **Gameplay-first**: Früher Fokus auf spielbare Kernschleife statt Vollausbau.

### Kernmodule (minimal)
- `Global` (Autoload): Spielsitzungszustand (gewählter Charakter, Run-Stats, Utility für Szenenwechsel).
- `Game`-Orchestrierung: startet Run, bindet Manager + HUD zusammen.
- `Player`: generische Spielfigur mit Datenobjekt (`character_id`, Basiswerte, Startwaffe).
- `Enemy`: einfacher Gegner mit HP, Bewegung auf Player, Death-Signal.
- `Wave/SpawnManager`: zeit-/intensitätsgesteuerter Spawn.
- `ProgressionManager`: XP, Level, Upgrade-Trigger.
- `WeaponSystem` (im Player oder ausgelagert): behandelt aktive Waffe(n) generisch.
- `HUD`: zeigt HP, XP, Level, Zeit/Wave.

### Daten statt Klassenkopien
Für spätere Klassen (Schwertkämpfer/Bogenschütze/Magier):
- Je Klasse ein Datensatz in `data/characters/` (Name, Basis-HP, Move-Speed, Startwaffe, passive Modifikatoren).
- Player lädt beim Spawn den gewählten Datensatz und setzt Werte dynamisch.
- Waffen verweisen auf Datensätze in `data/weapons/` + jeweilige Szenen (`SwordSlash`, `ArrowProjectile`, `MagicBolt`).

Dadurch bleibt `Player.gd` **eine** generische Klasse.

## Konkrete Node-Struktur (Vorschlag)

## 1) `MainMenu.tscn`
- `MainMenu` (`Control`)
  - `CenterContainer`
    - `VBoxContainer`
      - `TitleLabel` (`Label`)
      - `PlayButton` (`Button`)
      - `OptionsButton` (`Button`)
      - `QuitButton` (`Button`)

Verantwortung: Nur UI + Navigation.

## 2) `CharacterSelect.tscn`
- `CharacterSelect` (`Control`)
  - `MarginContainer`
    - `VBoxContainer`
      - `TitleLabel`
      - `CharacterList` (`ItemList` oder `VBoxContainer` mit Buttons)
      - `DescriptionLabel`
      - `HBoxContainer`
        - `BackButton`
        - `StartRunButton`

Verantwortung: verfügbare Charakterdaten laden, Auswahl in `Global` speichern, Spiel starten.

## 3) `Game.tscn`
- `Game` (`Node2D`)
  - `World` (`Node2D`)
    - `PlayerSpawn` (`Marker2D`)
    - `EnemyContainer` (`Node2D`)
    - `PickupContainer` (`Node2D`)
    - `ProjectileContainer` (`Node2D`)
  - `Managers` (`Node`)
    - `SpawnManager` (`Node`)
    - `ProgressionManager` (`Node`)
    - `RunManager` (`Node`)
  - `CanvasLayer`
    - `HUD` (instanzierte `HUD.tscn`)
    - `UpgradePanel` (instanziert, initial verborgen)

Verantwortung: zentrale Komposition aller Laufzeit-Systeme.

## 4) `Player.tscn`
- `Player` (`CharacterBody2D`)
  - `Sprite2D`
  - `CollisionShape2D`
  - `Hurtbox` (`Area2D`)
    - `CollisionShape2D`
  - `WeaponOrigin` (`Marker2D`)

Verantwortung: Bewegung, eingehender Schaden, Waffen-Trigger.

## Schnittstellen (minimal, für nächste Schritte)
- `Global.selected_character_id: String`
- `Player.setup_from_character_data(character_data: Dictionary)`
- `SpawnManager.start(run_seed: int)`
- `ProgressionManager.add_xp(amount: int)`
- Signale:
  - `Player.died`
  - `Enemy.died(xp_value, world_position)`
  - `ProgressionManager.level_up(new_level)`

## Nächster geplanter Schritt
- Ordner/Szenen/Skripte als **leere, lauffähige Basis** anlegen und MainMenu→CharacterSelect→Game verkabeln (ohne volles Kampfsystem).
