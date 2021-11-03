Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9869A443FEF
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Nov 2021 11:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhKCK1V (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Nov 2021 06:27:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231278AbhKCK1V (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 06:27:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EE3D60EBB;
        Wed,  3 Nov 2021 10:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635935084;
        bh=XfoGM2ZMKLelTHY48hfvr9rhIfvKVz6MAhNQernrwn8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Hg1xHANKTUprfItrCZS5msB3MLjIGpXk9AfiWtCSaJwQb2QOdvNVd+ssBw5i4Cznl
         LLLSG/SiP9dJdT123CD3jLkUsMyZ6N5rsQti/v2WDOsywaxIdXhPXCtqOo1jNRXLNd
         MLvBmfPGds1Do1REJ2mTAUH0s7QvxgA+1uTHFu270GNPBStkCMYDv98eUNqu4Mq9/5
         EBUpDZ78wlzpZtCU/9/Z9IoBLAM/4f7x73MW6f3Dr79lrkHuYn9L1lhnYb2SxFIZsv
         e69j48L8D9Y3gG+DO2SEcnFP38zQNWiZ2UHd5nRp8H5c0bfX+hlTz9uJD90K8z5IYi
         wF2Iz7htF5Hdw==
Message-ID: <ad0c7708441440665dfa22fc84e978caee03ed65.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: properly handle statfs on multifs setups
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org,
        idryomov@gmail.com
Cc:     Sachin Prabhu <sprabhu@redhat.com>
Date:   Wed, 03 Nov 2021 06:24:43 -0400
In-Reply-To: <fcdeaedc-ab5d-6c0c-d6b2-a59e302975ef@redhat.com>
References: <20211102204547.253710-1-jlayton@kernel.org>
         <fcdeaedc-ab5d-6c0c-d6b2-a59e302975ef@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.0 (3.42.0-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-11-03 at 14:56 +0800, Xiubo Li wrote:
> On 11/3/21 4:45 AM, Jeff Layton wrote:
> > ceph_statfs currently stuffs the cluster fsid into the f_fsid field.
> > This was fine when we only had a single filesystem per cluster, but now
> > that we have multiples we need to use something that will vary between
> > them.
> > 
> > Change ceph_statfs to xor each 32-bit chunk of the fsid (aka cluster id)
> > into the lower bits of the statfs->f_fsid. Change the lower bits to hold
> > the fscid (filesystem ID within the cluster).
> > 
> > That should give us a value that is guaranteed to be unique between
> > filesystems within a cluster, and should minimize the chance of
> > collisions between mounts of different clusters.
> > 
> > URL: https://tracker.ceph.com/issues/52812
> > Reported-by: Sachin Prabhu <sprabhu@redhat.com>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   fs/ceph/super.c | 11 ++++++-----
> >   1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > While looking at making an equivalent change to the userland libraries,
> > it occurred to me that the earlier patch's method for computing this
> > was overly-complex. This makes it a bit simpler, and avoids the
> > intermediate step of setting up a u64.
> > 
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 9bb88423417e..e7b839aa08f6 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -52,8 +52,7 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
> >   	struct ceph_fs_client *fsc = ceph_inode_to_client(d_inode(dentry));
> >   	struct ceph_mon_client *monc = &fsc->client->monc;
> >   	struct ceph_statfs st;
> > -	u64 fsid;
> > -	int err;
> > +	int i, err;
> >   	u64 data_pool;
> >   
> >   	if (fsc->mdsc->mdsmap->m_num_data_pg_pools == 1) {
> > @@ -99,12 +98,14 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
> >   	buf->f_namelen = NAME_MAX;
> >   
> >   	/* Must convert the fsid, for consistent values across arches */
> > +	buf->f_fsid.val[0] = 0;
> >   	mutex_lock(&monc->mutex);
> > -	fsid = le64_to_cpu(*(__le64 *)(&monc->monmap->fsid)) ^
> > -	       le64_to_cpu(*((__le64 *)&monc->monmap->fsid + 1));
> > +	for (i = 0; i < 4; ++i)
> > +		buf->f_fsid.val[0] ^= le32_to_cpu(((__le32 *)&monc->monmap->fsid)[i]);
> >   	mutex_unlock(&monc->mutex);
> >   
> > -	buf->f_fsid = u64_to_fsid(fsid);
> > +	/* fold the fs_cluster_id into the upper bits */
> > +	buf->f_fsid.val[1] = monc->fs_cluster_id;
> >   
> >   	return 0;
> >   }
> 
> This version looks better.
> 
> Reviewed-by: Xiubo Li <xiubli@redhat.com>
> 
> 

Thanks. I think I'm going to make one more small change in there and
express the loop conditional as:

    i < sizeof(monc->monmap->fsid) / sizeof(__le32)

That should work out to be '4', but should be safer in case the size of
fsid ever changes. I'm not going to bother to re-post for that though.
-- 
Jeff Layton <jlayton@kernel.org>
