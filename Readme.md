**Adaptive Recommenders: Personalized Prediction Aggregation Through Accuracy Estimation**

In the field of artificial intelligence,
*recommender systems* are user modeling methods
that can predict the relevance of an item to a user.
Items can be just about anything: 
documents, articles, movies, music, events or other users.
Recommender systems examine data such as ratings, query logs,
user behaviour and social connections to predict
what each user will think of each available item.

Modern recommender systems use ensemble learning techniques,
combining multiple standard recommenders,
in order to leverage disjoint patterns in the available data.
By combining different methods,
complex predictions that rely on much evidence can be made.
These aggregations are done on a generalized level,
often by weighting each recommender in a way
that achieves an optimal result.

However, we posit these systems have an important weakness.
There exists an underlying, misplaced subjectivity to relevance prediction.
Each chosen recommender system reflects one view of 
how each user and item *should* be modeled.
We believe the selection of recommender methods should 
be adaptively and automatically chosen based on
how accurate each prediction is likely to be for each user and item.
After all, a system that insists on being adaptive
in one particular way is not really adaptive at all.

This thesis presents a novel method for prediction aggregation,
called *adaptive recommenders*.
Multiple recommender systems are combined on a per-user and per-item basis
by estimating how accurate each recommender will be for the current user and item.
This is done by creating a set of secondary error estimating recommenders.
The core insight is that standard recommenders can be used
to estimate the accuracy of other recommenders, for each
user/item pair.
As far as we know, this type of adaptive prediction aggregation
has not been done before.

We test prediction aggregation (combining scores) in a
recommendation scenario,
and rank aggregation (sorting results lists) in a personalized search scenario.
Our initial results are promising, showing that adaptive recommenders
can outperform both standard recommenders and simple aggregation methods.
We also discuss the implications and limitations of our results.

The paper can be found in the "thesis/dist" folder, 
and the corresponding implementation in the "code" folder.

---

This is a Master Thesis in the field of Artificial Intelligence,
as part of my degree in Computer Science
at the Norwegian University of Science and Technology (NTNU).

