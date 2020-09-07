Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADE7260006
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Sep 2020 18:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730909AbgIGQm5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Sep 2020 12:42:57 -0400
Received: from mail-qv1-f49.google.com ([209.85.219.49]:42937 "EHLO
        mail-qv1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730918AbgIGQmv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Sep 2020 12:42:51 -0400
Received: by mail-qv1-f49.google.com with SMTP id h1so6567184qvo.9
        for <ceph-devel@vger.kernel.org>; Mon, 07 Sep 2020 09:42:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IAhVNU69QWIfxZEeHLZc/uZOmACqqBqPf1OiRBQkNIw=;
        b=k705pZXNGx+pU3fT07YNfXohQ+hRqO88XvS8A8fy4HhguEgbD6goNfozRUbtJ8sOiC
         m/UFKHU6lt7jN+klD2cQXIUUjIRdBTumw99O2rP3iaimWEXdxPWRAnQvglQcTU5AUoK7
         YL0zMApx3JlqWHMlvD+pBS47Tsq8EIN/v3+CJna8JUCoyIhTXPiCyTaU4Rg3dDZQZBsl
         GEcqQ5fu220YtQ68sKdGa5TJDelUgXgxaHMu6Pr6DnhcJaPbXhKJe/SKTIEO2tLVcqGo
         KqPl/Jco5usp2h97J+AUxBpiR2FNaY/jnJs9LdLvoypycfiiFidBRlE3lL65EbaSOWc2
         oeKQ==
X-Gm-Message-State: AOAM5320dI8LG0NiSf2QZN1sFSuTSryGrgRSx8jaORRCF11ltDYXf72Z
        /mt5xPTNNs2AUByqLCmrda5iYHQOIPKjb2tO/9xia1LsyuvFzOR9
X-Google-Smtp-Source: ABdhPJz1DaZj7ax8hCqwvKpJSO8/0aNMQgTgTnMWi1nq0zKGUKm5JjFC42qAoI8DtjmyNCipJaSRWwT1ALh2vKTV0hQ=
X-Received: by 2002:a0c:baad:: with SMTP id x45mr5192128qvf.108.1599496962836;
 Mon, 07 Sep 2020 09:42:42 -0700 (PDT)
MIME-Version: 1.0
From:   Kaarlo Lahtela <kaarlo@lahtela.fi>
Date:   Mon, 7 Sep 2020 19:42:32 +0300
Message-ID: <CAPbkstyKYy4OwL2VtO2hkoZGqiFY+qg4oAKvx+FyGC=J6C1eDA@mail.gmail.com>
Subject: osd crash
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,
two of my osds on different nodes do not start.  Now I have one pg
that is down. This happened on ceph version 14.2.10 and still happens
after upgrading to 14.2.11. I get this error when starting osd:

===============8<========================
root@prox:~# /usr/bin/ceph-osd -f --cluster ceph --id 1 --setuser ceph
--setgroup ceph
2020-09-05 13:53:15.077 7fd0fca43c80 -1 osd.1 6645 log_to_monitors
{default=true}
2020-09-05 13:53:15.189 7fd0f5d4b700 -1 osd.1 6687 set_numa_affinity
unable to identify public interface 'vmbr0' numa node: (2) No such
file or directory
/build/ceph-JY24tx/ceph-14.2.11/src/osd/osd_types.cc: In function
'uint64_t SnapSet::get_clone_bytes(snapid_t) const' thread
7fd0e2524700 time 2020-09-05 13:53:17.980687
/build/ceph-JY24tx/ceph-14.2.11/src/osd/osd_types.cc: 5450: FAILED
ceph_assert(clone_overlap.count(clone))
 ceph version 14.2.11 (21626754f4563baadc6ba5d50b9cbc48a5730a94)
nautilus (stable)
 1: (ceph::__ceph_assert_fail(char const*, char const*, int, char
const*)+0x152) [0x562cc5ea83c8]
 2: (()+0x5115a0) [0x562cc5ea85a0]
 3: (SnapSet::get_clone_bytes(snapid_t) const+0xc2) [0x562cc61dc432]
 4: (PrimaryLogPG::add_object_context_to_pg_stat(std::shared_ptr<ObjectContext>,
pg_stat_t*)+0x297) [0x562cc6107fb7]
 5: (PrimaryLogPG::recover_backfill(unsigned long,
ThreadPool::TPHandle&, bool*)+0xfdc) [0x562cc6136a3c]
 6: (PrimaryLogPG::start_recovery_ops(unsigned long,
ThreadPool::TPHandle&, unsigned long*)+0x1173) [0x562cc613ab43]
 7: (OSD::do_recovery(PG*, unsigned int, unsigned long,
ThreadPool::TPHandle&)+0x302) [0x562cc5f8b622]
 8: (PGRecovery::run(OSD*, OSDShard*, boost::intrusive_ptr<PG>&,
ThreadPool::TPHandle&)+0x19) [0x562cc622fac9]
 9: (OSD::ShardedOpWQ::_process(unsigned int,
ceph::heartbeat_handle_d*)+0x7d7) [0x562cc5fa7ba7]
 10: (ShardedThreadPool::shardedthreadpool_worker(unsigned int)+0x5b4)
[0x562cc65740c4]
 11: (ShardedThreadPool::WorkThreadSharded::entry()+0x10) [0x562cc6576ad0]
 12: (()+0x7fa3) [0x7fd0fd487fa3]
 13: (clone()+0x3f) [0x7fd0fd0374cf]
*** Caught signal (Aborted) **
 in thread 7fd0e2524700 thread_name:tp_osd_tp
2020-09-05 13:53:17.977 7fd0e2524700 -1
/build/ceph-JY24tx/ceph-14.2.11/src/osd/osd_types.cc: In function
'uint64_t SnapSet::get_clone_bytes(snapid_t) const' thread
7fd0e2524700 time 2020-09-05 13:53:17.980687
/build/ceph-JY24tx/ceph-14.2.11/src/osd/osd_types.cc: 5450: FAILED
ceph_assert(clone_overlap.count(clone))

 ceph version 14.2.11 (21626754f4563baadc6ba5d50b9cbc48a5730a94)
nautilus (stable)
 1: (ceph::__ceph_assert_fail(char const*, char const*, int, char
const*)+0x152) [0x562cc5ea83c8]
 2: (()+0x5115a0) [0x562cc5ea85a0]
 3: (SnapSet::get_clone_bytes(snapid_t) const+0xc2) [0x562cc61dc432]
 4: (PrimaryLogPG::add_object_context_to_pg_stat(std::shared_ptr<ObjectContext>,
pg_stat_t*)+0x297) [0x562cc6107fb7]
 5: (PrimaryLogPG::recover_backfill(unsigned long,
ThreadPool::TPHandle&, bool*)+0xfdc) [0x562cc6136a3c]
 6: (PrimaryLogPG::start_recovery_ops(unsigned long,
ThreadPool::TPHandle&, unsigned long*)+0x1173) [0x562cc613ab43]
 7: (OSD::do_recovery(PG*, unsigned int, unsigned long,
ThreadPool::TPHandle&)+0x302) [0x562cc5f8b622]
 8: (PGRecovery::run(OSD*, OSDShard*, boost::intrusive_ptr<PG>&,
ThreadPool::TPHandle&)+0x19) [0x562cc622fac9]
 9: (OSD::ShardedOpWQ::_process(unsigned int,
ceph::heartbeat_handle_d*)+0x7d7) [0x562cc5fa7ba7]
 10: (ShardedThreadPool::shardedthreadpool_worker(unsigned int)+0x5b4)
[0x562cc65740c4]
 11: (ShardedThreadPool::WorkThreadSharded::entry()+0x10) [0x562cc6576ad0]
 12: (()+0x7fa3) [0x7fd0fd487fa3]
 13: (clone()+0x3f) [0x7fd0fd0374cf]

 ceph version 14.2.11 (21626754f4563baadc6ba5d50b9cbc48a5730a94)
nautilus (stable)
 1: (()+0x12730) [0x7fd0fd492730]
 2: (gsignal()+0x10b) [0x7fd0fcf757bb]
 3: (abort()+0x121) [0x7fd0fcf60535]
 4: (ceph::__ceph_assert_fail(char const*, char const*, int, char
const*)+0x1a3) [0x562cc5ea8419]
 5: (()+0x5115a0) [0x562cc5ea85a0]
 6: (SnapSet::get_clone_bytes(snapid_t) const+0xc2) [0x562cc61dc432]
 7: (PrimaryLogPG::add_object_context_to_pg_stat(std::shared_ptr<ObjectContext>,
pg_stat_t*)+0x297) [0x562cc6107fb7]
 8: (PrimaryLogPG::recover_backfill(unsigned long,
ThreadPool::TPHandle&, bool*)+0xfdc) [0x562cc6136a3c]
 9: (PrimaryLogPG::start_recovery_ops(unsigned long,
ThreadPool::TPHandle&, unsigned long*)+0x1173) [0x562cc613ab43]
 10: (OSD::do_recovery(PG*, unsigned int, unsigned long,
ThreadPool::TPHandle&)+0x302) [0x562cc5f8b622]
 11: (PGRecovery::run(OSD*, OSDShard*, boost::intrusive_ptr<PG>&,
ThreadPool::TPHandle&)+0x19) [0x562cc622fac9]
 12: (OSD::ShardedOpWQ::_process(unsigned int,
ceph::heartbeat_handle_d*)+0x7d7) [0x562cc5fa7ba7]
 13: (ShardedThreadPool::shardedthreadpool_worker(unsigned int)+0x5b4)
[0x562cc65740c4]
 14: (ShardedThreadPool::WorkThreadSharded::entry()+0x10) [0x562cc6576ad0]
 15: (()+0x7fa3) [0x7fd0fd487fa3]
 16: (clone()+0x3f) [0x7fd0fd0374cf]
2020-09-05 13:53:17.981 7fd0e2524700 -1 *** Caught signal (Aborted) **
 in thread 7fd0e2524700 thread_name:tp_osd_tp

 ceph version 14.2.11 (21626754f4563baadc6ba5d50b9cbc48a5730a94)
nautilus (stable)
 1: (()+0x12730) [0x7fd0fd492730]
 2: (gsignal()+0x10b) [0x7fd0fcf757bb]
 3: (abort()+0x121) [0x7fd0fcf60535]
 4: (ceph::__ceph_assert_fail(char const*, char const*, int, char
const*)+0x1a3) [0x562cc5ea8419]
 5: (()+0x5115a0) [0x562cc5ea85a0]
 6: (SnapSet::get_clone_bytes(snapid_t) const+0xc2) [0x562cc61dc432]
 7: (PrimaryLogPG::add_object_context_to_pg_stat(std::shared_ptr<ObjectContext>,
pg_stat_t*)+0x297) [0x562cc6107fb7]
 8: (PrimaryLogPG::recover_backfill(unsigned long,
ThreadPool::TPHandle&, bool*)+0xfdc) [0x562cc6136a3c]
 9: (PrimaryLogPG::start_recovery_ops(unsigned long,
ThreadPool::TPHandle&, unsigned long*)+0x1173) [0x562cc613ab43]
 10: (OSD::do_recovery(PG*, unsigned int, unsigned long,
ThreadPool::TPHandle&)+0x302) [0x562cc5f8b622]
 11: (PGRecovery::run(OSD*, OSDShard*, boost::intrusive_ptr<PG>&,
ThreadPool::TPHandle&)+0x19) [0x562cc622fac9]
 12: (OSD::ShardedOpWQ::_process(unsigned int,
ceph::heartbeat_handle_d*)+0x7d7) [0x562cc5fa7ba7]
 13: (ShardedThreadPool::shardedthreadpool_worker(unsigned int)+0x5b4)
[0x562cc65740c4]
 14: (ShardedThreadPool::WorkThreadSharded::entry()+0x10) [0x562cc6576ad0]
 15: (()+0x7fa3) [0x7fd0fd487fa3]
 16: (clone()+0x3f) [0x7fd0fd0374cf]
 NOTE: a copy of the executable, or `objdump -rdS <executable>` is
needed to interpret this.

  -469> 2020-09-05 13:53:15.077 7fd0fca43c80 -1 osd.1 6645
log_to_monitors {default=true}
  -195> 2020-09-05 13:53:15.189 7fd0f5d4b700 -1 osd.1 6687
set_numa_affinity unable to identify public interface 'vmbr0' numa
node: (2) No such file or directory
    -1> 2020-09-05 13:53:17.977 7fd0e2524700 -1
/build/ceph-JY24tx/ceph-14.2.11/src/osd/osd_types.cc: In function
'uint64_t SnapSet::get_clone_bytes(snapid_t) const' thread
7fd0e2524700 time 2020-09-05 13:53:17.980687
/build/ceph-JY24tx/ceph-14.2.11/src/osd/osd_types.cc: 5450: FAILED
ceph_assert(clone_overlap.count(clone))

 ceph version 14.2.11 (21626754f4563baadc6ba5d50b9cbc48a5730a94)
nautilus (stable)
 1: (ceph::__ceph_assert_fail(char const*, char const*, int, char
const*)+0x152) [0x562cc5ea83c8]
 2: (()+0x5115a0) [0x562cc5ea85a0]
 3: (SnapSet::get_clone_bytes(snapid_t) const+0xc2) [0x562cc61dc432]
 4: (PrimaryLogPG::add_object_context_to_pg_stat(std::shared_ptr<ObjectContext>,
pg_stat_t*)+0x297) [0x562cc6107fb7]
 5: (PrimaryLogPG::recover_backfill(unsigned long,
ThreadPool::TPHandle&, bool*)+0xfdc) [0x562cc6136a3c]
 6: (PrimaryLogPG::start_recovery_ops(unsigned long,
ThreadPool::TPHandle&, unsigned long*)+0x1173) [0x562cc613ab43]
 7: (OSD::do_recovery(PG*, unsigned int, unsigned long,
ThreadPool::TPHandle&)+0x302) [0x562cc5f8b622]
 8: (PGRecovery::run(OSD*, OSDShard*, boost::intrusive_ptr<PG>&,
ThreadPool::TPHandle&)+0x19) [0x562cc622fac9]
 9: (OSD::ShardedOpWQ::_process(unsigned int,
ceph::heartbeat_handle_d*)+0x7d7) [0x562cc5fa7ba7]
 10: (ShardedThreadPool::shardedthreadpool_worker(unsigned int)+0x5b4)
[0x562cc65740c4]
 11: (ShardedThreadPool::WorkThreadSharded::entry()+0x10) [0x562cc6576ad0]
 12: (()+0x7fa3) [0x7fd0fd487fa3]
 13: (clone()+0x3f) [0x7fd0fd0374cf]

     0> 2020-09-05 13:53:17.981 7fd0e2524700 -1 *** Caught signal (Aborted) **
 in thread 7fd0e2524700 thread_name:tp_osd_tp

 ceph version 14.2.11 (21626754f4563baadc6ba5d50b9cbc48a5730a94)
nautilus (stable)
 1: (()+0x12730) [0x7fd0fd492730]
 2: (gsignal()+0x10b) [0x7fd0fcf757bb]
 3: (abort()+0x121) [0x7fd0fcf60535]
 4: (ceph::__ceph_assert_fail(char const*, char const*, int, char
const*)+0x1a3) [0x562cc5ea8419]
 5: (()+0x5115a0) [0x562cc5ea85a0]
 6: (SnapSet::get_clone_bytes(snapid_t) const+0xc2) [0x562cc61dc432]
 7: (PrimaryLogPG::add_object_context_to_pg_stat(std::shared_ptr<ObjectContext>,
pg_stat_t*)+0x297) [0x562cc6107fb7]
 8: (PrimaryLogPG::recover_backfill(unsigned long,
ThreadPool::TPHandle&, bool*)+0xfdc) [0x562cc6136a3c]
 9: (PrimaryLogPG::start_recovery_ops(unsigned long,
ThreadPool::TPHandle&, unsigned long*)+0x1173) [0x562cc613ab43]
 10: (OSD::do_recovery(PG*, unsigned int, unsigned long,
ThreadPool::TPHandle&)+0x302) [0x562cc5f8b622]
 11: (PGRecovery::run(OSD*, OSDShard*, boost::intrusive_ptr<PG>&,
ThreadPool::TPHandle&)+0x19) [0x562cc622fac9]
 12: (OSD::ShardedOpWQ::_process(unsigned int,
ceph::heartbeat_handle_d*)+0x7d7) [0x562cc5fa7ba7]
 13: (ShardedThreadPool::shardedthreadpool_worker(unsigned int)+0x5b4)
[0x562cc65740c4]
 14: (ShardedThreadPool::WorkThreadSharded::entry()+0x10) [0x562cc6576ad0]
 15: (()+0x7fa3) [0x7fd0fd487fa3]
 16: (clone()+0x3f) [0x7fd0fd0374cf]
 NOTE: a copy of the executable, or `objdump -rdS <executable>` is
needed to interpret this.

  -469> 2020-09-05 13:53:15.077 7fd0fca43c80 -1 osd.1 6645
log_to_monitors {default=true}
  -195> 2020-09-05 13:53:15.189 7fd0f5d4b700 -1 osd.1 6687
set_numa_affinity unable to identify public interface 'vmbr0' numa
node: (2) No such file or directory
    -1> 2020-09-05 13:53:17.977 7fd0e2524700 -1
/build/ceph-JY24tx/ceph-14.2.11/src/osd/osd_types.cc: In function
'uint64_t SnapSet::get_clone_bytes(snapid_t) const' thread
7fd0e2524700 time 2020-09-05 13:53:17.980687
/build/ceph-JY24tx/ceph-14.2.11/src/osd/osd_types.cc: 5450: FAILED
ceph_assert(clone_overlap.count(clone))

 ceph version 14.2.11 (21626754f4563baadc6ba5d50b9cbc48a5730a94)
nautilus (stable)
 1: (ceph::__ceph_assert_fail(char const*, char const*, int, char
const*)+0x152) [0x562cc5ea83c8]
 2: (()+0x5115a0) [0x562cc5ea85a0]
 3: (SnapSet::get_clone_bytes(snapid_t) const+0xc2) [0x562cc61dc432]
 4: (PrimaryLogPG::add_object_context_to_pg_stat(std::shared_ptr<ObjectContext>,
pg_stat_t*)+0x297) [0x562cc6107fb7]
 5: (PrimaryLogPG::recover_backfill(unsigned long,
ThreadPool::TPHandle&, bool*)+0xfdc) [0x562cc6136a3c]
 6: (PrimaryLogPG::start_recovery_ops(unsigned long,
ThreadPool::TPHandle&, unsigned long*)+0x1173) [0x562cc613ab43]
 7: (OSD::do_recovery(PG*, unsigned int, unsigned long,
ThreadPool::TPHandle&)+0x302) [0x562cc5f8b622]
 8: (PGRecovery::run(OSD*, OSDShard*, boost::intrusive_ptr<PG>&,
ThreadPool::TPHandle&)+0x19) [0x562cc622fac9]
 9: (OSD::ShardedOpWQ::_process(unsigned int,
ceph::heartbeat_handle_d*)+0x7d7) [0x562cc5fa7ba7]
 10: (ShardedThreadPool::shardedthreadpool_worker(unsigned int)+0x5b4)
[0x562cc65740c4]
 11: (ShardedThreadPool::WorkThreadSharded::entry()+0x10) [0x562cc6576ad0]
 12: (()+0x7fa3) [0x7fd0fd487fa3]
 13: (clone()+0x3f) [0x7fd0fd0374cf]

     0> 2020-09-05 13:53:17.981 7fd0e2524700 -1 *** Caught signal (Aborted) **
 in thread 7fd0e2524700 thread_name:tp_osd_tp

 ceph version 14.2.11 (21626754f4563baadc6ba5d50b9cbc48a5730a94)
nautilus (stable)
 1: (()+0x12730) [0x7fd0fd492730]
 2: (gsignal()+0x10b) [0x7fd0fcf757bb]
 3: (abort()+0x121) [0x7fd0fcf60535]
 4: (ceph::__ceph_assert_fail(char const*, char const*, int, char
const*)+0x1a3) [0x562cc5ea8419]
 5: (()+0x5115a0) [0x562cc5ea85a0]
 6: (SnapSet::get_clone_bytes(snapid_t) const+0xc2) [0x562cc61dc432]
 7: (PrimaryLogPG::add_object_context_to_pg_stat(std::shared_ptr<ObjectContext>,
pg_stat_t*)+0x297) [0x562cc6107fb7]
 8: (PrimaryLogPG::recover_backfill(unsigned long,
ThreadPool::TPHandle&, bool*)+0xfdc) [0x562cc6136a3c]
 9: (PrimaryLogPG::start_recovery_ops(unsigned long,
ThreadPool::TPHandle&, unsigned long*)+0x1173) [0x562cc613ab43]
 10: (OSD::do_recovery(PG*, unsigned int, unsigned long,
ThreadPool::TPHandle&)+0x302) [0x562cc5f8b622]
 11: (PGRecovery::run(OSD*, OSDShard*, boost::intrusive_ptr<PG>&,
ThreadPool::TPHandle&)+0x19) [0x562cc622fac9]
 12: (OSD::ShardedOpWQ::_process(unsigned int,
ceph::heartbeat_handle_d*)+0x7d7) [0x562cc5fa7ba7]
 13: (ShardedThreadPool::shardedthreadpool_worker(unsigned int)+0x5b4)
[0x562cc65740c4]
 14: (ShardedThreadPool::WorkThreadSharded::entry()+0x10) [0x562cc6576ad0]
 15: (()+0x7fa3) [0x7fd0fd487fa3]
 16: (clone()+0x3f) [0x7fd0fd0374cf]
 NOTE: a copy of the executable, or `objdump -rdS <executable>` is
needed to interpret this.

Aborted
===============8<========================

What can I do to recover my osds?

-- 
</kaarlo>
