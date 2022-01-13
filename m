Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9788C48D385
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jan 2022 09:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbiAMIXH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jan 2022 03:23:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229685AbiAMIXG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 03:23:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642062186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EceTeo9yJf7hZmwD68p4OXproaFSmjlN48Uhu6my1K0=;
        b=UwpWOocMg7JFtspHbS1Z6Omm+mqr9bS1UVUB8IMeOSgNfAepxs3NY3KxEF6eo7BEwZKm1o
        FhEN2axmfu96B7OzsWS2zJwz8feTNi5wo0bSgILnGqbHuTm89yaCEP4d2mTAgofggCTnpA
        fd2nRXtfQhIbm1+9pJqO6hqhI5aPmy8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-VQmnrL2ONpmIpprQywRwug-1; Thu, 13 Jan 2022 03:23:02 -0500
X-MC-Unique: VQmnrL2ONpmIpprQywRwug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44CCC83DEB4;
        Thu, 13 Jan 2022 08:23:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1894A78AFE;
        Thu, 13 Jan 2022 08:22:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20211228124419.103020-1-jefflexu@linux.alibaba.com>
References: <20211228124419.103020-1-jefflexu@linux.alibaba.com>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     dhowells@redhat.com, jlayton@kernel.org, idryomov@gmail.com,
        ceph-devel@vger.kernel.org, linux-cachefs@redhat.com
Subject: [PATCH] netfs: Make ops->init_rreq() optional
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1483069.1642062179.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 13 Jan 2022 08:22:59 +0000
Message-ID: <1483070.1642062179@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeffle,

I've altered your patch commit message, if you could take a look?

David
---
From: Jeffle Xu <jefflexu@linux.alibaba.com>

netfs: Make ops->init_rreq() optional

Make the ops->init_rreq() callback optional.  This isn't required for the
erofs changes I'm implementing to do on-demand read through fscache[1].
Further, ceph has an empty init_rreq method that can then be removed and
it's marked optional in the documentation.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20211227125444.21187-1-jefflexu@linux.alib=
aba.com/ [1]
Link: https://lore.kernel.org/r/20211228124419.103020-1-jefflexu@linux.ali=
baba.com
---
 fs/ceph/addr.c         |    5 -----
 fs/netfs/read_helper.c |    3 ++-
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index b3d9459c9bbd..c98e5238a1b6 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -297,10 +297,6 @@ static void ceph_netfs_issue_op(struct netfs_read_sub=
request *subreq)
 	dout("%s: result %d\n", __func__, err);
 }
 =

-static void ceph_init_rreq(struct netfs_read_request *rreq, struct file *=
file)
-{
-}
-
 static void ceph_readahead_cleanup(struct address_space *mapping, void *p=
riv)
 {
 	struct inode *inode =3D mapping->host;
@@ -312,7 +308,6 @@ static void ceph_readahead_cleanup(struct address_spac=
e *mapping, void *priv)
 }
 =

 static const struct netfs_read_request_ops ceph_netfs_read_ops =3D {
-	.init_rreq		=3D ceph_init_rreq,
 	.is_cache_enabled	=3D ceph_is_cache_enabled,
 	.begin_cache_operation	=3D ceph_begin_cache_operation,
 	.issue_op		=3D ceph_netfs_issue_op,
diff --git a/fs/netfs/read_helper.c b/fs/netfs/read_helper.c
index 6169659857b3..501da990c259 100644
--- a/fs/netfs/read_helper.c
+++ b/fs/netfs/read_helper.c
@@ -55,7 +55,8 @@ static struct netfs_read_request *netfs_alloc_read_reque=
st(
 		INIT_WORK(&rreq->work, netfs_rreq_work);
 		refcount_set(&rreq->usage, 1);
 		__set_bit(NETFS_RREQ_IN_PROGRESS, &rreq->flags);
-		ops->init_rreq(rreq, file);
+		if (ops->init_rreq)
+			ops->init_rreq(rreq, file);
 		netfs_stat(&netfs_n_rh_rreq);
 	}
 =

