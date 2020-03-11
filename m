Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA5E1815D6
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Mar 2020 11:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgCKKbp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Mar 2020 06:31:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:42372 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbgCKKbp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 06:31:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1DA1CB1DC;
        Wed, 11 Mar 2020 10:31:43 +0000 (UTC)
Received: from localhost (webern.olymp [local])
        by webern.olymp (OpenSMTPD) with ESMTPA id 88c71923;
        Wed, 11 Mar 2020 10:31:42 +0000 (WET)
Date:   Wed, 11 Mar 2020 10:31:42 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Marc Roos <M.Roos@f1-outsourcing.eu>,
        ceph-users <ceph-users@ceph.io>, ceph-devel@vger.kernel.org
Subject: Re: [ceph-users] cephfs snap mkdir strange timestamp
Message-ID: <20200311103142.GA6863@suse.com>
References: <"H000007100163fdf.1583792359.sx.f1-outsourcing.eu*"@MHS>
 <"H000007100164304.1583836879.sx.f1-outsourcing.eu*"@MHS>
 <20200310134613.GA74810@suse.com>
 <7f684a1a23c007858d996346532971bd0de9f138.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f684a1a23c007858d996346532971bd0de9f138.camel@kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 10, 2020 at 01:39:29PM -0400, Jeff Layton wrote:
...
> > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > ---
> >  fs/ceph/inode.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index d01710a16a4a..f4e78ade0871 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -82,6 +82,8 @@ struct inode *ceph_get_snapdir(struct inode *parent)
> >  	inode->i_mode = parent->i_mode;
> >  	inode->i_uid = parent->i_uid;
> >  	inode->i_gid = parent->i_gid;
> > +	inode->i_mtime = parent->i_mtime;
> > +	inode->i_ctime = parent->i_ctime;
> >  	inode->i_op = &ceph_snapdir_iops;
> >  	inode->i_fop = &ceph_snapdir_fops;
> >  	ci->i_snap_caps = CEPH_CAP_PIN; /* so we can open */
> 
> What about the atime, and the ci->i_btime ?

Yeah, probably makes sense too, although the fuse client doesn't seem to
touch atime (it does change btime, I missed that).  I'll send v2 in a bit.

Cheers,
--
Luis
