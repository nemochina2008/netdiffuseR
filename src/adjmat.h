/*******************************************************************************
* adjmat.h header function for adjmat.cpp
*******************************************************************************/
// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

#ifndef NETDIFFUSER_ADJMAT_
#define NETDIFFUSER_ADJMAT_

using namespace Rcpp;


arma::sp_mat edgelist_to_adjmat_cpp(
    const arma::mat & edgelist,
    NumericVector weights = NumericVector::create(),
    int n = 0,
    bool undirected = false,
    bool self = false,
    bool multiple = false
  );

arma::mat adjmat_to_edgelist_cpp(
    const arma::sp_mat & adjmat,
    bool undirected = true
  );

IntegerMatrix toa_diff_cpp(
    const IntegerVector & year
  );


List egonet_attrs_cpp(
    const arma::sp_mat & graph,
    const arma::uvec V,
    bool outer=true,
    bool self=true,
    bool valued=true
  );

arma::sp_umat approx_geodesicCpp(
    const arma::sp_mat & G,
    int n = 6,
    bool warn = false
);
#endif
