Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9579B3D14EE
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Jul 2021 19:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbhGUQgY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Jul 2021 12:36:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231950AbhGUQgX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 21 Jul 2021 12:36:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626887819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=45Nv4CwiblR8FGtkBjhkDjeZeYsNgqMrzsXCoaXKlcs=;
        b=gDWcy8NIxe9/V5FcdM8+kT/08r4yHl8432TqZdmla7z84fBUmQBH6cH8mN6DfIR1z9k8PE
        XVev+sv0Ic3drn0kX9b6FwCkwrPz8q05dm7e/HNFAFgu3mVaLhCbY5h099tBUn7xofH6S0
        G+gzCb8rtxIM4etdXIHnH3RSkpBJP8E=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-2J-H1PLjN6WbQoLYF3f0Ww-1; Wed, 21 Jul 2021 13:16:58 -0400
X-MC-Unique: 2J-H1PLjN6WbQoLYF3f0Ww-1
Received: by mail-qt1-f199.google.com with SMTP id w3-20020ac80ec30000b029024e8c2383c1so1951969qti.5
        for <ceph-devel@vger.kernel.org>; Wed, 21 Jul 2021 10:16:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=45Nv4CwiblR8FGtkBjhkDjeZeYsNgqMrzsXCoaXKlcs=;
        b=HD82wRc3EmKBuINCYIOMejFw2+FBYh4G8dQR28f30yqo7lDL1uqqGU5jXz+8EzG9iH
         CObaQ1Ufc6KG2aahE07QukhmTy3ycjliatc3pjsqfmUFY+e/JLVsggycDexk05OoRGfM
         mqlaUsBOdskmv4/4RIx7FkD28Hv8FDsYSS415kl7DlShecbR7yF2QWRBtZpJLkCElo1v
         xSlVkdWQKoU3tnY+4XCCNNC9clvyl3X8Hx3rqEp3UnjfQ4+t/DFMRAKVh/981hiySHD2
         BOkD/fapUUSb0kvBnnQ/V7zpey3vF7YkhZlYmWi1ppel3zF4Ejix7BlHkUO9EB7FMCZP
         MZQw==
X-Gm-Message-State: AOAM5301F7Ry4zCY+V1fFIL9zjKxN/8J9Od+TODh1a/NeplNFt9iAVtw
        TigfXSKAUh/M2KxCQoBB5qmJkgX6tgIG7LbPvBVWf7vWUaQc/tegz3hKgdmH2TuyKVCWIo1fk6z
        GzQo7sdwOAnth99PHLOb6Wg==
X-Received: by 2002:ad4:45a6:: with SMTP id y6mr36933561qvu.1.1626887817698;
        Wed, 21 Jul 2021 10:16:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwroCy17a7YpgGcviCUSg3J+GVy+n4E5MAqofjS2RsLBi/0nF/2omAf2j+swlCqTU83eT+04Q==
X-Received: by 2002:ad4:45a6:: with SMTP id y6mr36933536qvu.1.1626887817521;
        Wed, 21 Jul 2021 10:16:57 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id t6sm1744741qkg.75.2021.07.21.10.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 10:16:57 -0700 (PDT)
Message-ID: <0555748529d483fb9b69eceb56bf9ebc1efceaf1.camel@redhat.com>
Subject: Re: [RFC PATCH 02/12] netfs: Add an iov_iter to the read subreq for
 the network fs/cache to use
From:   Jeff Layton <jlayton@redhat.com>
To:     David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Mike Marshall <hubcap@omnibond.com>,
        David Wysochanski <dwysocha@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        ceph-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        devel@lists.orangefs.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 21 Jul 2021 13:16:56 -0400
In-Reply-To: <162687509306.276387.7579641363406546284.stgit@warthog.procyon.org.uk>
References: <162687506932.276387.14456718890524355509.stgit@warthog.procyon.org.uk>
         <162687509306.276387.7579641363406546284.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-07-21 at 14:44 +0100, David Howells wrote:
> Add an iov_iter to the read subrequest and set it up to define the
> destination buffer to write into.  This will allow future patches to point
> to a bounce buffer instead for purposes of handling oversize writes,
> decryption (where we want to save the encrypted data to the cache) and
> decompression.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/afs/file.c          |    6 +-----
>  fs/netfs/read_helper.c |    5 ++++-
>  include/linux/netfs.h  |    2 ++
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/afs/file.c b/fs/afs/file.c
> index c9c21ad0e7c9..ca529f23515a 100644
> --- a/fs/afs/file.c
> +++ b/fs/afs/file.c
> @@ -319,11 +319,7 @@ static void afs_req_issue_op(struct netfs_read_subrequest *subreq)
>  	fsreq->len	= subreq->len   - subreq->transferred;
>  	fsreq->key	= subreq->rreq->netfs_priv;
>  	fsreq->vnode	= vnode;
> -	fsreq->iter	= &fsreq->def_iter;
> -
> -	iov_iter_xarray(&fsreq->def_iter, READ,
> -			&fsreq->vnode->vfs_inode.i_mapping->i_pages,
> -			fsreq->pos, fsreq->len);
> +	fsreq->iter	= &subreq->iter;
>  
>  	afs_fetch_data(fsreq->vnode, fsreq);
>  }
> diff --git a/fs/netfs/read_helper.c b/fs/netfs/read_helper.c
> index 0b6cd3b8734c..715f3e9c380d 100644
> --- a/fs/netfs/read_helper.c
> +++ b/fs/netfs/read_helper.c
> @@ -150,7 +150,7 @@ static void netfs_clear_unread(struct netfs_read_subrequest *subreq)
>  {
>  	struct iov_iter iter;
>  
> -	iov_iter_xarray(&iter, WRITE, &subreq->rreq->mapping->i_pages,
> +	iov_iter_xarray(&iter, READ, &subreq->rreq->mapping->i_pages,

What's up with the WRITE -> READ change here? Was that a preexisting
bug?

>  			subreq->start + subreq->transferred,
>  			subreq->len   - subreq->transferred);
>  	iov_iter_zero(iov_iter_count(&iter), &iter);
> @@ -745,6 +745,9 @@ netfs_rreq_prepare_read(struct netfs_read_request *rreq,
>  	if (WARN_ON(subreq->len == 0))
>  		source = NETFS_INVALID_READ;
>  
> +	iov_iter_xarray(&subreq->iter, READ, &rreq->mapping->i_pages,
> +			subreq->start, subreq->len);
> +
>  out:
>  	subreq->source = source;
>  	trace_netfs_sreq(subreq, netfs_sreq_trace_prepare);
> diff --git a/include/linux/netfs.h b/include/linux/netfs.h
> index fe9887768292..5e4fafcc9480 100644
> --- a/include/linux/netfs.h
> +++ b/include/linux/netfs.h
> @@ -17,6 +17,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/fs.h>
>  #include <linux/pagemap.h>
> +#include <linux/uio.h>
>  
>  /*
>   * Overload PG_private_2 to give us PG_fscache - this is used to indicate that
> @@ -112,6 +113,7 @@ struct netfs_cache_resources {
>  struct netfs_read_subrequest {
>  	struct netfs_read_request *rreq;	/* Supervising read request */
>  	struct list_head	rreq_link;	/* Link in rreq->subrequests */
> +	struct iov_iter		iter;		/* Iterator for this subrequest */
>  	loff_t			start;		/* Where to start the I/O */
>  	size_t			len;		/* Size of the I/O */
>  	size_t			transferred;	/* Amount of data transferred */
> 
> 

-- 
Jeff Layton <jlayton@redhat.com>

