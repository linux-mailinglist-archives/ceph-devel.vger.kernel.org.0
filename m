Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 122E6FE09
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Apr 2019 18:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfD3Qko (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Apr 2019 12:40:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:47042 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbfD3Qko (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 12:40:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 818FEAD14;
        Tue, 30 Apr 2019 16:40:42 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 30 Apr 2019 18:40:42 +0200
From:   Roman Penyaev <rpenyaev@suse.de>
To:     "Liu, Changcheng" <changcheng.liu@intel.com>
Cc:     ceph-devel@vger.kernel.org, ceph-devel-owner@vger.kernel.org
Subject: Re: Async Messenger RDMA IB ib_uverbs_write return EACCES
In-Reply-To: <20190419143111.GA3102@jerryopenix>
References: <20190412104207.GA29167@jerryopenix>
 <30fa5e49d56591fe2ecd6eae1caa98ce@suse.de>
 <20190415122240.GA7819@jerryopenix>
 <484935ae3aeb0ee6a59f93c3c727ba36@suse.de>
 <20190416085820.GA4711@jerryopenix>
 <84005b8af680599e93f8bc3facbc00a3@suse.de>
 <20190416104119.GA6094@jerryopenix>
 <211951a560b75a8d13096c87f7a241c9@suse.de>
 <20190416120710.GA7940@jerryopenix> <20190419100628.GA15957@jerryopenix>
 <20190419143111.GA3102@jerryopenix>
Message-ID: <7cf7c35992829e4e1b134d833dab1e0b@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019-04-19 16:31, Liu, Changcheng wrote:
> Hi Roman,
>   I found that why ceph/msg/async/rdma/iwarp(x722) doesn't work on
> ceph master branch.
>   The problem is triggered by below commit:
> 
> https://github.com/ceph/ceph/pull/20172/commits/fdde016301ae329f76c621337c384ac60aa0d210
> 
>   Below is the basic program model extracted from
> ceph/msg/async/rdma/iwarp to show how the problem is triggered:

Hi Changcheng,

Indeed fork() also changes credentials (see copy_creds() in kernel for 
details),
like setuid() does, so there are two known places in ceph, after which 
uverbs
calls return -EACESS:

   o setuid() (see global_init())
   o daemon() (see global_init_daemonize())

My question is why you daemonize your ceph services and do not rely on 
systemd,
which does fork() on its own and runs each service with '-f' flag, which 
means
do not daemonize?  So I would not daemonize services and this can be a 
simple
solution.

With setuid() is not that easy.  The most straightforward way is to move
mc_bootstrap.get_monmap_and_config() after setuid() call.  At the bottom 
of
the email there is a small patch which can fix the problem (I hope does 
not
introduce something new). Would be great if you can check it.

--
Roman


diff --git a/src/global/global_init.cc b/src/global/global_init.cc
index eb8bbfd1a4db..de647be768bd 100644
--- a/src/global/global_init.cc
+++ b/src/global/global_init.cc
@@ -147,18 +147,6 @@ void global_pre_init(
      cct->_log->start();
    }

-  if (!conf->no_mon_config) {
-    // make sure our mini-session gets legacy values
-    conf.apply_changes(nullptr);
-
-    MonClient mc_bootstrap(g_ceph_context);
-    if (mc_bootstrap.get_monmap_and_config() < 0) {
-      cct->_log->flush();
-      cerr << "failed to fetch mon config (--no-mon-config to skip)"
-          << std::endl;
-      _exit(1);
-    }
-  }
    if (!cct->_log->is_started()) {
      cct->_log->start();
    }
@@ -313,6 +301,28 @@ global_init(const std::map<std::string,std::string> 
*defaults,
    }
  #endif

+  //
+  // Utterly important to run first network connection after setuid().
+  // In case of rdma transport uverbs kernel module starts returning
+  // -EACCESS on each operation if credentials has been changed, see
+  // callers of ib_safe_file_access() for details.
+  //
+  // fork() syscall also matters, so daemonization won't work in case
+  // of rdma.
+  //
+  if (!g_conf()->no_mon_config) {
+    // make sure our mini-session gets legacy values
+    g_conf().apply_changes(nullptr);
+
+    MonClient mc_bootstrap(g_ceph_context);
+    if (mc_bootstrap.get_monmap_and_config() < 0) {
+      g_ceph_context->_log->flush();
+      cerr << "failed to fetch mon config (--no-mon-config to skip)"
+          << std::endl;
+      _exit(1);
+    }
+  }
+


