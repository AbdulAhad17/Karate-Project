function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log("karate.env system property was:", env);
  if (!env) {
    env = "qa";
  }

  var envConfig = read(`classpath:config/${env}.json`);

  var config = {
    env: env,
    ...envConfig,
    baseUrl: `https://api.${envConfig.host}`,
    eventsBaseUrl: `https://events.${envConfig.host}`,
    endpoints: {
      graphql: "/v1/graphql",
      patient_endpoint: "/api/auth/patient/",
      refresh_token_endpoint: "/api/auth/token/refresh/",
      verify_user_endpoint:'/api/auth/token/verify/',
      upgrade_token:'/api/auth/token/upgrade/',
      signup_user_endpoint:'/users/api/signup/',
    },
  };
  var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
  var sdf = new SimpleDateFormat('yyyyMMddHHmmss');
  var date = new java.util.Date();
  var timestamp = sdf.format(date);

  config.name_prefix = "AUTOMATION_" + timestamp;

  var Faker = Java.type('com.github.javafaker.Faker');
  config.faker = new Faker();

  return config;
}
