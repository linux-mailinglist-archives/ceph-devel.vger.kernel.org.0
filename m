Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F01AE178E4E
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Mar 2020 11:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387730AbgCDKXy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Mar 2020 05:23:54 -0500
Received: from mail-vs1-f43.google.com ([209.85.217.43]:46017 "EHLO
        mail-vs1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387398AbgCDKXy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Mar 2020 05:23:54 -0500
Received: by mail-vs1-f43.google.com with SMTP id m4so769951vsa.12
        for <ceph-devel@vger.kernel.org>; Wed, 04 Mar 2020 02:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=q7xbWRObZjSf5a+O7KpvxqFW3uXQBrpV64T/KQ6p5P4=;
        b=A/UpLU5DSMMIJLwnYg+j9fnJG4zsXOH50rFrUibtDR/wl0kTMzqBC9DgGee6am/Zwn
         ZrFciTFUvmV93LGsD0J2KAeumsQ9TfVMoHq3Kb6cqQkck+KVdXl/T2fdYPHHGa/md+sz
         0XG8fvFlOKNccLMA+uw6XpQWMdWzURjgYQ98SthwtkusStAGuKwSf6WBj1qTFGJo3HTr
         hYQ1k+OfCt/WKSU/g9ManD7eJZdI6pNn44FmVmrbJfE3RCPKs9akaLGPZ8IgB925QYr9
         3KMn3BaBbUZkWzCtWZRGWAlv6Fe5+3NUpnxwHWeYjlE8HVq4MWMJmLGN/drnNY06MfcQ
         pSbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=q7xbWRObZjSf5a+O7KpvxqFW3uXQBrpV64T/KQ6p5P4=;
        b=beKnhoyqxlEQM4XjnXryQ+uCeq8hRXGwjBVmNLQJdzo9TvTr6r1UcAsFyIktWv7E9g
         g6fgUD1of/3XYNwKsVnQQl2MNZa2ZTR62Lo9GtEuZY7F3otBFYreAG4747Qi8S0TM/JO
         qp3F8C9Uov1cXeqZTG+Q14y1lwxHisWMQ4sFM2C1wkcAEEy5yofCOrm1k7peFlVjEW9a
         Mg059BLwJZBq9ZmNC+NuP3+r2EkcD8A5KFWVi+Na93GvGUOnz0VTHrCHq+xuJdOJ7GmE
         yJom2iAnsQ50e7ogCWzkcTWaUdROdmeKbkTPZm2jpAAjF70DgAk0YUZ5msZE6EltqRXi
         iNcQ==
X-Gm-Message-State: ANhLgQ2/M81ZlTvNLyMWt3nNr7ThcchmJEQpm3/Y7lYmt83OsB2WvIAl
        Y0w1FNwrG0FueXpZZm3OB5OHGgKnfvTx/DT2MxGz4WRTzDo=
X-Google-Smtp-Source: ADFU+vtyjH9dyC4KVi8gi4WSEOmY87oLUI3HBCgeD0eT58VJDlDGW9vb43jRTzi7Cl19QYcwVy7NzMAedb4HAs3un+E=
X-Received: by 2002:a67:ee4e:: with SMTP id g14mr1237557vsp.223.1583317432551;
 Wed, 04 Mar 2020 02:23:52 -0800 (PST)
MIME-Version: 1.0
From:   chen kael <chenji.bupt@gmail.com>
Date:   Wed, 4 Mar 2020 18:23:40 +0800
Message-ID: <CAA-rZjbfMpnzWeghBP0FTrs0UrYzOCgRknVqwNyGjH1Q+joMVA@mail.gmail.com>
Subject: The attempt to reduce latency for ReplicatedBackend
To:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dear Cepher
As all we know, PrimaryPG will never return success to client until
all replica send their MSG_OSD_REPOPREPLY message. This does help ceph
to obtain the strong consistence all the time.

I have made some small changes to this golden rule in Ceph in order to
reduce the latency during random write as much as possible.

In the test patch (please see below), we assume pool size is 3,  the
'success' will be returned to client once PrimaryPG has received any
two of the messages, in this case everything works well, including
recovery and backfill etc. In the meanwhile, the Latency of 4K-random
write in my HDD cluster is almost reduced by 50%, which is cut down
from 20ms to 10ms.

However, with this patch, balance read must be disabled since stale
data could be read from replica PG. And the reliability of the data
will be compromised. Even so, I think the effect is limited since
these missing data can be recovered by using PGLOG.

Besides, this modification also made me a little bit anxious. The
reason is that some bugs have been detected and fixed during testing.
Considering this, I am not sure if there will be any other bugs
related to this modification. Therefore, I really hope to get your
suggestions in order to avoid the unexpected bugs in advance.

It will be highly appreciated if any of you would like to share your
experience and comment.
Big thanks in advance

This patch is base on 14.2.7

diff --git a/src/common/legacy_config_opts.h b/src/common/legacy_config_opts.h
index 79d9c1f..464fba1 100644
--- a/src/common/legacy_config_opts.h
+++ b/src/common/legacy_config_opts.h
@@ -873,6 +873,8 @@ OPTION(osd_requested_scrub_priority, OPT_U32)
 OPTION(osd_pg_delete_priority, OPT_U32)
 OPTION(osd_pg_delete_cost, OPT_U32) // set default cost equal to 1MB io

+OPTION(osd_pg_allow_majority_write, OPT_BOOL) // set default cost
equal to 1MB io
+
 OPTION(osd_recovery_priority, OPT_U32)
 // set default cost equal to 20MB io
 OPTION(osd_recovery_cost, OPT_U32)
diff --git a/src/common/options.cc b/src/common/options.cc
index f0ba13a..26242eb 100644
--- a/src/common/options.cc
+++ b/src/common/options.cc
@@ -4082,6 +4082,10 @@ std::vector<Option> get_global_options() {
     .set_default(1<<20)
     .set_description(""),

+    Option("osd_pg_allow_majority_write", Option::TYPE_BOOL,
Option::LEVEL_ADVANCED)
+    .set_default(false)
+    .set_description(""),
+
     Option("osd_scrub_priority", Option::TYPE_UINT, Option::LEVEL_ADVANCED)
     .set_default(5)
     .set_description("Priority for scrub operations in work queue"),
diff --git a/src/osd/PG.cc b/src/osd/PG.cc
index cd52976..ad293ec 100644
--- a/src/osd/PG.cc
+++ b/src/osd/PG.cc
@@ -3936,12 +3936,23 @@ void PG::write_if_dirty(ObjectStore::Transaction& t)

 void PG::add_log_entry(const pg_log_entry_t& e, bool applied)
 {
+  // test if this assertion can pass for ever!
+  dout(10) << "add_log_entry e.version" << e.version << dendl;
+  dout(10) << "add_log_entry e.user_version" << e.user_version << dendl;
+  dout(10) << "add_log_entry info.last_user_version" <<
info.last_user_version << dendl;
+  dout(10) << "add_log_entry info.last_complete" <<
info.last_complete << dendl;
+  dout(10) << "add_log_entry info.last_update" << info.last_update << dendl;
+
   // raise last_complete only if we were previously up to date
   if (info.last_complete == info.last_update)
+  {
+    ceph_assert(e.version.version == info.last_complete.version + 1);
     info.last_complete = e.version;
-
+  }
+
   // raise last_update.
   ceph_assert(e.version > info.last_update);
+  ceph_assert(e.version.version == info.last_update.version + 1);
   info.last_update = e.version;

   // raise user_version, if it increased (it may have not get bumped
diff --git a/src/osd/ReplicatedBackend.cc b/src/osd/ReplicatedBackend.cc
index f8d67af..1aca6e8 100644
--- a/src/osd/ReplicatedBackend.cc
+++ b/src/osd/ReplicatedBackend.cc
@@ -509,9 +509,11 @@ void ReplicatedBackend::submit_transaction(
 void ReplicatedBackend::op_commit(
   InProgressOpRef& op)
 {
-  if (op->on_commit == nullptr) {
-    // aborted
-    return;
+  if (!cct->_conf->osd_pg_allow_majority_write) {
+    if (op->on_commit == nullptr) {
+      // aborted
+      return;
+    }
   }

   FUNCTRACE(cct);
@@ -523,17 +525,26 @@ void ReplicatedBackend::op_commit(
   }

   op->waiting_for_commit.erase(get_parent()->whoami_shard());
-
-  if (op->waiting_for_commit.empty()) {
-    op->on_commit->complete(0);
-    op->on_commit = 0;
-    in_progress_ops.erase(op->tid);
+  if (cct->_conf->osd_pg_allow_majority_write) {
+    if (op->waiting_for_commit.size() == 1 && op->on_commit) {
+      op->on_commit->complete(0);
+      op->on_commit = 0;
+    }
+    if (op->waiting_for_commit.empty()) {
+      in_progress_ops.erase(op->tid);
+    }
+  } else {
+    if (op->waiting_for_commit.empty()) {
+      op->on_commit->complete(0);
+      op->on_commit = 0;
+      in_progress_ops.erase(op->tid);
+    }
   }
 }

 void ReplicatedBackend::do_repop_reply(OpRequestRef op)
 {
-  static_cast<MOSDRepOpReply*>(op->get_nonconst_req())->finish_decode();
+  static_cast<MOSDRepOpReply *>(op->get_nonconst_req())->finish_decode();
   const MOSDRepOpReply *r = static_cast<const MOSDRepOpReply *>(op->get_req());
   ceph_assert(r->get_header().type == MSG_OSD_REPOPREPLY);

@@ -552,14 +563,14 @@ void ReplicatedBackend::do_repop_reply(OpRequestRef op)

     if (m)
       dout(7) << __func__ << ": tid " << ip_op.tid << " op " //<< *m
-       << " ack_type " << (int)r->ack_type
-       << " from " << from
-       << dendl;
+              << " ack_type " << (int)r->ack_type
+              << " from " << from
+              << dendl;
     else
       dout(7) << __func__ << ": tid " << ip_op.tid << " (no op) "
-       << " ack_type " << (int)r->ack_type
-       << " from " << from
-       << dendl;
+              << " ack_type " << (int)r->ack_type
+              << " from " << from
+              << dendl;

     // oh, good.

@@ -567,8 +578,8 @@ void ReplicatedBackend::do_repop_reply(OpRequestRef op)
       ceph_assert(ip_op.waiting_for_commit.count(from));
       ip_op.waiting_for_commit.erase(from);
       if (ip_op.op) {
- ip_op.op->mark_event("sub_op_commit_rec");
- ip_op.op->pg_trace.event("sub_op_commit_rec");
+        ip_op.op->mark_event("sub_op_commit_rec");
+        ip_op.op->pg_trace.event("sub_op_commit_rec");
       }
     } else {
       // legacy peer; ignore
@@ -578,12 +589,28 @@ void ReplicatedBackend::do_repop_reply(OpRequestRef op)
       from,
       r->get_last_complete_ondisk());

-    if (ip_op.waiting_for_commit.empty() &&
+    if (cct->_conf->osd_pg_allow_majority_write) {
+      if (ip_op.waiting_for_commit.size() == 1 &&
         ip_op.on_commit) {
-      ip_op.on_commit->complete(0);
-      ip_op.on_commit = 0;
-      in_progress_ops.erase(iter);
+        ip_op.on_commit->complete(0);
+        ip_op.on_commit = 0;
+      }
+      if (ip_op.waiting_for_commit.empty()) {
+        in_progress_ops.erase(iter);
+      }
+    } else {
+      if (ip_op.waiting_for_commit.empty() && ip_op.on_commit) {
+        ip_op.on_commit->complete(0);
+        ip_op.on_commit = 0;
+        in_progress_ops.erase(iter);
+      }
     }
+
+    dout(10) << __func__ << ": tid " << ip_op.tid << " op " //<< *m
+              << " ack_type " << (int)r->ack_type
+              << " from " << from
+              << " in_progress_ops size " << in_progress_ops.size()
+              << dendl;
   }
 }
