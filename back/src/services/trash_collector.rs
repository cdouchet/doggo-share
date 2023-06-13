// use std::{
//     fs,
//     sync::mpsc::{channel, Receiver, Sender},
// };

// use actix_web::web::Data;
// use chrono::{DateTime, Duration, Utc};
// use diesel::{ExpressionMethods, QueryDsl, RunQueryDsl};
// use uuid::Uuid;

// use crate::{db::Pool, models::db::file::DoggoFile};

// #[derive(Debug)]
// pub enum TrashCollectorError {
//     AlreadyStopped,
//     AlreadyWatching,
// }

// #[derive(Debug)]
// pub struct TrashCollector {
//     pool: Data<Pool>,
//     stop_sender: Option<Sender<()>>,
//     stop_receiver: Option<Receiver<()>>,
// }

// impl TrashCollector {
//     pub fn new(pool: Data<Pool>) -> Self {
//         Self {
//             pool,
//             stop_receiver: None,
//             stop_sender: None,
//         }
//     }

//     fn send_stop_signal_unchecked(&self) {
//         self.stop_sender
//             .as_ref()
//             .unwrap()
//             .send(())
//             .expect("Fatal: Could not stop Trash Collector Service. Async thread is still running");
//     }

//     pub fn stop_watching_trashes(&mut self) -> Result<(), TrashCollectorError> {
//         match &self.stop_sender {
//             None => Err(TrashCollectorError::AlreadyStopped),
//             Some(_) => {
//                 self.send_stop_signal_unchecked();
//                 self.stop_sender = None;
//                 self.stop_receiver = None;
//                 Ok(())
//             }
//         }
//     }

//     pub fn start_watching_trashes<'a>(&'a mut self) -> Result<(), TrashCollectorError> {
//         if self.stop_receiver.is_some() {
//             return Err(TrashCollectorError::AlreadyWatching);
//         }
//         let (stop_sender, stop_receiver) = channel::<()>();
//         self.stop_sender = Some(stop_sender);
//         self.stop_receiver = Some(stop_receiver);
//         let conn = &mut self.pool.get().unwrap();
//         std::thread::spawn(move || {
//             use crate::schema::files;
//             loop {
//                 let fda = chrono::offset::Local::now() - Duration::days(5);
//                 match files::table
//                     .filter(files::created_at.le(fda))
//                     .load::<DoggoFile>(conn)
//                 {
//                     Err(err) => {
//                         eprintln!("Error filtering trashes : {err}");
//                         if self.stop_sender.is_some() {
//                             self.send_stop_signal_unchecked();
//                             break;
//                         }
//                     }
//                     Ok(trashes) => {
//                         for t in &trashes {
//                             let _ = fs::remove_file(t.local_url.clone());
//                         }
//                         let trashes_ids = (trashes as Vec<DoggoFile>)
//                             .iter()
//                             .map(|e| e.id)
//                             .collect::<Vec<Uuid>>();
//                         diesel::delete(files::table)
//                             .filter(files::id.eq_any(trashes_ids))
//                             .execute(conn)
//                             .expect("Fatal: Could not delete trashes");
//                     }
//                 }
//                 if self.stop_receiver.is_some()
//                     && self.stop_receiver.as_mut().unwrap().try_recv().is_ok()
//                 {
//                     break;
//                 }
//             }
//         });
//         Ok(())
//     }
// }