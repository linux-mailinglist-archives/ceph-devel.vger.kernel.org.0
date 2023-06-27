Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D8073FDD0
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Jun 2023 16:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjF0O24 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jun 2023 10:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjF0O2z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Jun 2023 10:28:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BCF270F
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 07:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687876089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zkGubF2ccHkJq637dAhIZHtxynTnOsrnVgHA5seQSss=;
        b=IYXZpke1crTG9qGtVHX6PgHyt5mgme/eoHWIRzvH2Gw7zBUNYeWjgA9nT4D/V2ts+ItHfm
        hFHH9dkBwVwAUfJFjzQfuarGscJM4zSE+/AXF1P3wFwt9PkAQcoAJTBiYQQT8EDbRdikeh
        DbTxcyMCDh7xt9uHv2aA+bkx+16bPY8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-16srD_o8OPKtHixlcGyp0w-1; Tue, 27 Jun 2023 10:28:06 -0400
X-MC-Unique: 16srD_o8OPKtHixlcGyp0w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EA2B29DD9BF;
        Tue, 27 Jun 2023 14:27:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93526207B348;
        Tue, 27 Jun 2023 14:27:17 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <3130627.1687863588@warthog.procyon.org.uk>
References: <3130627.1687863588@warthog.procyon.org.uk>
Cc:     dhowells@redhat.com, Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org
Subject: Re: Ceph patches for the merge window?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3200799.1687876037.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 27 Jun 2023 15:27:17 +0100
Message-ID: <3200800.1687876037@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Looking at "ceph: add a dedicated private data for netfs rreq" you might f=
ind
the attached patch useful.  It's in my list of netfs patches to push once =
I
get away from splice.

David
---
netfs: Allow the netfs to make the io (sub)request alloc larger

Allow the network filesystem to specify extra space to be allocated on the
end of the io (sub)request.  This allows cifs, for example, to use this
space rather than allocating its own cifs_readdata struct.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 fs/netfs/objects.c    |    7 +++++--
 include/linux/netfs.h |    2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
index e41f9fc9bdd2..2f1865ff7cce 100644
--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -22,7 +22,8 @@ struct netfs_io_request *netfs_alloc_request(struct addr=
ess_space *mapping,
 	struct netfs_io_request *rreq;
 	int ret;
 =

-	rreq =3D kzalloc(sizeof(struct netfs_io_request), GFP_KERNEL);
+	rreq =3D kzalloc(ctx->ops->io_request_size ?: sizeof(struct netfs_io_req=
uest),
+		       GFP_KERNEL);
 	if (!rreq)
 		return ERR_PTR(-ENOMEM);
 =

@@ -116,7 +117,9 @@ struct netfs_io_subrequest *netfs_alloc_subrequest(str=
uct netfs_io_request *rreq
 {
 	struct netfs_io_subrequest *subreq;
 =

-	subreq =3D kzalloc(sizeof(struct netfs_io_subrequest), GFP_KERNEL);
+	subreq =3D kzalloc(rreq->netfs_ops->io_subrequest_size ?:
+			 sizeof(struct netfs_io_subrequest),
+			 GFP_KERNEL);
 	if (subreq) {
 		INIT_LIST_HEAD(&subreq->rreq_link);
 		refcount_set(&subreq->ref, 2);
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index b76a1548d311..442b88e39945 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -214,6 +214,8 @@ struct netfs_io_request {
  * Operations the network filesystem can/must provide to the helpers.
  */
 struct netfs_request_ops {
+	unsigned int	io_request_size;	/* Alloc size for netfs_io_request struct =
*/
+	unsigned int	io_subrequest_size;	/* Alloc size for netfs_io_subrequest s=
truct */
 	int (*init_request)(struct netfs_io_request *rreq, struct file *file);
 	void (*free_request)(struct netfs_io_request *rreq);
 	int (*begin_cache_operation)(struct netfs_io_request *rreq);

