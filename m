Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7119C48DB96
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jan 2022 17:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236595AbiAMQUj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jan 2022 11:20:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29804 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbiAMQUi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 11:20:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642090838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HS16jLN7unkxFPQM4nOJZ2m0CdE5wbqWBb1jBUddR4w=;
        b=ZORGs6/j62WbnIVoaWZ3/3PNUgZdvhVbCVMoV04WQ/ZSLVITX1aGaUTnXSjrE5GBjuK0u/
        FYtCLW3uevhdnmM61nmKBqIscB5JRmJl+BhZ1djjoBbHks46AEjJ3FaQDHLy7m26VUoeWo
        XltSuI+tQyXt2rolJlq2TsQXcw0u4FE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-8x3gcAjBM2aWgWXKN56oZg-1; Thu, 13 Jan 2022 11:20:34 -0500
X-MC-Unique: 8x3gcAjBM2aWgWXKN56oZg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B791E10CDB66;
        Thu, 13 Jan 2022 16:20:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FC447D3D2;
        Thu, 13 Jan 2022 16:20:29 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <1318953.1642024578@warthog.procyon.org.uk>
References: <1318953.1642024578@warthog.procyon.org.uk> <164021579335.640689.2681324337038770579.stgit@warthog.procyon.org.uk> <164021479106.640689.17404516570194656552.stgit@warthog.procyon.org.uk>
To:     Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, linux-cachefs@redhat.com,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Murphy Zhou <jencce.kernel@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] cifs: Support fscache indexing rewrite
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1886509.1642090829.1@warthog.procyon.org.uk>
Date:   Thu, 13 Jan 2022 16:20:29 +0000
Message-ID: <1886510.1642090829@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> -	/*
> -	 * The cookie is initialized from volume info returned above.
> -	 * Inside cifs_fscache_get_super_cookie it checks
> -	 * that we do not get super cookie twice.
> -	 */
> -	cifs_fscache_get_super_cookie(tcon);
> +	if (!rc &&
> +	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)) {
> +		/*
> +		 * The cookie is initialized from volume info returned above.
> +		 * Inside cifs_fscache_get_super_cookie it checks
> +		 * that we do not get super cookie twice.
> +		 */
> +		rc = cifs_fscache_get_super_cookie(tcon);
> +		if (rc < 0) {
> +			iget_failed(inode);
> +			inode = ERR_PTR(rc);
> +		}
> +	}

This bit should've been removed - and the bit it is modifying was removed by
commit b774302e885697dde027825f8de9beb985d037bd which is now upstream.

The invocation of cifs_fscache_get_super_cookie() added by that commit should
be altered to make it conditional.

To this end, I've rebased the patch on linus/master and something
approximating the attached change needs to be made.

David
---
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f977e02bd21e..598be9890f2a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3057,7 +3057,8 @@ static int mount_get_conns(struct mount_ctx *mnt_ctx)
 	 * Inside cifs_fscache_get_super_cookie it checks
 	 * that we do not get super cookie twice.
 	 */
-	cifs_fscache_get_super_cookie(tcon);
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
+		cifs_fscache_get_super_cookie(tcon);
 
 out:
 	mnt_ctx->server = server;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 3c3bc28090d8..9b93e7d3e0e1 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1368,20 +1368,6 @@ struct inode *cifs_root_iget(struct super_block *sb)
 		inode = ERR_PTR(rc);
 	}
 
-	if (!rc &&
-	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)) {
-		/*
-		 * The cookie is initialized from volume info returned above.
-		 * Inside cifs_fscache_get_super_cookie it checks
-		 * that we do not get super cookie twice.
-		 */
-		rc = cifs_fscache_get_super_cookie(tcon);
-		if (rc < 0) {
-			iget_failed(inode);
-			inode = ERR_PTR(rc);
-		}
-	}
-
 out:
 	kfree(path);
 	free_xid(xid);

