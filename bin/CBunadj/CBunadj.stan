data {
  // IPD
  int <lower=1> n_patients;
  int <lower=0, upper=1>  Y[n_patients];  // binary response
  int <lower=1>  study[n_patients];
  int <lower=1>  arm[n_patients];
  int <lower=1>  treatment[n_patients];
  int <lower=1>  baseline[n_patients];
  
  // AD
  // int <lower=1> n_arms_ad;
  // int <lower=0> r[n_arms_ad];  // no. of responders
  // int <lower=0> n[n_arms_ad];  // no. of participants
  // int <lower=1> study_ad[n_arms_ad];
  // int <lower=1> treatment_ad[n_arms_ad];
  // int <lower=1> baseline_ad[n_arms_ad];
  
  //Priors
  // real <lower=0> prior_sd_m_phi;
  // real <lower=0> prior_lower_sigma_phi;
  // real prior_upper_sigma_phi;
  // real <lower=0> prior_lower_sigma_delta;
  // real prior_upper_sigma_delta;
  // real <lower=0> prior_sd_d;
}
transformed data{
  // int <lower=2> n_treatments = max(treatment);
  // IPD
  int <lower=1> n_studies = max(study);
  int <lower=1> n_arms = max(arm);
  // int <lower=1>  treatment_arm[n_arms];
  // int <lower=1>  baseline_arm[n_arms];
  // AD
  // int <lower=1> n_studies_ad = max(study_ad);
}
parameters{
  // real d[n_treatments];  // basic parameters
  real phi[n_studies];  // baseline effects
  real m_phi;
  real <lower=0> sigma_phi;
  real delta[n_arms];
}
transformed parameters{
  vector[n_patients] eta;
  
  // Linear predictor
  for (j in 1:n_patients){
    if (treatment[j] != baseline[j]) eta[j] = phi[study[j]] + delta[arm[j]];
    else eta[j] = phi[study[j]];
  }
}
model{
  // Declarations
  // real m_delta[n_arms];
  // real sigma_delta;
  // real p_ad[n_arms_ad];
  // real m_delta_ad[n_arms_ad];
  
  // Model for IPD
  Y ~ bernoulli_logit(eta);  // likelihood
  
  for (i in 1:n_studies){
    phi[i] ~ normal(m_phi, sigma_phi);  // random baseline effects
  }
  // for (k in 1:n_arms){
  //   delta[k] ~ normal(m_delta[k], sigma_delta);  // random relative effects
  //   m_delta[k] = d[treatment_arm[k]] - d[baseline_arm[k]];
  // }
  // 
  // // Model for AD
  // for (k in 1:n_arms_ad){
  //   r[k] ~ binomial_logit(n[k], p_ad[k]);
  //   if (treatment_ad[k] != baseline_ad[k]){
  //      p_ad[k] = phi[study_ad[k] + n_studies] + delta[k + n_arms];
  //   } else {
  //     p_ad[k] = phi[study_ad[k] + n_studies];
  //   }
  //   delta[k + n_arms] ~ normal(m_delta_ad, sigma_delta);
  //   m_delta_ad[k] = d[treatment_ad[k]] - d[baseline_ad[k]];
  // }
  // 
  // for (i in 1:n_studies_ad){
  //   phi[study_ad[i] + n_studies] ~ normal(m_phi, sigma_phi);
  // }
  // 
  // // Priors
  // m_phi ~ normal(m_m_phi, s_m_phi);
  // sigma_phi ~ uniform(l_sigma_phi, u_sigma_phi);
  // sigma_delta ~ uniform(l_sigma_delta, u_sigma_delta);
  // for (t in 1:n_treatments){
  //   d[t] ~ normal(m_d, s_d);
  // }
}
