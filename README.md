# Pyramid Maker

Interactive tool to create climbing volumes and calculate the necessary angles at which to cut the plyboard.

Inspired by the [following video](https://www.youtube.com/watch?v=Lp2mkK2qPTc), but meant to allow arbitrary (convex?) polygons as a base.

# Todo:

### features, ui, interactivity

- [x] basic **framework**, rough visualization.
- [x] add **input** boxes for coordinates.
- [ ] **label** points.
- [ ] **presets** for some basic shapes that work well.
- [ ] **mouse** interactions, dragging of corners.
- [ ] **annotate** visualization with angles and lengths. Toggle button.
- [ ] compile and visualize **cut list**, calculate m<sup>2</sup> of material required.
- [ ] units!
- [ ] build instructions in README.
- [ ] hole placement for **T-Nuts**.

### math

- [ ] transform 2D Points into 3D.
- [ ] list of faces/triangles, make sure orientation is consistent.
- [ ] **calculate angles**.
- [ ] generate **random** shapes.
- [ ] create tests to check the math.

### code quality

- [x] **generalize** pyramid base shape, re-work types.
- [x] use arrays, cleanup everything.
- [ ] make ChangePoint message type simpler: pass `index` and `newCoordinates` instead of `index`, `axis` and `newValue`.
- [ ] always sort array of points by vector angle. (avoids certain nonsensical shapes).
- [ ] make pyramid tip changeable too, possibly re-work Pyramid type.

### stretch goals

- [ ] create front- and side**views**.
- [ ] button to round angles and dimensions to nearest degree or cm.
- [ ] possibility to specify the _length_ of certain edges (-> solve for point coordinates).
- [ ] visualization with material thickness.
- [ ] dotted line for edges behind visible faces.
- [ ] sanity checks and warnings for steep angles etc.
- [ ] **export** cut list svg as .jpg or .pdf.
- [ ] save/export/import pyramid parameters.
- [ ] smart arrangment of pieces to use minimal amount of sheet material (hard).
- [ ] isometric 3D visualization.
