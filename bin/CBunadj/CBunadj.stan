data {
  int <lower=1> n_treatments;
  // IPD
  int <lower=1> n_patients;
  int <lower=1> n_studies;
  int <lower=1> n_arms;
  int <lower=0, upper=1>  Y[n_patients];  // binary response
  int <lower=1>  study[n_patients];
  int <lower=1>  arm[n_patients];
  int <lower=1>  treatment[n_patients];
  int <lower=1>  baseline[n_patients];
  int <lower=1>  treatment_arm[n_arms];
  int <lower=1>  baseline_arm[n_arms];
  // AD
  int <lower=1> n_studies_ad;
  int <lower=1> n_arms_ad;
  int <lower=0> r[n_arms_ad];  // no. of responders
  int <lower=0> n[n_arms_ad];  // no. of participants
  int <lower=1> study_ad[n_arms_ad];
  int <lower=1> treatment_ad[n_arms_ad];
  int <lower=1> baseline_ad[n_arms_ad];
  //Priors
  real m_m_phi;
  real <lower=0> s_m_phi;
  real <lower=0> l_sigma_phi;
  real u_sigma_phi;
  real <lower=0> l_sigma_delta;
  real u_sigma_delta;
  real m_d;
  real <lower=0> s_d;
}
parameters{
  real d[n_treatments];  // basic parameters
}
model{
  // Declarations
  real p[n_patients];
  real phi[n_studies];  // baseline effects
  real delta[n_arms];  // relative effects
  real m_phi;
  real sigma_phi;
  real m_delta[n_arms];
  real sigma_delta;
  real p_ad[n_arms_ad];
  real m_delta_ad[n_arms_ad];
  
  // Model for IPD
  for (j in 1:n_patients){
    Y[j] ~ bernoulli_logit(p[j]);  // likelihood
    if (treatment[j] != baseline[j]){
       p[j] = phi[study[j]] + delta[arm[j]];
    } else {
      p[j] = phi[study[j]];
    }
  }
  for (i in 1:n_studies){
    phi[i] ~ normal(m_phi, sigma_phi);  // random baseline effects
  }
  for (k in 1:n_arms){
    delta[k] ~ normal(m_delta[k], sigma_delta);  // random relative effects
    m_delta[k] = d[treatment_arm[k]] - d[baseline_arm[k]];
  }
  
  // Model for AD
  for (k in 1:n_arms_ad){
    r[k] ~ binomial_logit(n[k], p_ad[k]);
    if (treatment_ad[k] != baseline_ad[k]){
       p_ad[k] = phi[study_ad[k] + n_studies] + delta[k + n_arms];
    } else {
      p_ad[k] = phi[study_ad[k] + n_studies];
    }
    delta[k + n_arms] ~ normal(m_delta_ad, sigma_delta);
    m_delta_ad[k] = d[treatment_ad[k]] - d[baseline_ad[k]];
  }
  
  for (i in 1:n_studies_ad){
    phi[study_ad[i] + n_studies] ~ normal(m_phi, sigma_phi);
  }
  
  // Priors
  m_phi ~ normal(m_m_phi, s_m_phi);
  sigma_phi ~ uniform(l_sigma_phi, u_sigma_phi);
  sigma_delta ~ uniform(l_sigma_delta, u_sigma_delta);
  for (t in 1:n_treatments){
    d[t] ~ normal(m_d, s_d);
  }
}
