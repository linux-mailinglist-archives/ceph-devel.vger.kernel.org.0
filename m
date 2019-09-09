Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5153FADC04
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Sep 2019 17:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbfIIPVa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Sep 2019 11:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbfIIPV3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 9 Sep 2019 11:21:29 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E06F02196E;
        Mon,  9 Sep 2019 15:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568042488;
        bh=k6zbJ+gEG7loi3Ov1jXhBwQSpuOLqU/pMsFhytFDiE0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K3I5yrd6hEMLSFr16dEqQ/4Nr+6NWnBTjUNCT88tEKkxnJcP5/IeEM4gMY+7hr8dB
         RYlUnVrSgE5SAe9mJr0cXLtjoq8cIymkNHwTRjw7RdBKbENZR1V0hpSdtzaBRTOQR8
         g6/GhyOuUa2u5FTa13l040cGwHCrwZORXqzRokp8=
Message-ID: <936a7ba7ee580985d5bd346ee543480dffcf8ac2.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: allow object copies across different
 filesystems in the same cluster
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>
Cc:     IlyaDryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 09 Sep 2019 11:21:26 -0400
In-Reply-To: <878sqxo9pj.fsf@suse.com>
References: <87k1ahojri.fsf@suse.com>
         <20190909102834.16246-1-lhenriques@suse.com>
         <3f838e42a50575595c7310386cf698aca8f89607.camel@kernel.org>
         <30c007d0c735cd37121e3c2264c1ec3cfdcfd89f.camel@kernel.org>
         <878sqxo9pj.fsf@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-09-09 at 14:55 +0100, Luis Henriques wrote:
> "Jeff Layton" <jlayton@kernel.org> writes:
> 
> > On Mon, 2019-09-09 at 06:35 -0400, Jeff Layton wrote:
> > > On Mon, 2019-09-09 at 11:28 +0100, Luis Henriques wrote:
> > > > OSDs are able to perform object copies across different pools.  Thus,
> > > > there's no need to prevent copy_file_range from doing remote copies if the
> > > > source and destination superblocks are different.  Only return -EXDEV if
> > > > they have different fsid (the cluster ID).
> > > > 
> > > > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > > > ---
> > > >  fs/ceph/file.c | 18 ++++++++++++++----
> > > >  1 file changed, 14 insertions(+), 4 deletions(-)
> > > > 
> > > > Hi,
> > > > 
> > > > Here's the patch changelog since initial submittion:
> > > > 
> > > > - Dropped have_fsid checks on client structs
> > > > - Use %pU to print the fsid instead of raw hex strings (%*ph)
> > > > - Fixed 'To:' field in email so that this time the patch hits vger
> > > > 
> > > > Cheers,
> > > > --
> > > > Luis
> > > > 
> > > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > > index 685a03cc4b77..4a624a1dd0bb 100644
> > > > --- a/fs/ceph/file.c
> > > > +++ b/fs/ceph/file.c
> > > > @@ -1904,6 +1904,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > > >  	struct ceph_inode_info *src_ci = ceph_inode(src_inode);
> > > >  	struct ceph_inode_info *dst_ci = ceph_inode(dst_inode);
> > > >  	struct ceph_cap_flush *prealloc_cf;
> > > > +	struct ceph_fs_client *src_fsc = ceph_inode_to_client(src_inode);
> > > >  	struct ceph_object_locator src_oloc, dst_oloc;
> > > >  	struct ceph_object_id src_oid, dst_oid;
> > > >  	loff_t endoff = 0, size;
> > > > @@ -1915,8 +1916,17 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > > >  
> > > >  	if (src_inode == dst_inode)
> > > >  		return -EINVAL;
> > > > -	if (src_inode->i_sb != dst_inode->i_sb)
> > > > -		return -EXDEV;
> > > > +	if (src_inode->i_sb != dst_inode->i_sb) {
> > > > +		struct ceph_fs_client *dst_fsc = ceph_inode_to_client(dst_inode);
> > > > +
> > > > +		if (ceph_fsid_compare(&src_fsc->client->fsid,
> > > > +				      &dst_fsc->client->fsid)) {
> > > > +			dout("Copying object across different clusters:");
> > > > +			dout("  src fsid: %pU dst fsid: %pU\n",
> > > > +			     &src_fsc->client->fsid, &dst_fsc->client->fsid);
> > > > +			return -EXDEV;
> > > > +		}
> > > > +	}
> > > 
> > > Just to be clear: what happens here if I mount two entirely separate
> > > clusters, and their OSDs don't have any access to one another? Will this
> > > fail at some later point with an error that we can catch so that we can
> > > fall back?
> > > 
> > 
> > Duh, sorry I asked before I had a cup of coffee this morning. The whole
> > point is to skip that case.
> > 
> > That said...I wonder if it's possible to have an fsid collision across
> > two separate clusters and this fail to catch that case? Aren't these
> > things just allocated via a simple counter increment?
> 
> My understanding is that this is some sort of UUID.  Looking at
> doc/install/manual-deployment.rst it says that the fsid is a unique ID
> that should be generated using uuidgen (I believe that's what vstart.sh
> clusters use).
> 
> That said, it's obviously possible to reuse an fsid in two clusters.
> And mounting both filesystems with the same fsid on the same client may
> already cause some troubles without even trying to copy_file_range files
> across them (for ex., fscache code seems to assume unique fsids).  But I
> have never tested such sort of things (probably no one did) and I really
> don't know what are the consequences.  In this specific case, I would
> expect the 'copy-from' operation to fail with some error from the OSDs.
> 

Makes sense. I suppose the worst possible case is data corruption due to
copying to/from the wrong object, but the risk here seems quite low.

> > Probably not worth worrying about overmuch, but might be good to
> > understand what would happen in that case if only to field mailing list
> > reports.
> 
> If there are concerns regarding this, I'm OK simply dropping the patch
> for now and continue forbidding object copies when superblocks are
> different.  I just thought this was a low-hanging fruit, and didn't
> realized that it's not very easy to ensure that 2 cephfs instances
> actually belong to the same cluster.  Maybe there are other checks that
> could be done...?
> 

I'm not really concerned about it, particularly if these values are
usually generated as uuids. If we get reports that involve collisions
here, then we can revisit it then.

IMO, it's up to the admin to guarantee that the fsid is unique within a
multi-cluster environment.
-- 
Jeff Layton <jlayton@kernel.org>

