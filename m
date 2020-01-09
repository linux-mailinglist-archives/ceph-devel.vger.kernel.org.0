Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5697135A2D
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 14:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbgAINde (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 08:33:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:32768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728974AbgAINde (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 08:33:34 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1703820661;
        Thu,  9 Jan 2020 13:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578576813;
        bh=k8oYA3Zfxb737fchFs/GkzxOSznYGq7WjG0IGg3JO/g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=duJNURcHb9mJgygCT9SZrk33fQOUnkU8Kl+TFjp+jIYgSMsM0Ff0uUv0XmD8rXlwW
         s2x/NgbvJDpg7mEXnYLzyGkAu4Vw3Fh7YCJS2QRJjg6GUNp2oBN0RW4kVkMikmIomU
         bo9mu+/wp76inxzMWQHaJUG8Kbn0pPxRReomyjKk=
Message-ID: <ab6d12e45f87a427bd442a84dae23893ad4b91e8.camel@kernel.org>
Subject: Re: [PATCH 2/6] ceph: hold extra reference to r_parent over life of
 request
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com
Date:   Thu, 09 Jan 2020 08:33:31 -0500
In-Reply-To: <95938157-3d47-52e5-d847-b058e1191151@redhat.com>
References: <20200106153520.307523-1-jlayton@kernel.org>
         <20200106153520.307523-3-jlayton@kernel.org>
         <e8e28503-bda4-df57-6a42-33761e716fe4@redhat.com>
         <7baad50a9e9f8d8f93171e5d4756bc35ab36a319.camel@kernel.org>
         <95938157-3d47-52e5-d847-b058e1191151@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-01-09 at 21:16 +0800, Xiubo Li wrote:
> On 2020/1/9 19:20, Jeff Layton wrote:
> > On Thu, 2020-01-09 at 10:05 +0800, Xiubo Li wrote:
> > > On 2020/1/6 23:35, Jeff Layton wrote:
> > > > Currently, we just assume that it will stick around by virtue of the
> > > > submitter's reference, but later patches will allow the syscall to
> > > > return early and we can't rely on that reference at that point.
> > > > 
> > > > Take an extra reference to the inode when setting r_parent and release
> > > > it when releasing the request.
> > > > 
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >    fs/ceph/mds_client.c | 8 ++++++--
> > > >    1 file changed, 6 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > index 94cce2ab92c4..b7122f682678 100644
> > > > --- a/fs/ceph/mds_client.c
> > > > +++ b/fs/ceph/mds_client.c
> > > > @@ -708,8 +708,10 @@ void ceph_mdsc_release_request(struct kref *kref)
> > > >    		/* avoid calling iput_final() in mds dispatch threads */
> > > >    		ceph_async_iput(req->r_inode);
> > > >    	}
> > > > -	if (req->r_parent)
> > > > +	if (req->r_parent) {
> > > >    		ceph_put_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
> > > > +		ceph_async_iput(req->r_parent);
> > > > +	}
> > > >    	ceph_async_iput(req->r_target_inode);
> > > >    	if (req->r_dentry)
> > > >    		dput(req->r_dentry);
> > > > @@ -2706,8 +2708,10 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
> > > >    	/* take CAP_PIN refs for r_inode, r_parent, r_old_dentry */
> > > >    	if (req->r_inode)
> > > >    		ceph_get_cap_refs(ceph_inode(req->r_inode), CEPH_CAP_PIN);
> > > > -	if (req->r_parent)
> > > > +	if (req->r_parent) {
> > > >    		ceph_get_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
> > > > +		ihold(req->r_parent);
> > > > +	}
> > > This might also fix another issue when the mdsc request is timedout and
> > > returns to the vfs, then the r_parent maybe released in vfs. And then if
> > > we reference it again in mdsc handle_reply() -->
> > > ceph_mdsc_release_request(),  some unknown issues may happen later ??
> > > 
> > AIUI, when a timeout occurs, the req is unhashed such that handle_reply
> > can't find it. So, I doubt this affects that one way or another.
> 
> If my understanding is correct, such as for rmdir(), the logic will be :
> 
> req = ceph_mdsc_create_request()      //  ref == 1
> 
> ceph_mdsc_do_request(req) -->
> 
>          ceph_mdsc_submit_request(req) -->
> 
>                  __register_request(req) // ref == 2
> 
>          ceph_mdsc_wait_request(req)  // If timedout
> 
> ceph_mdsc_put_request(req)  // ref == 1
> 
> Then in handled_reply(), only when we get a safe reply it will call 
> __unregister_request(req), then the ref could be 0.
> 
> Though it will ihold()/ceph_async_iput() the req->r_unsafe_dir(= 
> req->r_parent) , but the _iput() will be called just before we reference 
> the req->r_parent in the _relase_request(). And the _iput() here may 
> call the iput_final().
> 

I take it back, I think you're right. This likely would fix that issue
up. I'll plan to add a note about that to the changelog before I merge
it. Should we mark this for stable in light of that?
-- 
Jeff Layton <jlayton@kernel.org>

