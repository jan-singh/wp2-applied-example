
- The aim of work package 2 is to develop methods which can synthesise data from
RCTs and single-arm studies in a network meta-analysis, using a mixture of 
aggregate data (AD) and individual participant data (IPD).


- This project applies the contrast- and arm-based models, which combine the 
approaches by Saramago et al (2012) and Hong et al (2016), to synthesise AD and 
IPD under a network meta-analysis framework.

- The models are implemented using R2OpenBUGS.

- The applied datasets consist of RCTs assessing biologic therapies, providing 
data on the ACR20 outcome at 24 weeks.

- The first-line network consists of AD from 11 RCTs and IPD from a RCT by Roche
(WA17822), assessing 8 interventions in total.

- The second-line network consists of AD from 3 studies and IPD from a RCT by
Roche (WA17042), assessing 4 interventions in total.

- To mimic IPD from a single-arm study, the control arms are dropped from the 
Roche RCTs when applying the models.

- The models with covariate adjustment are applied both with random and common
interactions.


Models:
- 'CBunadj' is the contrast-based model with no covariate adjustment.

- 'CBadj' is the contrast-based model with covariate adjustment, and random
unpartitioned interactions.

- 'CBadjEB' is the contrast-based model with covariate adjustment, and random
interactions partitioned into within- and between-study interactions.

- 'CBadjEBcommon' is the contrast-based model with covariate adjustment, and
common interactions partitioned into within- and between-study interactions.

