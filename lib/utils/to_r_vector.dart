String toRVector(List<String> vars) {
  //  c("location", "date", "min_temp", "sunshine")
  // Build the string in R vector format
  return 'c(${vars.map((v) => '"$v"').join(', ')})';
}
