Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4604135A8B
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 14:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbgAINun (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 08:50:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:39394 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731073AbgAINun (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 08:50:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5917AB134
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jan 2020 13:50:38 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 09 Jan 2020 14:50:38 +0100
From:   Roman Penyaev <rpenyaev@suse.de>
To:     ceph-devel@vger.kernel.org
Subject: crimson-osd vs legacy-osd: should the perf difference be already
 noticeable?
Message-ID: <02e2209f66f18217aa45b8f7caf715f6@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Subject: crimson-osd vs legacy-osd: should the perf difference be 
already noticeable?

Hi folks,

I was curios to read some early performance benchmarks which compare
crimson-osd vs legacy-osd, but could not find any.  So eventually
decided to do my own micro benchmarks in order to test transport
together with PG layer, avoiding any storage costs completely
(no reason to test memcpy of memstore which is the only available
  objectstore for crimson).  At least recalling all these ad brochures
of seastar which should bring performance on another level by doing
preemption in userspace, the difference should be already there and
visible in numbers.

And yes I'm aware that crimson is in development, but if basic
functionality is already supported (like write path), then I can
squeeze some numbers.

For all testing loads I run original rbd.fio, taken from fio/examples/,
of course changing only block size.  Since this is a micro benchmark I
run only 1 osd cluster.

   [global]
   ioengine=rbd
   clientname=admin
   pool=rbd
   rbdname=fio_test
   rw=randwrite
   #bs=4k

   [rbd_iodepth32]
   iodepth=32


-- Part 1, turn MemStore and cyan_store into null block

Testing memcpy is not interesting so in order to run any memstore with
'memstore_debug_omit_block_device_write=true' option set and skip all
writes I have to do a small tweak in order to start osd, namely I still
need to pass small writes and omit big ones which are sent by the 
client,
something as the following:

-  if (len > 0 && !local_conf()->memstore_debug_omit_block_device_write) 
{
+
+  if (len > 0 &&
+      (!local_conf()->memstore_debug_omit_block_device_write ||
+       // We still want cluster meta-data to be saved, so pass only 
small
+       // writes, expecting user writes will be >= 4k.
+       len < 4096)) {


*** BTW at the bottom you can find the whole patch with all debug
     modifications made to deliver these numbers.


# legacy-osd, MemStore

MON=1 MDS=0 OSD=1 MGR=1 ../src/vstart.sh  --memstore -n \
     -o 'memstore_debug_omit_block_device_write=true'

   4k  IOPS=42.7k,  BW=167MiB/s, Lat=749.18usec
   8k  IOPS=40.2k, BW=314MiB/s,  Lat=795.03usec
  16k  IOPS=37.6k, BW=588MiB/s,  Lat=849.12usec
  32k  IOPS=32.0k, BW=1000MiB/s, Lat=998.56usec
  64k  IOPS=25.5k, BW=1594MiB/s, Lat=1253.99usec
128k  IOPS=17.5k, BW=2188MiB/s, Lat=1826.54usec
256k  IOPS=10.1k, BW=2531MiB/s, Lat=3157.33usec
512k  IOPS=5252, BW=2626MiB/s,  Lat=6071.37usec
   1m  IOPS=2656, BW=2656MiB/s,  Lat=12029.65usec


# crimson-osd, cyan_store

MON=1 MDS=0 OSD=1 MGR=1 ../src/vstart.sh  --crimson --memstore -n \
     -o 'memstore_debug_omit_block_device_write=true'

   4k  IOPS=40.2k, BW=157MiB/s, Lat=796.07usec
   8k  IOPS=37.1k, BW=290MiB/s, Lat=861.51usec
  16k  IOPS=32.9k, BW=514MiB/s, Lat=970.99usec
  32k  IOPS=26.1k, BW=815MiB/s, Lat=1225.78usec
  64k  IOPS=21.3k, BW=1333MiB/s, Lat=1498.92usec
128k  IOPS=14.4k, BW=1795MiB/s, Lat=2227.07usec
256k  IOPS=6143, BW=1536MiB/s, Lat=5203.70usec
512k  IOPS=3776, BW=1888MiB/s, Lat=8464.79usec
   1m  IOPS=1866, BW=1867MiB/s, Lat=17126.36usec


First thing that catches my eye is that for small blocks there is no big
difference at all, but as the block increases, crimsons iops starts to
decline. Can it be the transport issue? Can be tested as well.


-- Part 2, complete writes immediately, even not leaving the transport

Would be great to avoid PG logic costs, exactly like we did for 
objectstore,
i.e. the following question can be asked "how fast we can handle writes 
and
complete them immediately from the transport callback and measure socket
read/write costs?".  I introduced new option 'osd_immediate_completions'
and handle it directly from 'OSD::ms_[fast_]dispatch' function replying 
with
success just immediately (for details see patch at the bottom).


# legacy-osd

MON=1 MDS=0 OSD=1 MGR=1 ../src/vstart.sh --memstore -n \
     -o 'osd_immediate_completions=true'

   4k  IOPS=59.2k, BW=231MiB/s, Lat=539.68usec
   8k  IOPS=55.1k, BW=430MiB/s, Lat=580.44usec
  16k  IOPS=50.5k, BW=789MiB/s, Lat=633.03usec
  32k  IOPS=44.6k, BW=1394MiB/s, Lat=716.74usec
  64k  IOPS=33.5k, BW=2093MiB/s, Lat=954.60usec
128k  IOPS=20.8k, BW=2604MiB/s, Lat=1535.01usec
256k  IOPS=10.6k, BW=2642MiB/s, Lat=3026.19usec
512k  IOPS=5400, BW=2700MiB/s, Lat=5920.86usec
   1m  IOPS=2549, BW=2550MiB/s, Lat=12539.40usec


# crimson-osd

MON=1 MDS=0 OSD=1 MGR=1 ../src/vstart.sh --crimson --memstore -n \
     -o 'osd_immediate_completions=true'

   4k  IOPS=60.2k, BW=235MiB/s, Lat=530.95usec
   8k  IOPS=52.0k, BW=407MiB/s, Lat=614.21usec
  16k  IOPS=47.1k, BW=736MiB/s, Lat=678.41usec
  32k  IOPS=37.8k, BW=1180MiB/s, Lat=846.75usec
  64k  IOPS=26.6k, BW=1660MiB/s, Lat=1203.51usec
128k  IOPS=15.5k, BW=1936MiB/s, Lat=2064.12usec
256k  IOPS=7506, BW=1877MiB/s, Lat=4259.19usec
512k  IOPS=3941, BW=1971MiB/s, Lat=8112.67usec
   1m  IOPS=1785, BW=1786MiB/s, Lat=17896.44usec


As a summary I can say that for me is quite surprising not to notice any
iops improvements on crimson side (not to mention the problem with 
reading
of big blocks).  Since I run only 1 osd on one particular load I admit 
the
artificial nature of such tests (thus called micro benchmark), but then
on what cluster scale and what benchmark can I run to see some 
improvements
of a new architecture?

    Roman

---
  src/common/options.cc           |  4 ++++
  src/crimson/os/cyan_store.cc    |  6 +++++-
  src/crimson/osd/ops_executer.cc |  4 ++--
  src/crimson/osd/osd.cc          | 20 ++++++++++++++++++++
  src/os/memstore/MemStore.cc     |  6 +++++-
  src/osd/OSD.cc                  | 24 ++++++++++++++++++++++++
  6 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/src/common/options.cc b/src/common/options.cc
index d91827c1a803..769666d2955c 100644
--- a/src/common/options.cc
+++ b/src/common/options.cc
@@ -4234,6 +4234,10 @@ std::vector<Option> get_global_options() {
      .set_default(false)
      .set_description(""),

+    Option("osd_immediate_completions", Option::TYPE_BOOL, 
Option::LEVEL_ADVANCED)
+    .set_default(false)
+    .set_description(""),
+
      // --------------------------
      // bluestore

diff --git a/src/crimson/os/cyan_store.cc b/src/crimson/os/cyan_store.cc
index f0749cb921f9..c05e0e40b721 100644
--- a/src/crimson/os/cyan_store.cc
+++ b/src/crimson/os/cyan_store.cc
@@ -463,7 +463,11 @@ int CyanStore::_write(const coll_t& cid, const 
ghobject_t& oid,
      return -ENOENT;

    ObjectRef o = c->get_or_create_object(oid);
-  if (len > 0 && !local_conf()->memstore_debug_omit_block_device_write) 
{
+  if (len > 0 &&
+      (!local_conf()->memstore_debug_omit_block_device_write ||
+       // We still want cluster meta-data to be saved, so pass only 
small
+       // writes, expecting user writes will be >= 4k.
+       len < 4096)) {
      const ssize_t old_size = o->get_size();
      o->write(offset, bl);
      used_bytes += (o->get_size() - old_size);
diff --git a/src/crimson/osd/ops_executer.cc 
b/src/crimson/osd/ops_executer.cc
index 13f6f086c4ea..a76fc6e206d8 100644
--- a/src/crimson/osd/ops_executer.cc
+++ b/src/crimson/osd/ops_executer.cc
@@ -431,8 +431,8 @@ OpsExecuter::execute_osd_op(OSDOp& osd_op)

    default:
      logger().warn("unknown op {}", ceph_osd_op_name(op.op));
-    throw std::runtime_error(
-      fmt::format("op '{}' not supported", ceph_osd_op_name(op.op)));
+    // Without that `fio examples/rbd.fio` hangs on exit
+    throw ceph::osd::operation_not_supported{};
    }
  }

diff --git a/src/crimson/osd/osd.cc b/src/crimson/osd/osd.cc
index ddd8742d1a74..737cc266766e 100644
--- a/src/crimson/osd/osd.cc
+++ b/src/crimson/osd/osd.cc
@@ -17,6 +17,7 @@
  #include "messages/MOSDOp.h"
  #include "messages/MOSDPGLog.h"
  #include "messages/MOSDRepOpReply.h"
+#include "messages/MOSDOpReply.h"
  #include "messages/MPGStats.h"

  #include "os/Transaction.h"
@@ -881,6 +882,25 @@ seastar::future<> OSD::committed_osd_maps(version_t 
first,
  seastar::future<> OSD::handle_osd_op(ceph::net::Connection* conn,
                                       Ref<MOSDOp> m)
  {
+
+  //
+  // Immediately complete requests even without leaving the transport
+  //
+  if (local_conf().get_val<bool>("osd_immediate_completions")) {
+    m->finish_decode();
+
+    for (auto op : m->ops) {
+      if (op.op.op == CEPH_OSD_OP_WRITE &&
+          // Complete big writes only
+          op.op.extent.length >= 4096) {
+
+        auto reply = make_message<MOSDOpReply>(m.get(), 0, 
osdmap->get_epoch(),
+                                CEPH_OSD_FLAG_ACK | 
CEPH_OSD_FLAG_ONDISK, true);
+        return conn->send(reply);
+      }
+    }
+  }
+
    shard_services.start_operation<ClientRequest>(
      *this,
      conn->get_shared(),
diff --git a/src/os/memstore/MemStore.cc b/src/os/memstore/MemStore.cc
index 05d16edb6cc0..265dc64c808d 100644
--- a/src/os/memstore/MemStore.cc
+++ b/src/os/memstore/MemStore.cc
@@ -1047,7 +1047,11 @@ int MemStore::_write(const coll_t& cid, const 
ghobject_t& oid,
      return -ENOENT;

    ObjectRef o = c->get_or_create_object(oid);
-  if (len > 0 && !cct->_conf->memstore_debug_omit_block_device_write) {
+  if (len > 0 &&
+      (!cct->_conf->memstore_debug_omit_block_device_write ||
+       // We still want cluster meta-data to be saved, so pass only 
small
+       // writes, expecting user writes will be bigger than 4k.
+       len < 4096)) {
      const ssize_t old_size = o->get_size();
      o->write(offset, bl);
      used_bytes += (o->get_size() - old_size);
diff --git a/src/osd/OSD.cc b/src/osd/OSD.cc
index 96aed0b706e3..796bf927126f 100644
--- a/src/osd/OSD.cc
+++ b/src/osd/OSD.cc
@@ -7223,6 +7223,30 @@ void OSD::ms_fast_dispatch(Message *m)
      return;
    }

+  //
+  // Immediately complete requests even without leaving the transport
+  //
+  if (g_conf().get_val<bool>("osd_immediate_completions") &&
+      m->get_type() == CEPH_MSG_OSD_OP) {
+    MOSDOp *osdop = static_cast<MOSDOp*>(m);
+
+    osdop->finish_decode();
+
+    for (auto op : osdop->ops) {
+      if (op.op.op == CEPH_OSD_OP_WRITE &&
+          // Complete big writes only
+          op.op.extent.length >= 4096) {
+        MOSDOpReply *reply;
+
+        reply = new MOSDOpReply(osdop, 0, osdmap->get_epoch(),
+                                CEPH_OSD_FLAG_ACK | 
CEPH_OSD_FLAG_ONDISK, true);
+        osdop->get_connection()->send_message(reply);
+        m->put();
+        return;
+      }
+    }
+  }
+
    // peering event?
    switch (m->get_type()) {
    case CEPH_MSG_PING:

