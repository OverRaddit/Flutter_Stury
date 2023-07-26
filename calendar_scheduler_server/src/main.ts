import { NestFactory, Reflector } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ClassSerializerInterceptor } from '@nestjs/common';
import { ResponseDelayInterceptor } from './schedule/interceptor/response-delay.interceptor';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // ?
  app.useGlobalInterceptors(new ClassSerializerInterceptor(app.get(Reflector)));
  // 서버의 latency를 의도적으로 발생시킨다.
  app.useGlobalInterceptors(new ResponseDelayInterceptor());

  // swagger문서의 metadata를 기술한다.
  const config = new DocumentBuilder()
    .setTitle('Code Factory 샘플 API')
    .setDescription('골든래빗 스케쥴러 프로젝트 연습용')
    .setVersion('1.0')
    .addTag('schedule')
    .build();

  const document = SwaggerModule.createDocument(app, config);

  SwaggerModule.setup('api', app, document);

  await app.listen(3000);
}

bootstrap();
