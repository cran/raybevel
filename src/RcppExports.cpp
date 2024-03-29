// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppThread.h>
#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// convert_ss_to_polygons_rcpp
List convert_ss_to_polygons_rcpp(List ss, int numbercores, bool progress);
RcppExport SEXP _raybevel_convert_ss_to_polygons_rcpp(SEXP ssSEXP, SEXP numbercoresSEXP, SEXP progressSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List >::type ss(ssSEXP);
    Rcpp::traits::input_parameter< int >::type numbercores(numbercoresSEXP);
    Rcpp::traits::input_parameter< bool >::type progress(progressSEXP);
    rcpp_result_gen = Rcpp::wrap(convert_ss_to_polygons_rcpp(ss, numbercores, progress));
    return rcpp_result_gen;
END_RCPP
}
// generate_offset_links_nodes_rcpp
List generate_offset_links_nodes_rcpp(DataFrame ss_links, DataFrame ss_nodes, NumericVector offsets, bool return_polys, bool progress);
RcppExport SEXP _raybevel_generate_offset_links_nodes_rcpp(SEXP ss_linksSEXP, SEXP ss_nodesSEXP, SEXP offsetsSEXP, SEXP return_polysSEXP, SEXP progressSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< DataFrame >::type ss_links(ss_linksSEXP);
    Rcpp::traits::input_parameter< DataFrame >::type ss_nodes(ss_nodesSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type offsets(offsetsSEXP);
    Rcpp::traits::input_parameter< bool >::type return_polys(return_polysSEXP);
    Rcpp::traits::input_parameter< bool >::type progress(progressSEXP);
    rcpp_result_gen = Rcpp::wrap(generate_offset_links_nodes_rcpp(ss_links, ss_nodes, offsets, return_polys, progress));
    return rcpp_result_gen;
END_RCPP
}
// is_ccw_polygon
bool is_ccw_polygon(NumericMatrix vertices);
RcppExport SEXP _raybevel_is_ccw_polygon(SEXP verticesSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type vertices(verticesSEXP);
    rcpp_result_gen = Rcpp::wrap(is_ccw_polygon(vertices));
    return rcpp_result_gen;
END_RCPP
}
// is_simple_polygon
bool is_simple_polygon(NumericMatrix vertices);
RcppExport SEXP _raybevel_is_simple_polygon(SEXP verticesSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type vertices(verticesSEXP);
    rcpp_result_gen = Rcpp::wrap(is_simple_polygon(vertices));
    return rcpp_result_gen;
END_RCPP
}
// skeletonize_rcpp
List skeletonize_rcpp(NumericMatrix vertices, List holes, double offset);
RcppExport SEXP _raybevel_skeletonize_rcpp(SEXP verticesSEXP, SEXP holesSEXP, SEXP offsetSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type vertices(verticesSEXP);
    Rcpp::traits::input_parameter< List >::type holes(holesSEXP);
    Rcpp::traits::input_parameter< double >::type offset(offsetSEXP);
    rcpp_result_gen = Rcpp::wrap(skeletonize_rcpp(vertices, holes, offset));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_raybevel_convert_ss_to_polygons_rcpp", (DL_FUNC) &_raybevel_convert_ss_to_polygons_rcpp, 3},
    {"_raybevel_generate_offset_links_nodes_rcpp", (DL_FUNC) &_raybevel_generate_offset_links_nodes_rcpp, 5},
    {"_raybevel_is_ccw_polygon", (DL_FUNC) &_raybevel_is_ccw_polygon, 1},
    {"_raybevel_is_simple_polygon", (DL_FUNC) &_raybevel_is_simple_polygon, 1},
    {"_raybevel_skeletonize_rcpp", (DL_FUNC) &_raybevel_skeletonize_rcpp, 3},
    {NULL, NULL, 0}
};

RcppExport void R_init_raybevel(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
