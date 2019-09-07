Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2FAAC6DF
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Sep 2019 15:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388202AbfIGNxc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 7 Sep 2019 09:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727381AbfIGNxc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 7 Sep 2019 09:53:32 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D62B218AC;
        Sat,  7 Sep 2019 13:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567864411;
        bh=YeRNe1rluI3yMB6/V2dkM0kBajo5PtaHZdGNp3VCpyg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=zNDd39ybWgjYOe9VEGhsX62tbfMNc3A1p2Q6twOxcTnTF9SBnHihzQ1WzFgu6JZX8
         lKp6Kguap9ifBpV6BU530v0ohGULpnCLKpUam2KL8+yruj3f3YXAVL7sjcRS+s6+eT
         GlDpk5odXkYIc+APk+Wk+8uZ9zpiN4wp29HOCc0I=
Message-ID: <afce4ec5a02c17121e615423a2e7e1b664aa77a3.camel@kernel.org>
Subject: Re: [PATCH] ceph: allow object copies across different filesystems
 in the same cluster
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 07 Sep 2019 09:53:29 -0400
In-Reply-To: <87sgp9o0fo.fsf@suse.com>
References: <20190906135750.29543-1-lhenriques@suse.com>
         <30b09cb015563913d073c488c8de8ba0cceedd7b.camel@kernel.org>
         <87sgp9o0fo.fsf@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2019-09-06 at 17:26 +0100, Luis Henriques wrote:
> "Jeff Layton" <jlayton@kernel.org> writes:
> 
> > On Fri, 2019-09-06 at 14:57 +0100, Luis Henriques wrote:
> > > OSDs are able to perform object copies across different pools.  Thus,
> > > there's no need to prevent copy_file_range from doing remote copies if the
> > > source and destination superblocks are different.  Only return -EXDEV if
> > > they have different fsid (the cluster ID).
> > > 
> > > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > > ---
> > >  fs/ceph/file.c | 23 +++++++++++++++++++----
> > >  1 file changed, 19 insertions(+), 4 deletions(-)
> > > 
> > > Hi!
> > > 
> > > I've finally managed to run some tests using multiple filesystems, both
> > > within a single cluster and also using two different clusters.  The
> > > behaviour of copy_file_range (with this patch, of course) was what I
> > > expected:
> > > 
> > >   - Object copies work fine across different filesystems within the same
> > >     cluster (even with pools in different PGs);
> > >   - -EXDEV is returned if the fsid is different
> > > 
> > > (OT: I wonder why the cluster ID is named 'fsid'; historical reasons?
> > >  Because this is actually what's in ceph.conf fsid in "[global]"
> > >  section.  Anyway...)
> > > 
> > > So, what's missing right now is (I always mention this when I have the
> > > opportunity!) to merge https://github.com/ceph/ceph/pull/25374 :-)
> > > And add the corresponding support for the new flag to the kernel
> > > client, of course.
> > > 
> > > Cheers,
> > > --
> > > Luis
> > > 
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index 685a03cc4b77..88d116893c2b 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -1904,6 +1904,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > >  	struct ceph_inode_info *src_ci = ceph_inode(src_inode);
> > >  	struct ceph_inode_info *dst_ci = ceph_inode(dst_inode);
> > >  	struct ceph_cap_flush *prealloc_cf;
> > > +	struct ceph_fs_client *src_fsc = ceph_inode_to_client(src_inode);
> > >  	struct ceph_object_locator src_oloc, dst_oloc;
> > >  	struct ceph_object_id src_oid, dst_oid;
> > >  	loff_t endoff = 0, size;
> > > @@ -1915,8 +1916,22 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > >  
> > >  	if (src_inode == dst_inode)
> > >  		return -EINVAL;
> > > -	if (src_inode->i_sb != dst_inode->i_sb)
> > > -		return -EXDEV;
> > > +	if (src_inode->i_sb != dst_inode->i_sb) {
> > > +		struct ceph_fs_client *dst_fsc = ceph_inode_to_client(dst_inode);
> > > +
> > > +		if (!src_fsc->client->have_fsid || !dst_fsc->client->have_fsid) {
> > > +			dout("No fsid in a fs client\n");
> > > +			return -EXDEV;
> > > +		}
> > 
> > In what situation is there no fsid? Old cluster version?
> > 
> > If there is no fsid, can we take that to indicate that there is only a
> > single filesystem possible in the cluster and that we should attempt the
> > copy anyway?
> 
> TBH I'm not sure if 'have_fsid' can ever be 'false' in this call.  It is
> set to 'true' when handling the monmap, and it's never changed back to
> 'false'.  Since I don't think copy_file_range will be invoked *before*
> we get the monmap, it should be safe to drop this check.  Maybe it could
> be replaced it by a WARN_ON()?
> 

Yeah. I think the have_fsid flag just allows us to avoid the pr_err msg
in ceph_check_fsid when the client is initially created. Maybe there is
some better way to achieve that?

In any case, I'd just drop that condition here.
-- 
Jeff Layton <jlayton@kernel.org>

