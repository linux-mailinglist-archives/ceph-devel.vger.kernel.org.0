Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425D243DF27
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 12:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhJ1KrP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 06:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhJ1KrO (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 06:47:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8443560EBD;
        Thu, 28 Oct 2021 10:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635417888;
        bh=zUbqylPyFA/VkO9M4iz3Ht9E3mdUIm/eIZC9g0OIhmI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ga4yYe2vvfXKF11cvqZ744C3fTGgFSFLqlAs8M810j64+yo5yL/U+gGBEWrK5Xzzh
         5d9sifAM9+zlD6U14EE0oFYYmxO8/Pxb86E+1RYcxc11ckotUwGZFthmsXyjOkNrA2
         OkY1EVSIs3bbfXWpJFjcfCpE3IuSUvvdoOMUi1b/DPyLdKeUDS5qWhrr/6a20rKTS7
         pzucgNMAcfvaia49PzQWYBdvJIxov/IZmMXS1701CfT2+k1Gzl4sX3xmB72PG8bD6Z
         F2/R81Q3Nk9i+4CFCJYWN4+nvOtchiyTSx/LXHa9DnG++z0LlNUDgmXau7ftIR9qPz
         mV83wa5hgXkoQ==
Message-ID: <03058ef4a3a783b1a879c5e4059aac72d475f9c4.camel@kernel.org>
Subject: Re: [PATCH v3 1/4] ceph: add __ceph_get_caps helper support
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 28 Oct 2021 06:44:46 -0400
In-Reply-To: <c9255017-333d-68dd-880a-96952e08ca08@redhat.com>
References: <20211028091438.21402-1-xiubli@redhat.com>
         <20211028091438.21402-2-xiubli@redhat.com>
         <c9255017-333d-68dd-880a-96952e08ca08@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I see your cover letter for this series on the list. You may just be
running across how gmail's (infuriating) labeling works? I don't think
they ever show up in patchwork though (since they don't have patches in
them).

-- Jeff


On Thu, 2021-10-28 at 17:23 +0800, Xiubo Li wrote:
> Hi Jeff,
> 
> Not sure why the cover-letter is not displayed in both the mail list and 
> ceph patchwork, locally it was successfully sent out.
> 
> Any idea ?
> 
> Thanks
> 
> -- Xiubo
> 
> 
> On 10/28/21 5:14 PM, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >   fs/ceph/caps.c  | 19 +++++++++++++------
> >   fs/ceph/super.h |  2 ++
> >   2 files changed, 15 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index d628dcdbf869..4e2a588465c5 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -2876,10 +2876,9 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
> >    * due to a small max_size, make sure we check_max_size (and possibly
> >    * ask the mds) so we don't get hung up indefinitely.
> >    */
> > -int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got)
> > +int __ceph_get_caps(struct inode *inode, struct ceph_file_info *fi, int need,
> > +		    int want, loff_t endoff, int *got)
> >   {
> > -	struct ceph_file_info *fi = filp->private_data;
> > -	struct inode *inode = file_inode(filp);
> >   	struct ceph_inode_info *ci = ceph_inode(inode);
> >   	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> >   	int ret, _got, flags;
> > @@ -2888,7 +2887,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
> >   	if (ret < 0)
> >   		return ret;
> >   
> > -	if ((fi->fmode & CEPH_FILE_MODE_WR) &&
> > +	if (fi && (fi->fmode & CEPH_FILE_MODE_WR) &&
> >   	    fi->filp_gen != READ_ONCE(fsc->filp_gen))
> >   		return -EBADF;
> >   
> > @@ -2896,7 +2895,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
> >   
> >   	while (true) {
> >   		flags &= CEPH_FILE_MODE_MASK;
> > -		if (atomic_read(&fi->num_locks))
> > +		if (fi && atomic_read(&fi->num_locks))
> >   			flags |= CHECK_FILELOCK;
> >   		_got = 0;
> >   		ret = try_get_cap_refs(inode, need, want, endoff,
> > @@ -2941,7 +2940,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
> >   				continue;
> >   		}
> >   
> > -		if ((fi->fmode & CEPH_FILE_MODE_WR) &&
> > +		if (fi && (fi->fmode & CEPH_FILE_MODE_WR) &&
> >   		    fi->filp_gen != READ_ONCE(fsc->filp_gen)) {
> >   			if (ret >= 0 && _got)
> >   				ceph_put_cap_refs(ci, _got);
> > @@ -3004,6 +3003,14 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
> >   	return 0;
> >   }
> >   
> > +int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got)
> > +{
> > +	struct ceph_file_info *fi = filp->private_data;
> > +	struct inode *inode = file_inode(filp);
> > +
> > +	return __ceph_get_caps(inode, fi, need, want, endoff, got);
> > +}
> > +
> >   /*
> >    * Take cap refs.  Caller must already know we hold at least one ref
> >    * on the caps in question or we don't know this is safe.
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 7f3976b3319d..027d5f579ba0 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -1208,6 +1208,8 @@ extern int ceph_encode_dentry_release(void **p, struct dentry *dn,
> >   				      struct inode *dir,
> >   				      int mds, int drop, int unless);
> >   
> > +extern int __ceph_get_caps(struct inode *inode, struct ceph_file_info *fi,
> > +			   int need, int want, loff_t endoff, int *got);
> >   extern int ceph_get_caps(struct file *filp, int need, int want,
> >   			 loff_t endoff, int *got);
> >   extern int ceph_try_get_caps(struct inode *inode,
> 

-- 
Jeff Layton <jlayton@kernel.org>

