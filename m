Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE5F433D3E
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Oct 2021 19:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbhJSRZK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Oct 2021 13:25:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48105 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234526AbhJSRZJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 13:25:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634664175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JOqfmssTkXXiKThwBGVyyHuYXPo6VBVl8UwOszClJ8c=;
        b=Bl3GeofqUU/eL8Xmexu3LdwoTdK9Y77kIHiOyiTxor4tQQoYDKFNY8iiSC21L6/RZyi5Gs
        0ryrvSSrsP0QJ6FSi8MTqEXVLd87j1oVENdBJ27S59uqx/Gho4scv/TX1A9ZblohjuLylS
        uBCPmHKldpc6N3iZdYJ45QMBnkUixp0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-Rob_Zf-ROY-7N4658rci_A-1; Tue, 19 Oct 2021 13:22:52 -0400
X-MC-Unique: Rob_Zf-ROY-7N4658rci_A-1
Received: by mail-qt1-f198.google.com with SMTP id d21-20020ac800d5000000b002a7ae3ec644so430790qtg.7
        for <ceph-devel@vger.kernel.org>; Tue, 19 Oct 2021 10:22:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=JOqfmssTkXXiKThwBGVyyHuYXPo6VBVl8UwOszClJ8c=;
        b=N1b9iylBOawKUVFF9DTojgHZTlhALClyv4eIPwCWpi6rPZuvvWCE1YCrQsgwJMkGB/
         0sf54C8ULnFjkPpKvD8M/BH46l1y33/uZceVHSEbbUlgFO+GDzFx0GzmpugbCk/5O9M3
         ref/MyYp+6v1apUZ1xNiB0GUhjDYYFA0oDNRXS7UPgLbiFQ5ZgcPRCWxUkobqiggwal8
         QEv3CHXabB5keWpfybjSSBeQ6gETGPRRX6s1b4plb4czkcDgRe277m2m5PipD41b5WGX
         PCSTrp5sZ/8L7c83stcGBJ87XJ2G5vCGdXld/FfMOtbo5EDb3eqyOe2MIrh63zhPuWxz
         CGSQ==
X-Gm-Message-State: AOAM532gDHtf7WXzyKILBLM1Brxtar9kReHH5kp1O23GjKwN9ikfykne
        yYzGZFdks5B3taQnv0K1EYuoM/VNDie2CR4uEw9ZDhDboZjhrGLdblIixqW45E2rYN1fQ33XHAJ
        waUoQ7o3PWseja6LykOjiVg==
X-Received: by 2002:ac8:5fc5:: with SMTP id k5mr1372078qta.273.1634664172093;
        Tue, 19 Oct 2021 10:22:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzp4cr5dV94h+XDRbaJmp+cfMFv4+i32Ye0oINtZE8qF5SrO8m9PjQyUWjQRiUs6vWX+z8ww==
X-Received: by 2002:ac8:5fc5:: with SMTP id k5mr1372059qta.273.1634664171906;
        Tue, 19 Oct 2021 10:22:51 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id m66sm8127161qkb.87.2021.10.19.10.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 10:22:51 -0700 (PDT)
Message-ID: <d58335124c7467703201a9cdba765a46a780c855.camel@redhat.com>
Subject: Re: [PATCH 03/67] vfs, fscache: Force ->write_inode() to occur if
 cookie pinned for writeback
From:   Jeff Layton <jlayton@redhat.com>
To:     David Howells <dhowells@redhat.com>, linux-cachefs@redhat.com
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 19 Oct 2021 13:22:50 -0400
In-Reply-To: <163456866523.2614702.2234665737111683988.stgit@warthog.procyon.org.uk>
References: <163456861570.2614702.14754548462706508617.stgit@warthog.procyon.org.uk>
         <163456866523.2614702.2234665737111683988.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-10-18 at 15:51 +0100, David Howells wrote:
> Use an inode flag, I_PINNING_FSCACHE_WB, to indicate that a cookie is
> pinned in use by that inode for the purposes of writeback.
> 
> Pinning is necessary because the in-use pin from the open file is released
> before the writeback takes place, but if the resources aren't pinned, the
> dirty data can't be written to the cache.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/fs-writeback.c         |    8 ++++++++
>  include/linux/fs.h        |    3 +++
>  include/linux/fscache.h   |    1 +
>  include/linux/writeback.h |    1 +
>  4 files changed, 13 insertions(+)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 81ec192ce067..f3122831c4fe 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1666,6 +1666,13 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  
>  	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
>  		inode->i_state |= I_DIRTY_PAGES;
> +	else if (unlikely(inode->i_state & I_PINNING_FSCACHE_WB)) {
> +		if (!(inode->i_state & I_DIRTY_PAGES)) {
> +			inode->i_state &= ~I_PINNING_FSCACHE_WB;
> +			wbc->unpinned_fscache_wb = true;
> +			dirty |= I_PINNING_FSCACHE_WB; /* Cause write_inode */
> +		}
> +	}

IDGI: how would I_PINNING_FSCACHE_WB get set in the first place? 

>  
>  	spin_unlock(&inode->i_lock);
>  
> @@ -1675,6 +1682,7 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  		if (ret == 0)
>  			ret = err;
>  	}
> +	wbc->unpinned_fscache_wb = false;
>  	trace_writeback_single_inode(inode, wbc, nr_to_write);
>  	return ret;
>  }
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 197493507744..336739fed3e9 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2420,6 +2420,8 @@ static inline void kiocb_clone(struct kiocb *kiocb, struct kiocb *kiocb_src,
>   *			Used to detect that mark_inode_dirty() should not move
>   * 			inode between dirty lists.
>   *
> + * I_PINNING_FSCACHE_WB	Inode is pinning an fscache object for writeback.
> + *
>   * Q: What is the difference between I_WILL_FREE and I_FREEING?
>   */
>  #define I_DIRTY_SYNC		(1 << 0)
> @@ -2442,6 +2444,7 @@ static inline void kiocb_clone(struct kiocb *kiocb, struct kiocb *kiocb_src,
>  #define I_CREATING		(1 << 15)
>  #define I_DONTCACHE		(1 << 16)
>  #define I_SYNC_QUEUED		(1 << 17)
> +#define I_PINNING_FSCACHE_WB	(1 << 18)
>  
>  #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
>  #define I_DIRTY (I_DIRTY_INODE | I_DIRTY_PAGES)
> diff --git a/include/linux/fscache.h b/include/linux/fscache.h
> index 01558d155799..ba4878b56717 100644
> --- a/include/linux/fscache.h
> +++ b/include/linux/fscache.h
> @@ -19,6 +19,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/pagevec.h>
>  #include <linux/list_bl.h>
> +#include <linux/writeback.h>
>  #include <linux/netfs.h>
>  
>  #if defined(CONFIG_FSCACHE) || defined(CONFIG_FSCACHE_MODULE)
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index d1f65adf6a26..2fda288600d3 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -69,6 +69,7 @@ struct writeback_control {
>  	unsigned for_reclaim:1;		/* Invoked from the page allocator */
>  	unsigned range_cyclic:1;	/* range_start is cyclic */
>  	unsigned for_sync:1;		/* sync(2) WB_SYNC_ALL writeback */
> +	unsigned unpinned_fscache_wb:1;	/* Cleared I_PINNING_FSCACHE_WB */
>  
>  	/*
>  	 * When writeback IOs are bounced through async layers, only the
> 
> 

-- 
Jeff Layton <jlayton@redhat.com>

