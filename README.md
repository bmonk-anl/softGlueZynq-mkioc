# softGlueZynq-mkioc

`softGlueZynq-mkioc` creates an APS-style EPICS IOC for
[softGlueZynq](https://github.com/epics-modules/softGlueZynq) from a bundled
template.

## Usage

Run the script from the directory in which the new IOC should be created:

```sh
/path/to/softGlueZynq-mkioc/mkioc_sg IOC_NAME
```

The default `zzz` template supports the reg64 BCDALAB firmware. To generate an
IOC for the older reg32 firmware, select the preserved `zzz-reg32` template:

```sh
/path/to/softGlueZynq-mkioc/mkioc_sg -t reg32 IOC_NAME
```

The script copies the selected template, runs the synApps `changePrefix`
utility, updates startup paths and selected files, and makes the IOC startup
and autosave directories writable.

## Templates

- `zzz` uses `softGlueReg64_`, the 64-bit BCDALAB register database, and DMA
  FIFO-word register 93. It also loads the clock configuration menu database
  and selects the reg64-capable `softGlueZynq_sendalld` support tree.
- `zzz-reg32` preserves the previous `softGlueReg32_` configuration and DMA
  FIFO-word register 61.

## Environment

The templates are intended for the APS softGlueZynq environment. They currently
assume:

- A synApps support tree configured by `SUPPORT` in the selected template's
  `configure/RELEASE`, containing `utils/changePrefix`
- APS EPICS Base, synApps, display-manager, and utility paths referenced by the
  template
- A `linux-arm` IOC target
- BCDALAB firmware matching the selected register width

Review `configure/RELEASE` and the startup files in a generated IOC before using
the template in a different environment.

## License

This repository is distributed under the Software License Agreement in
[`LICENSE`](LICENSE).
