# softGlueZynq-mkioc

`softGlueZynq-mkioc` creates an APS-style EPICS IOC for
[softGlueZynq](https://github.com/epics-modules/softGlueZynq) from the bundled
`zzz` template.

## Usage

Run the script from the directory in which the new IOC should be created:

```sh
/path/to/softGlueZynq-mkioc/mkioc_sg IOC_NAME
```

The script copies the `zzz` directory, runs the synApps `changePrefix` utility,
updates startup paths and selected files, and makes the IOC startup and autosave
directories writable.

## Environment

This template is intended for the APS softGlueZynq environment. It currently
assumes:

- A synApps support tree configured by `SUPPORT` in `zzz/configure/RELEASE`,
  containing `utils/changePrefix`
- APS EPICS Base, synApps, display-manager, and utility paths referenced by the
  files under `zzz`
- A `linux-arm` IOC target

Review `zzz/configure/RELEASE` and the generated IOC's startup files before
using the template in a different environment.

## License

This repository is distributed under the Software License Agreement in
[`LICENSE`](LICENSE).
