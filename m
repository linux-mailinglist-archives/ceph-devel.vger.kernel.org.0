Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4075AADA8D
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Sep 2019 15:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405035AbfIINzj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Sep 2019 09:55:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:47126 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404953AbfIINzj (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 9 Sep 2019 09:55:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 179FCAC8E;
        Mon,  9 Sep 2019 13:55:37 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     "Jeff Layton" <jlayton@kernel.org>
Cc:     "IlyaDryomov" <idryomov@gmail.com>, "Sage Weil" <sage@redhat.com>,
        <ceph-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ceph: allow object copies across different filesystems in the same cluster
References: <87k1ahojri.fsf@suse.com>
        <20190909102834.16246-1-lhenriques@suse.com>
        <3f838e42a50575595c7310386cf698aca8f89607.camel@kernel.org>
        <30c007d0c735cd37121e3c2264c1ec3cfdcfd89f.camel@kernel.org>
Date:   Mon, 09 Sep 2019 14:55:36 +0100
In-Reply-To: <30c007d0c735cd37121e3c2264c1ec3cfdcfd89f.camel@kernel.org> (Jeff
        Layton's message of "Mon, 09 Sep 2019 07:05:54 -0400")
Message-ID: <878sqxo9pj.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

"Jeff Layton" <jlayton@kernel.org> writes:

> On Mon, 2019-09-09 at 06:35 -0400, Jeff Layton wrote:
>> On Mon, 2019-09-09 at 11:28 +0100, Luis Henriques wrote:
>> > OSDs are able to perform object copies across different pools.  Thus,
>> > there's no need to prevent copy_file_range from doing remote copies if the
>> > source and destination superblocks are different.  Only return -EXDEV if
>> > they have different fsid (the cluster ID).
>> > 
>> > Signed-off-by: Luis Henriques <lhenriques@suse.com>
>> > ---
>> >  fs/ceph/file.c | 18 ++++++++++++++----
>> >  1 file changed, 14 insertions(+), 4 deletions(-)
>> > 
>> > Hi,
>> > 
>> > Here's the patch changelog since initial submittion:
>> > 
>> > - Dropped have_fsid checks on client structs
>> > - Use %pU to print the fsid instead of raw hex strings (%*ph)
>> > - Fixed 'To:' field in email so that this time the patch hits vger
>> > 
>> > Cheers,
>> > --
>> > Luis
>> > 
>> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> > index 685a03cc4b77..4a624a1dd0bb 100644
>> > --- a/fs/ceph/file.c
>> > +++ b/fs/ceph/file.c
>> > @@ -1904,6 +1904,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>> >  	struct ceph_inode_info *src_ci = ceph_inode(src_inode);
>> >  	struct ceph_inode_info *dst_ci = ceph_inode(dst_inode);
>> >  	struct ceph_cap_flush *prealloc_cf;
>> > +	struct ceph_fs_client *src_fsc = ceph_inode_to_client(src_inode);
>> >  	struct ceph_object_locator src_oloc, dst_oloc;
>> >  	struct ceph_object_id src_oid, dst_oid;
>> >  	loff_t endoff = 0, size;
>> > @@ -1915,8 +1916,17 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>> >  
>> >  	if (src_inode == dst_inode)
>> >  		return -EINVAL;
>> > -	if (src_inode->i_sb != dst_inode->i_sb)
>> > -		return -EXDEV;
>> > +	if (src_inode->i_sb != dst_inode->i_sb) {
>> > +		struct ceph_fs_client *dst_fsc = ceph_inode_to_client(dst_inode);
>> > +
>> > +		if (ceph_fsid_compare(&src_fsc->client->fsid,
>> > +				      &dst_fsc->client->fsid)) {
>> > +			dout("Copying object across different clusters:");
>> > +			dout("  src fsid: %pU dst fsid: %pU\n",
>> > +			     &src_fsc->client->fsid, &dst_fsc->client->fsid);
>> > +			return -EXDEV;
>> > +		}
>> > +	}
>> 
>> Just to be clear: what happens here if I mount two entirely separate
>> clusters, and their OSDs don't have any access to one another? Will this
>> fail at some later point with an error that we can catch so that we can
>> fall back?
>> 
>
> Duh, sorry I asked before I had a cup of coffee this morning. The whole
> point is to skip that case.
>
> That said...I wonder if it's possible to have an fsid collision across
> two separate clusters and this fail to catch that case? Aren't these
> things just allocated via a simple counter increment?

My understanding is that this is some sort of UUID.  Looking at
doc/install/manual-deployment.rst it says that the fsid is a unique ID
that should be generated using uuidgen (I believe that's what vstart.sh
clusters use).

That said, it's obviously possible to reuse an fsid in two clusters.
And mounting both filesystems with the same fsid on the same client may
already cause some troubles without even trying to copy_file_range files
across them (for ex., fscache code seems to assume unique fsids).  But I
have never tested such sort of things (probably no one did) and I really
don't know what are the consequences.  In this specific case, I would
expect the 'copy-from' operation to fail with some error from the OSDs.

> Probably not worth worrying about overmuch, but might be good to
> understand what would happen in that case if only to field mailing list
> reports.

If there are concerns regarding this, I'm OK simply dropping the patch
for now and continue forbidding object copies when superblocks are
different.  I just thought this was a low-hanging fruit, and didn't
realized that it's not very easy to ensure that 2 cephfs instances
actually belong to the same cluster.  Maybe there are other checks that
could be done...?

Cheers,
-- 
Luis

> Other than that, this looks fine, modulo Ilya's comment about the two
> dout messages.
>
>> 
>> >  	if (ceph_snap(dst_inode) != CEPH_NOSNAP)
>> >  		return -EROFS;
>> >  
>> > @@ -1928,7 +1938,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>> >  	 * efficient).
>> >  	 */
>> >  
>> > -	if (ceph_test_mount_opt(ceph_inode_to_client(src_inode), NOCOPYFROM))
>> > +	if (ceph_test_mount_opt(src_fsc, NOCOPYFROM))
>> >  		return -EOPNOTSUPP;
>> >  
>> >  	if ((src_ci->i_layout.stripe_unit != dst_ci->i_layout.stripe_unit) ||
>> > @@ -2044,7 +2054,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>> >  				dst_ci->i_vino.ino, dst_objnum);
>> >  		/* Do an object remote copy */
>> >  		err = ceph_osdc_copy_from(
>> > -			&ceph_inode_to_client(src_inode)->client->osdc,
>> > +			&src_fsc->client->osdc,
>> >  			src_ci->i_vino.snap, 0,
>> >  			&src_oid, &src_oloc,
>> >  			CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
