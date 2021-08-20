Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9033F2A34
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Aug 2021 12:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237713AbhHTKkv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Aug 2021 06:40:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235321AbhHTKku (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 06:40:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4CA360F4A;
        Fri, 20 Aug 2021 10:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629456013;
        bh=98bGVyR/4ihSMjtkugDaqoq4YxmR0pa3+2JfFZRs0jM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=B2rMWoiSV4tEHZCMmNW2O3Diyr7F362nWvm7Ua6WTosTTYqqWGPewYex2u32qtpeU
         YcX0F0oi/PGwERUfbGESieeZKQPzl+3qd5tB0wGEaNHin/By61MUGa2rH4WiR1IES+
         Mubq8GwGK4bOdCse/4ds2ChtSz0n2beEz1jv808nNMZRqwb+BOeK1xAzSqnxGagCE1
         tx7dKe+AEnDy7glKBLZHDb2YWDg676K4uEAN/7QsOuae/X5AvpUz41bxDZfuTG9XsF
         WUApCVLJdzFd5FOqHWdMsBa+j3hd1dHg+VK/8JZfytwR+l86QLvAqFOYBJal6TabLn
         Gam7PSDN0MDwQ==
Message-ID: <c9f9e07bd8a79028f49f7ebb3262c415f81dedf1.camel@kernel.org>
Subject: Re: [PATCH] ceph: request Fw caps before updating the mtime in
 ceph_write_iter
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Luis Henriques <lhenriques@suse.de>,
        Xiubo Li <xiubli@redhat.com>,
        Jozef =?UTF-8?Q?Kov=C3=A1=C4=8D?= <kovac@firma.zoznam.sk>
Date:   Fri, 20 Aug 2021 06:40:11 -0400
In-Reply-To: <CAAM7YAnGbhTmHVUVK_0Ve0P+R45J7iuk9VicuQZAA-YsN470uA@mail.gmail.com>
References: <20210811112324.8870-1-jlayton@kernel.org>
         <CAAM7YAnGbhTmHVUVK_0Ve0P+R45J7iuk9VicuQZAA-YsN470uA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-08-20 at 13:16 +0800, Yan, Zheng wrote:
> On Wed, Aug 11, 2021 at 7:24 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > The current code will update the mtime and then try to get caps to
> > handle the write. If we end up having to request caps from the MDS, then
> > the mtime in the cap grant will clobber the updated mtime and it'll be
> > lost.
> > 
> > This is most noticable when two clients are alternately writing to the
> > same file. Fw caps are continually being granted and revoked, and the
> > mtime ends up stuck because the updated mtimes are always being
> > overwritten with the old one.
> > 
> > Fix this by changing the order of operations in ceph_write_iter. Get the
> > caps much earlier, and only update the times afterward. Also, make sure
> > we check the NEARFULL conditions before making any changes to the inode.
> > 
> > URL: https://tracker.ceph.com/issues/46574
> > Reported-by: Jozef Kováč <kovac@firma.zoznam.sk>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/file.c | 34 +++++++++++++++++-----------------
> >  1 file changed, 17 insertions(+), 17 deletions(-)
> > 
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index f55ca2c4c7de..5867acfc6a51 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -1722,22 +1722,6 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >                 goto out;
> >         }
> > 
> > -       err = file_remove_privs(file);
> > -       if (err)
> > -               goto out;
> > -
> > -       err = file_update_time(file);
> > -       if (err)
> > -               goto out;
> > -
> > -       inode_inc_iversion_raw(inode);
> > -
> > -       if (ci->i_inline_version != CEPH_INLINE_NONE) {
> > -               err = ceph_uninline_data(file, NULL);
> > -               if (err < 0)
> > -                       goto out;
> > -       }
> > -
> >         down_read(&osdc->lock);
> >         map_flags = osdc->osdmap->flags;
> >         pool_flags = ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool_id);
> > @@ -1748,6 +1732,12 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >                 goto out;
> >         }
> > 
> > +       if (ci->i_inline_version != CEPH_INLINE_NONE) {
> > +               err = ceph_uninline_data(file, NULL);
> > +               if (err < 0)
> > +                       goto out;
> > +       }
> > +
> >         dout("aio_write %p %llx.%llx %llu~%zd getting caps. i_size %llu\n",
> >              inode, ceph_vinop(inode), pos, count, i_size_read(inode));
> >         if (fi->fmode & CEPH_FILE_MODE_LAZY)
> > @@ -1759,6 +1749,16 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >         if (err < 0)
> >                 goto out;
> > 
> > +       err = file_remove_privs(file);
> > +       if (err)
> > +               goto out_caps;
> 
> this may send setattr request to mds. holding cap here may cause deadlock.
> 

Thanks, Zheng -- good point. I guess we can move this call to before the
cap acquisition. I'll test that out and send a v3.

> > +
> > +       err = file_update_time(file);
> > +       if (err)
> > +               goto out_caps;
> > +
> > +       inode_inc_iversion_raw(inode);
> > +
> >         dout("aio_write %p %llx.%llx %llu~%zd got cap refs on %s\n",
> >              inode, ceph_vinop(inode), pos, count, ceph_cap_string(got));
> > 
> > @@ -1822,7 +1822,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >                 if (ceph_quota_is_max_bytes_approaching(inode, iocb->ki_pos))
> >                         ceph_check_caps(ci, 0, NULL);
> >         }
> > -
> > +out_caps:
> >         dout("aio_write %p %llx.%llx %llu~%u  dropping cap refs on %s\n",
> >              inode, ceph_vinop(inode), pos, (unsigned)count,
> >              ceph_cap_string(got));
> > --
> > 2.31.1
> > 

-- 
Jeff Layton <jlayton@kernel.org>

