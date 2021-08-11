Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771563E9360
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Aug 2021 16:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhHKOPq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Aug 2021 10:15:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232341AbhHKOPp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 10:15:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 612DD61008;
        Wed, 11 Aug 2021 14:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628691321;
        bh=vBiygk+AKYKOliwzMWMwnqYl6QoQpjWIGY2UwsvzkZk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rHO4RmgRSWYmj2aiEwkjg+2jXIPDVmGF60SRRyPsKm5C3H5F+eI+Jbv7Pb4bvZdEV
         H+VzdZwqYQ2Rlibc4wRPT2uvHkuRWnkM4NU381jCWnaXDlAhyn4h3RRK2lmdgUagz8
         aqi2pCxDzPNeUSYoChHg70yvBMgfiMnoqcdBDbmP8HS6FY7BkAyRhMd50cozxeIKFv
         Oo9TO802j2Ey47YTZ6f5fEd4SDf49hI9HT4n8AV07poYQ9IUGTUObXX8gGbcQGQnqA
         mGAkXTZhenXx0CWKfz/X4A+UukhCNhLaECx1Fhs/UUrGKnPLPE2cNZZTxSriKVrXy3
         zx8C6InkdXntA==
Message-ID: <f555ee5c1f3967904c498f492aebb1b2d7a2228c.camel@kernel.org>
Subject: Re: [PATCH] ceph: request Fw caps before updating the mtime in
 ceph_write_iter
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, xiubli@redhat.com,
        Jozef =?UTF-8?Q?Kov=C3=A1=C4=8D?= <kovac@firma.zoznam.sk>
Date:   Wed, 11 Aug 2021 10:15:20 -0400
In-Reply-To: <87sfzgqdje.fsf@suse.de>
References: <20210811112324.8870-1-jlayton@kernel.org>
         <87sfzgqdje.fsf@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-08-11 at 15:08 +0100, Luis Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
> 
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
> >  		goto out;
> >  	}
> >  
> > -	err = file_remove_privs(file);
> > -	if (err)
> > -		goto out;
> > -
> > -	err = file_update_time(file);
> > -	if (err)
> > -		goto out;
> > -
> > -	inode_inc_iversion_raw(inode);
> > -
> > -	if (ci->i_inline_version != CEPH_INLINE_NONE) {
> > -		err = ceph_uninline_data(file, NULL);
> > -		if (err < 0)
> > -			goto out;
> > -	}
> > -
> >  	down_read(&osdc->lock);
> >  	map_flags = osdc->osdmap->flags;
> >  	pool_flags = ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool_id);
> > @@ -1748,6 +1732,12 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >  		goto out;
> >  	}
> >  
> > +	if (ci->i_inline_version != CEPH_INLINE_NONE) {
> > +		err = ceph_uninline_data(file, NULL);
> > +		if (err < 0)
> > +			goto out;
> > +	}
> > +
> >  	dout("aio_write %p %llx.%llx %llu~%zd getting caps. i_size %llu\n",
> >  	     inode, ceph_vinop(inode), pos, count, i_size_read(inode));
> >  	if (fi->fmode & CEPH_FILE_MODE_LAZY)
> > @@ -1759,6 +1749,16 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >  	if (err < 0)
> >  		goto out;
> >  
> > +	err = file_remove_privs(file);
> > +	if (err)
> > +		goto out_caps;
> > +
> > +	err = file_update_time(file);
> > +	if (err)
> > +		goto out_caps;
> 
> Unless I'm missing something (which happens quite frequently!) i_rwsem
> still needs to be released through either ceph_end_io_write() or
> ceph_end_io_direct().  And this isn't being done if we jump to out_caps
> (yeah, goto's spaghetti fun).
> 

Good catch! I'll send a v2 in a bit after I test it.

> Also, this patch is probably worth adding to stable@ too, although I
> haven't checked how easy is it to cherry-pick to older kernel versions.
> 

I'm not sure it qualifies for stable. We do have an open tracker bug for
it, but the only real problem is that the mtime/change_attr stall out
while there is competing I/O. Definitely broken, but I'm not sure it's
really affecting that many people.

-- 
Jeff Layton <jlayton@kernel.org>

