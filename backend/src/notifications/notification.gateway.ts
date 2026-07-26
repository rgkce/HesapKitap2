import {
  WebSocketGateway,
  WebSocketServer,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@WebSocketGateway({  // Bu decorator ile WebSocket gateway oluşturulur
  cors: {
    origin: '*',      // Herhangi bir frontend URL’sinden gelen bağlantıya izin verir
  },
})
@Injectable()         // Servis olarak diğer sınıflara inject edilebilir
export class NotificationGateway
  implements OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer()
  server: Server;     // Socket.io server instance’ı, client’lara mesaj göndermek için kullanılır

  private connectedUsers: Record<string, string> = {};
  // Kullanıcı ID → Socket ID eşleştirmesi
  // Örn: { 15: 'socketId12345' }

  constructor(private readonly jwtService: JwtService) {}
  // JWT doğrulaması için NestJS JwtService inject edilir

  // =====================================================
  // 1) Kullanıcı socket'e bağlandığında: JWT doğrulama
  // =====================================================
  async handleConnection(client: Socket) {
    try {
      // Token farklı yerlerden alınabilir: auth objesi, header veya query param
      const token =
        client.handshake.auth?.token ||
        client.handshake.headers?.token ||
        client.handshake.query?.token;

      if (!token) {
        console.log('❌ Token yok → bağlantı reddedildi.');
        throw new UnauthorizedException(); // Token yoksa bağlantıyı reddet
      }

      // JWT doğrulama
      const payload = await this.jwtService.verifyAsync(String(token), {
        secret: process.env.JWT_SECRET,
      });

      if (!payload || !payload.sub) {
        console.log('❌ Geçersiz token payload');
        throw new UnauthorizedException(); // Token geçersizse bağlantıyı reddet
      }

      const userId = payload.sub; // JWT payload’dan kullanıcı ID’sini al

      // Kullanıcı ID ile socket ID eşleştirmesini kaydet
      this.connectedUsers[userId] = client.id;

      (client as any).userId = userId; 
      // Disconnect sırasında kullanmak için client objesine userId ekliyoruz

      console.log(`🔌 Kullanıcı bağlandı → userId: ${userId}, socket: ${client.id}`);
    } catch (err) {
      client.disconnect(); 
      // Hata olursa socket’i kapat
    }
  }

  // =====================================================
  // 2) Kullanıcı ayrıldığında: socket eşleşmesini sil
  // =====================================================
  handleDisconnect(client: Socket) {
    const userId = (client as any).userId; // client objesinden userId al

    if (userId) {
      delete this.connectedUsers[userId]; 
      // Bağlantı koptuğu için eşleşmeyi temizle
      console.log(`❌ Kullanıcı ayrıldı → userId: ${userId}`);
    }
  }

  // =====================================================
  // 3) Belirli kullanıcıya bildirim gönder
  // =====================================================
  sendNotificationToUser(userId: string, data: any) {
    const socketId = this.connectedUsers[userId]; 
    // Kullanıcının socket ID’sini bul

    if (!socketId) {
      console.log(`⚠ Kullanıcı çevrimdışı → userId: ${userId}`);
      return; // Kullanıcı online değilse gönderme
    }

    this.server.to(socketId).emit('notification', data); 
    // Socket.io ile bildirimi ilgili kullanıcıya gönder
  }

  // =====================================================
  // 4) Belirli role sahip tüm kullanıcılara bildirim gönder
  // =====================================================
  broadcastToRole(role: string, data: any) {
    for (const [userIdStr, socketId] of Object.entries(this.connectedUsers)) {
      // Bu örnekte role kontrolü yapılmıyor, ama production’da DB’den user rolü kontrol edilmeli
      this.server.to(socketId).emit('notification', data); 
      // Her socket’e broadcast et
    }
  }
}
