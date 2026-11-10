function fn() {
    var env = karate.env || 'qa';
    karate.log('karate.env is:', env);

    var config = {
        baseUrl: 'https://reqres.in/api'
    };

    if (env === 'dev') {
        config.baseUrl = 'https://reqres.in/api';
    } else if (env === 'staging') {
        config.baseUrl = 'https://reqres.in/api';
    }

    karate.configure('connectTimeout', 5000);
    karate.configure('readTimeout', 5000);
    return config;
}