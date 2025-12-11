import {
  WebSocketGateway,
  WebSocketServer,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@WebSocketGateway({  //Frontend’ten bağlantıya izin verir.
  cors: {
    origin: '*',
  },
})
@Injectable()
export class NotificationGateway
  implements OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer()
  server: Server;

  private connectedUsers: Record<number, string> = {};

  constructor(private readonly jwtService: JwtService) {}


  // Kullanıcı socket'e bağlandığında: JWT doğrulama
  async handleConnection(client: Socket) {
    try {
      const token =
        client.handshake.auth?.token ||
        client.handshake.headers?.token ||
        client.handshake.query?.token;

      if (!token) {
        console.log('❌ Token yok → bağlantı reddedildi.');
        throw new UnauthorizedException();
      }

      // JWT doğrulama
      const payload = await this.jwtService.verifyAsync(String(token), {
        secret: process.env.JWT_SECRET,
      });

      if (!payload || !payload.sub) {
        console.log('❌ Geçersiz token payload');
        throw new UnauthorizedException();
      }

      const userId = payload.sub;

      // eşleştirme kaydı
      this.connectedUsers[userId] = client.id;

      (client as any).userId = userId; // disconnect'te kullanabilmek için client'a set ediyoruz

      console.log(`🔌 Kullanıcı bağlandı → userId: ${userId}, socket: ${client.id}`);
    } catch (err) {
      client.disconnect();
    }
  }

  // Kullanıcı ayrıldığında socket eşleşmesini sil
  handleDisconnect(client: Socket) {
    const userId = (client as any).userId;

    if (userId) {
      delete this.connectedUsers[userId];
      console.log(`❌ Kullanıcı ayrıldı → userId: ${userId}`);
    }
  }

  // Belirli kullanıcıya bildirim gönder
  sendNotificationToUser(userId: number, data: any) {
    const socketId = this.connectedUsers[userId];

    if (!socketId) {
      console.log(`⚠ Kullanıcı çevrimdışı → userId: ${userId}`);
      return;
    }

    this.server.to(socketId).emit('notification', data);
  }

  // Belirli role sahip tüm kullanıcılara gönder
  broadcastToRole(role: string, data: any) {
    for (const [userIdStr, socketId] of Object.entries(this.connectedUsers)) {
      // Burada user rolünü DB'den kontrol edebilirsin
      this.server.to(socketId).emit('notification', data);
    }
  }
}
