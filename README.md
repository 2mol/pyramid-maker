# Pyramid Maker

Interactive tool to create pyramid-shaped climbing volumes and calculate the necessary angles at which to cut your material.

Use it at [https://talhoffer.github.io/pyramid-maker/](https://talhoffer.github.io/pyramid-maker/).

Inspired by the [following video](https://www.youtube.com/watch?v=Lp2mkK2qPTc), but meant to allow arbitrary polygons as a base.

## Todo:

### features, ui, interactivity

- [x] basic framework, rough visualization.
- [x] add input boxes for coordinates.
- [ ] presets for some basic shapes that work well.
- [x] mouse interactions, dragging of corners.
- [ ] annotatations for angles and lengths. On/off toggle button.
- [ ] change annotations text to non-active svg text.
- [ ] cut list, calculate m<sup>2</sup> of material required.
- [ ] units!
- [ ] buttons to scale up or down. Button to scale to fill canvas.
- [ ] fields for each edge, ability to directly set length of an edge.
- [ ] build instructions in README.
- [ ] hole placement for T-Nuts.

### math

- [x] new Point3D type, conversion function for pyramid base-polygon + tip into 3D. Rename `Point` to `Point2D`.
- [x] list of faces/triangles, make sure orientation is consistent.
- [ ] calculate angles.
- [x] generate random shapes.
- [ ] create tests to check the math.

### code quality

- [x] generalize pyramid base shape, re-work types.
- [x] use arrays, cleanup everything.
- [x] make ChangePoint message type simpler: pass `index` and new `Point` instead of `index`, `axis` and `newValue`.
- [x] always draw edges in order of vector angle. (avoids certain nonsensical shapes).
- [x] make pyramid tip changeable too, possibly re-work Pyramid type.
- [ ] simplify how mouse action messages change the pyramid part of the model.

### stretch goals

- [ ] create front- and sideviews.
- [ ] CSS instead of styling in code
- [ ] button to round angles and dimensions to nearest degree or cm.
- [ ] possibility to specify the _length_ of certain edges (-> solve for point coordinates).
- [ ] visualization with material thickness.
- [ ] dotted line for edges behind visible faces.
- [ ] sanity checks and warnings for steep angles etc.
- [ ] export cut list svg as .jpg or .pdf.
- [ ] save/export/import pyramid parameters.
- [ ] smart arrangment of pieces to use minimal amount of sheet material (hard).
- [ ] isometric 3D visualization.
