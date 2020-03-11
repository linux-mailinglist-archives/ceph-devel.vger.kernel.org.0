Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2462181682
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Mar 2020 12:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgCKLFA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Mar 2020 07:05:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:32912 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgCKLFA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 07:05:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A9A25ABD7;
        Wed, 11 Mar 2020 11:04:58 +0000 (UTC)
Received: from localhost (webern.olymp [local])
        by webern.olymp (OpenSMTPD) with ESMTPA id 6d713f85;
        Wed, 11 Mar 2020 11:04:56 +0000 (WET)
Date:   Wed, 11 Mar 2020 11:04:56 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Marc Roos <M.Roos@f1-outsourcing.eu>
Cc:     jlayton <jlayton@kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Subject: Re: [ceph-users] cephfs snap mkdir strange timestamp
Message-ID: <20200311110456.GA58729@suse.com>
References: <20200311103142.GA6863@suse.com>
 <"H00000710016454f.1583923016.sx.f1-outsourcing.eu*"@MHS>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <"H00000710016454f.1583923016.sx.f1-outsourcing.eu*"@MHS>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Mar 11, 2020 at 11:36:56AM +0100, Marc Roos wrote:
> 
> Sorry I am not really developer nor now details about POSIX/fs's. But if 
> I may ask, why are you getting this time from the parent?

The hidden .snap directory is ceph-specific, and not really POSIX
compliant.  It's handled in a special way and doesn't really have all the
typical directory attributes (such as timestamps).  Hence, the fuse client
is getting these attributes from the parent directory instead of showing
the funny 1970-01-01 (epoch) date.

Cheers,
--
Luis

> 
> 
> 
> -----Original Message-----
> Sent: 11 March 2020 11:32
> To: Jeff Layton
> Cc: Marc Roos; ceph-users; ceph-devel@vger.kernel.org
> Subject: Re: [ceph-users] cephfs snap mkdir strange timestamp
> 
> On Tue, Mar 10, 2020 at 01:39:29PM -0400, Jeff Layton wrote:
> ...
> > > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > > ---
> > >  fs/ceph/inode.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c index 
> > > d01710a16a4a..f4e78ade0871 100644
> > > --- a/fs/ceph/inode.c
> > > +++ b/fs/ceph/inode.c
> > > @@ -82,6 +82,8 @@ struct inode *ceph_get_snapdir(struct inode 
> *parent)
> > >  	inode->i_mode = parent->i_mode;
> > >  	inode->i_uid = parent->i_uid;
> > >  	inode->i_gid = parent->i_gid;
> > > +	inode->i_mtime = parent->i_mtime;
> > > +	inode->i_ctime = parent->i_ctime;
> > >  	inode->i_op = &ceph_snapdir_iops;
> > >  	inode->i_fop = &ceph_snapdir_fops;
> > >  	ci->i_snap_caps = CEPH_CAP_PIN; /* so we can open */
> > 
> > What about the atime, and the ci->i_btime ?
> 
> Yeah, probably makes sense too, although the fuse client doesn't seem to 
> touch atime (it does change btime, I missed that).  I'll send v2 in a 
> bit.
> 
> Cheers,
> --
> Luis
> 
> 
