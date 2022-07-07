/// The invocation `colorize()` colors its children
/// with the color at the index `$csi` in the palette `$csp`.
module colorize() {
  color($csp[$csi % len($csp)])
    children();
}
