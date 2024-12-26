import http from 'k6/http';
import { sleep, check } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 20 }, // Aumenta para 20 usuários em 1 minuto
    { duration: '3m', target: 20 }, // Mantém 20 usuários por 3 minutos
    { duration: '1m', target: 0 },  // Reduz para 0 usuários em 1 minuto
  ],
};

export default function () {
  const res = http.get('https://Loadbalancer-projeto-1014289289.us-east-1.elb.amazonaws.com'); // Substitua pela URL que você deseja testar
  check(res, {
    'status was 200': (r) => r.status === 200,
    'response time was < 500ms': (r) => r.timings.duration < 500,
  });
  sleep(1);
}
