rm(list=ls(all=TRUE))

# Apply the 'CBunadj' model to the applied example dataset using Stan.

# Stan set-up.
library("rstan")
rstan_options(auto_write = TRUE)
options(mc.cores = max(parallel::detectCores() - 1, 1))

# Define data.
data <- list(n_treatments = 3,
             # IPD
             n_patients = 30,
             n_studies = 3,
             n_arms = 6,
             Y = rep(0:1, 15),
             study = rep(1:3, each = 10),
             arm = rep(1:6, each = 5),
             treatment = rep(c(1, 2, 1, 3, 2, 3), each = 5),
             baseline = c(rep(1, 20), rep(2, 10)),
             treatment_arm = c(1, 2, 1, 3, 2, 3),
             baseline_arm = c(1, 1, 1, 1, 2, 2),
             # AD
             n_studies_ad = 3,
             n_arms_ad = 6,
             r = rep(50, 6),
             n = rep(100, 6),
             study_ad = rep(1:3, each = 2),
             treatment_ad = c(1, 2, 1, 3, 2, 3),
             baseline_ad = c(1, 1, 1, 1, 2, 2),
             # Priors
             m_m_phi = 0,
             s_m_phi = 100,
             l_sigma_phi = 0.01,
             u_sigma_phi = 100,
             l_sigma_delta = 0.01,
             u_sigma_delta = 100,
             m_d = 0,
             s_d = 100)

# Define initial values.
inits <- list(d = rep(0, data$n_treatments),
              p = rep(0.5, data$n_patients),
              phi = rep(0, data$n_studies),
              delta = rep(0, data$n_arms),
              m_phi = 0,
              sigma_phi = 1,
              m_delta = rep(0, data$n_arms),
              sigma_delta = 1,
              p_ad = rep(0.5, data$n_arms_ad),
              m_delta_ad = rep(0, data$n_arms_ad))

# Run Stan model.
model <- stan(paste0("bin/", "CBunadj/CBunadj.stan"),
              data = data,
              chains = 1,
              iter = 500,
              warmup = 250,
              init = list(inits))


