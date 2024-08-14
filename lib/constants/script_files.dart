// List of filenames in the assets/r directory. We will want
// to generate this list from the actual contents. Apparently
// Flutter does not provide a built-in method to dynamically
// list files in the assets folder at runtime. So need to have
// this as a constant and a script to update the constant.

List<String> scriptFiles = [
  'main.R',
  'dataset_glimpse.R',
  'dataset_load_csv.R',
  'dataset_load_txt.R',
  'dataset_load_weather.R',
  'dataset_prep.R',
  'dataset_template.R',
  'explore_correlation.R',
  'explore_missing.R',
  'explore_summary.R',
  'explore_test_correlation.R',
  'explore_visual_categoric.R',
  'explore_visual_numeric.R',
  'model_build_cluster.R',
  'model_build_ctree.R',
  'model_build_random_forest.R',
  'model_build_rpart.R',
  'model_build_word_cloud.R',
  'model_template.R',
  'transform_clean_delete_ignored.R',
  'transform_clean_delete_obs_missing.R',
  'transform_clean_delete_selected.R',
  'transform_clean_delete_vars_missing.R',
  'transform_impute_constant.R',
  'transform_impute_mean_numeric.R',
  'transform_impute_median_numeric.R',
];
