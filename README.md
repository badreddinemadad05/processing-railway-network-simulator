# Processing Railway Network Simulator

## Overview

This project is a railway traffic simulation built with Processing in Java mode. It visualizes train movements across a small rail network composed of four main stations, four secondary stations, straight track sections, switches, curved junctions, and traffic lights.

The application was designed as an academic simulation project focused on train dispatching, track occupation, and basic collision-handling scenarios inside a shared railway infrastructure.

## Project Goals

- Simulate train movement between multiple stations
- Visualize railway traffic in real time
- Manage station capacity and track assignment
- Model switches, curved track sections, and signaling
- Detect selected traffic conflicts and trigger return procedures

## Main Features

- Interactive graphical simulation built with Processing
- Manual train creation through 12 route buttons
- Four main stations: `Gare1`, `Gare2`, `Gare3`, `Gare4`
- Four secondary stations: `SA`, `SB`, `SC`, `SD`
- Straight track segments and Bezier-based curved deviations
- Signal lights that react to station occupancy
- Dispatching panel showing information about a selected train
- Collision and congestion management for specific traffic situations

## How It Works

The simulation starts by building the full rail network inside the main sketch:

- stations and secondary stations are positioned on the canvas
- tracks, switches, and curved deviations are created
- signal lights are initialized
- image assets are loaded from the `data/` directory
- route buttons are displayed for train spawning

During execution, the program continuously:

- redraws the railway map
- updates train positions
- manages station entry and exit
- assigns free tracks
- updates traffic lights
- applies route-specific logic
- handles selected collision and return cases

## Technologies Used

- Processing
- Java mode for Processing
- Processing graphics API (`PApplet`, `PImage`, drawing primitives)
- Java collections (`ArrayList`)

## Project Structure

```text
processing-railway-network-simulator/
|-- Processing/
|   |-- redaprocessingaout.pde   # Main sketch: setup, draw, network initialization, routing
|   |-- Train.pde                # Train model and movement state
|   |-- Gare.pde                 # Main station logic
|   |-- GareSecondaire.pde       # Secondary station logic
|   |-- Bande.pde                # Straight track sections
|   |-- Deviation.pde            # Curved routes, return logic, collision handling
|   |-- Aiguillage.pde           # Switch management
|   |-- Feu.pde                  # Traffic light logic
|   |-- dispatching.pde          # Dispatching / supervision panel
|   |-- Bouton.pde               # UI buttons for spawning trains
|   |-- Itineraire.pde           # Simple itinerary structure
|   |-- data/                    # Images and supporting resources
|-- rapportProjetGroupeProcessing.pdf
|-- README.md
```

## Installation

### Requirements

- Processing IDE 4.x recommended

### Steps

1. Open Processing IDE.
2. Open the `Processing/` folder from this project.
3. Make sure the `Processing/data/` folder is present and still contains the required image assets.
4. Run the main sketch from `redaprocessingaout.pde`.

## Usage

- Launch the sketch in Processing.
- Use the route buttons at the bottom of the window to spawn trains.
- Click on a train to display its information in the dispatching panel.
- Observe how trains move through stations, secondary hubs, switches, and curved segments while the system manages occupancy and some conflict situations.

## Configuration

This project does not use an external configuration file.

Most parameters are hard-coded inside the `.pde` files, including:

- window size
- station coordinates
- track geometry
- station capacity
- pause durations
- Bezier movement speeds

## Database

No database is used in this project.

## API / Backend

This project does not include:

- a remote API
- a backend service
- database access
- deployment scripts

All logic is embedded directly in the Processing sketch files.

## Docker

There is no `Dockerfile` or `docker-compose` configuration in this repository.

## Important Technical Notes

- Some routes appear in the interface but are not fully implemented in the main movement logic, especially `G1 -> G3` and `G3 -> G1`.
- The project contains some unused or partially used resources and variables, such as `Itineraire`, `image_raille`, and a few files stored in `Processing/data/`.
- Several strings in the source code show encoding issues, likely caused by a UTF-8 / ANSI mismatch.
- The `Processing/data/` folder also contains PDF files that look like project or course documents rather than runtime dependencies.

## Strengths

- Clear visual representation of a railway network
- Good educational value for railway dispatching concepts
- Separation of logic across multiple Processing tabs
- Includes supervision, signaling, and route management ideas

## Limitations

- The routing logic is highly centralized in the main sketch
- Some route flows are incomplete
- The project does not include automated tests
- Several rules are implemented with hard-coded conditions, which makes maintenance more difficult

## Authors

- Group 10
- EL HARCHA
- ESSALHI
- MADAD
- FASKA

## Status

Academic Processing project for railway dispatching and traffic simulation.
