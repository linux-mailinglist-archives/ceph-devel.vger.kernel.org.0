Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D37A18B9E9
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Mar 2020 16:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgCSPAn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Mar 2020 11:00:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:50444 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgCSPAm (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 11:00:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A5FBAAE48;
        Thu, 19 Mar 2020 15:00:40 +0000 (UTC)
Received: from localhost (webern.olymp [local])
        by webern.olymp (OpenSMTPD) with ESMTPA id 4a952f62;
        Thu, 19 Mar 2020 15:00:39 +0000 (WET)
Date:   Thu, 19 Mar 2020 15:00:39 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ceph: fix memory leak in ceph_cleanup_snapid_map
Message-ID: <20200319150039.GA24696@suse.com>
References: <20200319114348.GA72449@suse.com>
 <e00d01582d39f1036bd73fb66e45e56c8c07016d.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e00d01582d39f1036bd73fb66e45e56c8c07016d.camel@kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Mar 19, 2020 at 10:41:13AM -0400, Jeff Layton wrote:
> On Thu, 2020-03-19 at 11:43 +0000, Luis Henriques wrote:
> > kmemleak reports the following memory leak:
> > 
> > unreferenced object 0xffff88821feac8a0 (size 96):
> >   comm "kworker/1:0", pid 17, jiffies 4294896362 (age 20.512s)
> >   hex dump (first 32 bytes):
> >     a0 c8 ea 1f 82 88 ff ff 00 c9 ea 1f 82 88 ff ff  ................
> >     00 00 00 00 00 00 00 00 00 01 00 00 00 00 ad de  ................
> >   backtrace:
> >     [<00000000b3ea77fb>] ceph_get_snapid_map+0x75/0x2a0
> >     [<00000000d4060942>] fill_inode+0xb26/0x1010
> >     [<0000000049da6206>] ceph_readdir_prepopulate+0x389/0xc40
> >     [<00000000e2fe2549>] dispatch+0x11ab/0x1521
> >     [<000000007700b894>] ceph_con_workfn+0xf3d/0x3240
> >     [<0000000039138a41>] process_one_work+0x24d/0x590
> >     [<00000000eb751f34>] worker_thread+0x4a/0x3d0
> >     [<000000007e8f0d42>] kthread+0xfb/0x130
> >     [<00000000d49bd1fa>] ret_from_fork+0x3a/0x50
> > 
> > A kfree was missing in commit 75c9627efb72 ("ceph: map snapid to anonymous
> > bdev ID"), while looping the 'to_free' list of ceph_snapid_map objects.
> > 
> > Fixes: 75c9627efb72 ("ceph: map snapid to anonymous bdev ID")
> > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > ---
> > Hi!
> > 
> > A bit of mailing-list archaeology shows that v1 of this patch actually
> > included this kfree [1], and was lost on v2 [2].
> > 
> > [1] https://patchwork.kernel.org/patch/10114319/
> > [2] https://patchwork.kernel.org/patch/10749907/
> > 
> > Cheers,
> > --
> > Luis
> > 
> > fs/ceph/snap.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > index ccfcc66aaf44..923be9399b21 100644
> > --- a/fs/ceph/snap.c
> > +++ b/fs/ceph/snap.c
> > @@ -1155,5 +1155,6 @@ void ceph_cleanup_snapid_map(struct ceph_mds_client *mdsc)
> >  			pr_err("snapid map %llx -> %x still in use\n",
> >  			       sm->snap, sm->dev);
> >  		}
> > +		kfree(sm);
> >  	}
> >  }
> 
> Good catch. This looks correct to me.
> 
> Hmmm...we'll leak one of these for every snapid we encounter. Any
> objection to marking this for stable?

No, please do.  I assumed it would be a stable candidate already by having
the 'Fixes: <sha1>' but maybe it's better to explicitly tag it.

Cheers,
--
Luis
