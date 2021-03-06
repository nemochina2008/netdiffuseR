% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/adjmat.r
\name{edgelist_to_adjmat}
\alias{edgelist_to_adjmat}
\alias{adjmat_to_edgelist}
\title{Conversion between adjacency matrix and edgelist}
\usage{
edgelist_to_adjmat(edgelist, w = NULL, t0 = NULL, t1 = NULL, t = NULL,
  simplify = TRUE, undirected = getOption("diffnet.undirected"),
  self = getOption("diffnet.self"),
  multiple = getOption("diffnet.multiple"), keep.isolates = TRUE,
  recode.ids = TRUE)

adjmat_to_edgelist(graph, undirected = getOption("diffnet.undirected", FALSE),
  keep.isolates = getOption("diffnet.keep.isolates", TRUE))
}
\arguments{
\item{edgelist}{Two column matrix/data.frame in the form of ego -source- and
alter -target- (see details).}

\item{w}{Numeric vector. Strength of ties (optional).}

\item{t0}{Integer vector. Starting time of the ties (optional).}

\item{t1}{Integer vector. Finishing time of the ties (optional).}

\item{t}{Integer scalar. Repeat the network \code{t} times (if no \code{t0,t1} are provided).}

\item{simplify}{Logical scalar. When TRUE and \code{times=NULL} it will return an adjacency
matrix, otherwise an array of adjacency matrices.
(see details).}

\item{undirected}{Logical scalar. When \code{TRUE} only the lower triangle of the adjacency matrix will considered (faster).}

\item{self}{Logical scalar. When \code{TRUE} autolinks (loops, self edges) are allowed (see details).}

\item{multiple}{Logical scalar. When \code{TRUE} allows multiple edges.}

\item{keep.isolates}{Logical scalar. When FALSE, rows with \code{NA/NULL} values
(isolated vertices unless have autolink) will be droped (see details).}

\item{recode.ids}{Logical scalar. When TRUE ids are recoded using \code{\link{as.factor}}
(see details).}

\item{graph}{Any class of accepted graph format (see \code{\link{netdiffuseR-graphs}}).}
}
\value{
In the case of \code{edgelist_to_adjmat} either an adjacency matrix
(if times is NULL) or an array of these (if times is not null). For
\code{adjmat_to_edgelist} the output is an edgelist with the following columns:
\item{ego}{Origin of the tie.}
\item{alter}{Target of the tie.}
\item{value}{Value in the adjacency matrix.}
\item{time}{Either a 1 (if the network is static) or the time stamp of the tie.}
}
\description{
Generates adjacency matrix from an edgelist and vice versa.
}
\details{
When converting from edglist to adjmat the function will \code{\link{recode}} the
edgelist before starting. The user can keep track after the recording by checking
the resulting adjacency matrices' \code{\link{row.names}}. In the case that the
user decides skipping the recoding (because wants to keep vertices index numbers,
implying that the resulting graph will have isolated vertices), he can override
this by setting \code{recode.ids=FALSE} (see example).

When multiple edges are included, \code{multiple=TRUE},each vertex between \eqn{\{i,j\}}{{i,j}} will be counted
as many times it appears in the edgelist. So if a vertex \eqn{\{i,j\}}{{i,j}} appears 2
times, the adjacency matrix element \code{(i,j)} will be 2.

Edges with incomplete information (missing data on \code{w} or \code{times}) are
not included on the graph. Incomplete cases are tagged using \code{\link{complete.cases}}
and can be retrieved by the user by accessing the attribute \code{incomplete}.

Were the case that either ego or alter are missing (i.e. \code{NA} values), the
function will either way include the non-missing vertex. See below for an example
of this.

The function performs several checks before starting to create the adjacency
matrix. These are:
\itemize{
 \item{Dimensions of the inputs, such as number of columns and length of vectors}
 \item{Having complete cases. If anly edge has a non-numeric value such as NAs or
 NULL in either \code{times} or \code{w}, it will be
 removed. A full list of such edges can be retrieved from the attribute
 \code{incomplete}}
 \item{Nodes and times ids coding}
}

\code{recode.ids=FALSE} is useful when the vertices ids have already been
coded. For example, after having use \code{adjmat_to_edgelist}, ids are
correctly encoded, so when going back (using \code{edgelist_to_adjmat})
\code{recode.ids} should be FALSE.
}
\examples{
# Base data
set.seed(123)
n <- 5
edgelist <- rgraph_er(n, as.edgelist=TRUE, p=.2)[,c("ego","alter")]
times <- sample.int(3, nrow(edgelist), replace=TRUE)
w <- abs(rnorm(nrow(edgelist)))

# Simple example
edgelist_to_adjmat(edgelist)
edgelist_to_adjmat(edgelist, undirected = TRUE)

# Using w
edgelist_to_adjmat(edgelist, w)
edgelist_to_adjmat(edgelist, w, undirected = TRUE)

# Using times
edgelist_to_adjmat(edgelist, t0 = times)
edgelist_to_adjmat(edgelist, t0 = times, undirected = TRUE)

# Using times and w
edgelist_to_adjmat(edgelist, t0 = times, w = w)
edgelist_to_adjmat(edgelist, t0 = times, undirected = TRUE, w = w)

# Not recoding ----------------------------------------------------
# Notice that vertices 3, 4 and 5 are not present in this graph.
graph <- matrix(c(
 1,2,6,
 6,6,7
), ncol=2)

# Generates an adjmat of size 4 x 4
edgelist_to_adjmat(graph)

# Generates an adjmat of size 7 x 7
edgelist_to_adjmat(graph, recode.ids=FALSE)

# Dynamic with spells -------------------------------------------------------
edgelist <- rbind(
   c(1,2,NA,1990),
   c(2,3,NA,1991),
   c(3,4,1991,1992),
   c(4,1,1992,1993),
   c(1,2,1993,1993)
)

graph <- edgelist_to_adjmat(edgelist[,1:2], t0=edgelist[,3], t1=edgelist[,4])

# Creating a diffnet object with it so we can apply the plot_diffnet function
diffnet <- as_diffnet(graph, toa=1:4)
plot_diffnet(diffnet, label=rownames(diffnet))

# Missing alter in the edgelist ---------------------------------------------
data(fakeEdgelist)

# Notice that edge 202 is isolated
fakeEdgelist

# The function still includes vertex 202
edgelist_to_adjmat(fakeEdgelist[,1:2])

edgelist

}
\seealso{
Other data management functions: \code{\link{diffnet-class}},
  \code{\link{egonet_attrs}}, \code{\link{isolated}},
  \code{\link{survey_to_diffnet}}
}
\author{
George G. Vega Yon, Stephanie R. Dyal, Timothy B. Hayes & Thomas W. Valente
}
\keyword{manip}
