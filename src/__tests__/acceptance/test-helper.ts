import { Loopback4StarterApplication as ToDoListApplication } from '../..';
import {
  createRestAppClient,
  givenHttpServerConfig,
  Client,
} from '@loopback/testlab';
import { AuthenticationBindings } from 'loopback4-authentication';

export async function setupApplication(): Promise<AppWithClient> {
  const restConfig = givenHttpServerConfig({
    // Customize the server configuration here.
    // Empty values (undefined, '') will be ignored by the helper.
    //
    // host: process.env.HOST,
    // port: +process.env.PORT,
  });

  const app = new ToDoListApplication({
    rest: restConfig,
  });

  await app.boot();

  app.bind('datasources.config.pgdb').to({
    name: 'pgdb',
    connector: 'memory',
  });

  app.bind(AuthenticationBindings.CURRENT_USER).to({
    id: 1,
    username: 'test_user',
    password: process.env.USER_TEMP_PASSWORD,
  });
  await app.start();

  const client = createRestAppClient(app);

  return { app, client };
}

export interface AppWithClient {
  app: ToDoListApplication;
  client: Client;
}
