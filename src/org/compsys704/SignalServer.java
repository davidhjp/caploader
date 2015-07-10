package org.compsys704;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Arrays;

public class SignalServer implements Runnable {
	public static final int SERVER_PORT = 20000;
	public static final String IP = "127.0.0.1";

	class Worker implements Runnable{

		String signame = null;
		Socket socket = null;
		public Worker (Socket s){ this.socket = s; }

		public void setSignal(boolean status){
			switch(signame){
			case "pusherRetracted":
				States.PUSHER_RETRACTED = status;
				break;
			case "pusherExtended":
				States.PUSHER_EXTENDED = status;
				if(!States.MAG_EMPTY)
					States.CAP_READY = true;
				break;
			case "ICgripped":
				if(States.GRIPPED){
					if(!status){
						States.CAP_READY = false;
					}
				}
				States.GRIPPED = status;
				break;
			case "armAtSource":
				States.ARM_AT_SOURCE = status;
				break;
			case "armAtDest":
				States.ARM_AT_DEST = status;
				break;
			case "empty":
				States.MAG_EMPTY = status;
				break;
			}
		}

		@Override
		public void run() {
			try {
				ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
				while(true){
					Object[] o = (Object[])ois.readObject();
					if((Boolean)o[0]){
						signame = (String)o[1];
						setSignal((Boolean)o[0]);
					}
					else{
						if(signame != null){
							setSignal((Boolean)o[0]);
						}
					}
				}
			} 
			catch (IOException e) {}
			catch (ClassNotFoundException e){e.printStackTrace();}
			finally{
				try {
					socket.close();
				} catch (IOException e1) {
					e1.printStackTrace();
				}
			}
		}
	}

	@Override
	public void run() {
		try {
			ServerSocket ss = new ServerSocket(SERVER_PORT, 50, InetAddress.getByName(IP));
			while(true){
				Socket s = ss.accept();
				new Thread(new Worker(s)).start();
			}
		} catch (IOException e) {
			e.printStackTrace();
			System.exit(1);;
		}
	}

}
