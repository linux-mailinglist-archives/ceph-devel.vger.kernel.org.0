Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34FB81776AD
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Mar 2020 14:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgCCNIq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Mar 2020 08:08:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:35986 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728124AbgCCNIp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 08:08:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 519DEB019;
        Tue,  3 Mar 2020 13:08:44 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 03 Mar 2020 14:08:44 +0100
From:   Roman Penyaev <rpenyaev@suse.de>
To:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: Pech OSD as a userspace experiment based on Ceph sources from Linux
 kernel
Message-ID: <c939186786a66800e1050b62f709d017@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi all,

Couple of weeks ago I started an experimental Pech OSD project [1]
for several reasons: I need easy hackable OSD in C with IO path only,
without fail-over, log-based replication, PG layer and all other
things. I want to test performance on different replication strategies
(client-based, primary-copy, chain) having simplest and fastest file
storage (yes, step back to filestore) which reads and writes directly
to files without any journals involved.

Eventually this Pech OSD can be a starting point to something
different, something which is not RADOS, which is fast, with minimum
IO ordering requirements and acts as a RAID 1 cluster, e.g. something
which is described here [2].

Q: What is this name, Pech?
A: Just an anagram created from Ceph. Also this is a German word which
    perfectly describes this work. Pronounced exactly the same [peh].

Q: Why C, why Linux kernel sources?
A: I found more comfortable to hack Ceph, analyzing protocol
    implementation, monitor and OSD client code reading Linux kernel
    C code, instead of legacy OSD C++ code or Crimson project.

    Linux kernel path net/ceph has everything I need: monitor client,
    v1 messenger, osdmap, monmap, all headers and defines. Since by
    default kernel sources is cleansed of external library dependencies
    this is just a homework exercise to provide a layer of kernel API
    in order to build all sources from net/ceph path as a userspace
    application with no modifications made.

    I also really like the idea of code unification: same sources
    can be compiled and used on both sides.

    Continuing this hackary madness IMO it is possible to compile
    drivers/block/rbd.c in userspace and use it as a separate very
    light rbd client. Why? Same 1 thread architecture (see next
    question for details) can be a win in terms of performance for
    a client, at the same time it may be interesting for debug
    purposes or fast prototypes.

Q: What is the architecture?
A: I do not use threads, I use cooperative scheduling and jump from
    task contexts using setjmp()/longjmp() calls. This model perfectly
    fits UP kernel with disabled preemption, thus reworked scheduling
    (sched.c), workqueue.c and timer.c code runs the event loop.

    So again, no atomic operations, no locks, everything is one thread.
    In future number of event loops can be equal to a number of
    physical CPUs, where each event loop is executed from a dedicated
    pthread context and pinned to a particular CPU.

    Does that sound similar to Crimson and can be described in all the
    same buzzy words from advertising brochures? Absolutely.

Q: What this noop OSD can do now?
A: Now it can only:

    o Connect to monitors and "boot" OSD, i.e. mark it as UP.
    o On Ctrl+C mark OSD on monitors as DOWN and gracefully exit.

Q: What is not yet ported from kernel sources?
A: Crypto part is noop now, thus monitors should be run with
    auth=none.  To make cephx work direct copy-paste of kernel crypto
    sources has to be done, or a wrapper over openssl lib should be
    written, see src/ceph/crypto.c interface empty stubs for details.

Q: What are the instructions to build and start Pech OSD?
A: Make:

      $ make -j8

    Start new Ceph cluster with 1 OSD and then stop everything.  We
    start monitors on specified port and witg -X option, i.e. auth=none.

      $ CEPH_PORT=50000 MON=1 MDS=0 OSD=1 MGR=0 ../src/vstart.sh 
--memstore -n -X
      $ ../src/stop.sh

    Restart only Ceph monitor(s):

      $ MON=1 MDS=0 OSD=0 MGR=0 ../src/vstart.sh

    Start pech-osd accessing monitor over v1 protocol:

      $ ./pech-osd mon_addrs=ip.ip.ip.ip:50001 name=0 fsid=`cat 
./osd0/fsid` log_level=5

    For DEBUG purposes maximum output log level can be specified: 
log_level=7

    In order not to confuse valgrind with stack allocations/deallocations
    USE_VALGRIND=1 option can be passed to make:

      $ make USE_VALGRIND=1


Have fun!

[1] https://github.com/rouming/pech
[2] 
https://lists.ceph.io/hyperkitty/list/dev@ceph.io/thread/N46NR7NBHWBQL4B2ASU7Y2LMKZZPK3IX/

--
Roman

