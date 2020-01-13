Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E3A13920B
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jan 2020 14:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgAMNUM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jan 2020 08:20:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgAMNUM (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 08:20:12 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AF9A2084D;
        Mon, 13 Jan 2020 13:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578921610;
        bh=s9UuAe/No0ksWrbiYtrBeWPeSBHBKURLb7pWbzD/hq8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=l+RMUc1YFBPgF+zK6mll+Nl77g2wCmgaFkW1wDMAzbofz2yGG1BaqsH85ZWl3kPZg
         XPXigdSZxcrLD1afefM+Vxprk+6zjs4IxcW16/if1FxJVM/m403nBM1ac1rgP2CfGP
         kMzR3vcTHAXryKq4aqq90Y0AZGWJiqLzEei4USn4=
Message-ID: <b40d3ae50cb15d125a86d7b9c701d3836864613e.camel@kernel.org>
Subject: Re: [PATCH v2 2/8] ceph: add caps perf metric for each session
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 13 Jan 2020 08:20:09 -0500
In-Reply-To: <7075061f-2614-4bb2-cf8b-86b8b94a1f5f@redhat.com>
References: <20200108104152.28468-1-xiubli@redhat.com>
         <20200108104152.28468-3-xiubli@redhat.com>
         <38fc860f80d251d5cbb5ee49c253a725625190d9.camel@kernel.org>
         <a2ccd54f-11a3-a3e0-f299-00de28cca92d@redhat.com>
         <2290d0986978eb65519f2c4842a9e40db9ee7c85.camel@kernel.org>
         <7075061f-2614-4bb2-cf8b-86b8b94a1f5f@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-01-13 at 09:12 +0800, Xiubo Li wrote:
> On 2020/1/10 19:51, Jeff Layton wrote:
> > On Fri, 2020-01-10 at 11:38 +0800, Xiubo Li wrote:
> > > On 2020/1/9 22:52, Jeff Layton wrote:
> > > > On Wed, 2020-01-08 at 05:41 -0500, xiubli@redhat.com wrote:
> > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > 
> > > > > This will fulfill the caps hit/miss metric for each session. When
> > > > > checking the "need" mask and if one cap has the subset of the "need"
> > > > > mask it means hit, or missed.
> > > > > 
> > > > > item          total           miss            hit
> > > > > -------------------------------------------------
> > > > > d_lease       295             0               993
> > > > > 
> > > > > session       caps            miss            hit
> > > > > -------------------------------------------------
> > > > > 0             295             107             4119
> > > > > 1             1               107             9
> > > > > 
> > > > > Fixes: https://tracker.ceph.com/issues/43215
> > > > For the record, "Fixes:" has a different meaning for kernel patches.
> > > > It's used to reference an earlier patch that introduced the bug that the
> > > > patch is fixing.
> > > > 
> > > > It's a pity that the ceph team decided to use that to reference tracker
> > > > tickets in their tree. For the kernel we usually use a generic "URL:"
> > > > tag for that.
> > > Sure, will fix it.
> > > 
> > > [...]
> > > > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > > > index 28ae0c134700..6ab02aab7d9c 100644
> > > > > --- a/fs/ceph/caps.c
> > > > > +++ b/fs/ceph/caps.c
> > > > > @@ -567,7 +567,7 @@ static void __cap_delay_cancel(struct ceph_mds_client *mdsc,
> > > > >    static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
> > > > >    			      unsigned issued)
> > > > >    {
> > > > > -	unsigned had = __ceph_caps_issued(ci, NULL);
> > > > > +	unsigned int had = __ceph_caps_issued(ci, NULL, -1);
> > > > >    
> > > > >    	/*
> > > > >    	 * Each time we receive FILE_CACHE anew, we increment
> > > > > @@ -787,20 +787,43 @@ static int __cap_is_valid(struct ceph_cap *cap)
> > > > >     * out, and may be invalidated in bulk if the client session times out
> > > > >     * and session->s_cap_gen is bumped.
> > > > >     */
> > > > > -int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented)
> > > > > +int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented, int mask)
> > > > This seems like the wrong approach. This function returns a set of caps,
> > > > so it seems like the callers ought to determine whether a miss or hit
> > > > occurred, and whether to record it.
> > > Currently this approach will count the hit/miss for each i_cap entity in
> > > ci->i_caps, for example, if a i_cap has a subset of the requested cap
> > > mask it means the i_cap hit, or the i_cap miss.
> > > 
> > > This approach will be like:
> > > 
> > > session       caps            miss            hit
> > > -------------------------------------------------
> > > 0             295             107             4119
> > > 1             1               107             9
> > > 
> > > The "caps" here is the total i_caps in all the ceph_inodes we have.
> > > 
> > > 
> > > Another approach is only when the ci->i_caps have all the requested cap
> > > mask, it means hit, or miss, this is what you meant as above.
> > > 
> > > This approach will be like:
> > > 
> > > session       inodes            miss            hit
> > > -------------------------------------------------
> > > 0             295             107             4119
> > > 1             1               107             9
> > > 
> > > The "inodes" here is the total ceph_inodes we have.
> > > 
> > > Which one will be better ?
> > > 
> > > 
> > I think I wasn't clear. My objection was to adding this "mask" field to
> > __ceph_caps_issued and having the counting logic in there. It would be
> > cleaner to have the callers do that instead. __ceph_caps_issued returns
> > the issued caps, so the callers have all of the information they need to
> > increment the proper counters without having to change
> > __ceph_caps_issued.
> 
> Do you mean if the (mask & issued == mask) the caller will increase 1 to 
> the hit counter, or increase 1 miss counter, right ?
> 
> For currently approach of this patch, when traversing the ceph_inode's 
> i_caps and if a i_cap has only a subset or all of the "mask" that means 
> hit, or miss.
> 
> This is why changing the __ceph_caps_issued().
> 

In this case, I'm specifically saying that you should move the hit and
miss counting into the _callers_ of __ceph_caps_issued().

That function is a piece of core infrastructure that returns the
currently issued caps. I think that it should not be changed to count
hits and misses, as the calling functions are in a better position to
make that determination and it needlessly complicates low-level code.

> > > > >    {
> > > [...]
> > > > >    
> > > > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > > > index 382beb04bacb..1e1ccae8953d 100644
> > > > > --- a/fs/ceph/dir.c
> > > > > +++ b/fs/ceph/dir.c
> > > > > @@ -30,7 +30,7 @@
> > > > >    const struct dentry_operations ceph_dentry_ops;
> > > > >    
> > > > >    static bool __dentry_lease_is_valid(struct ceph_dentry_info *di);
> > > > > -static int __dir_lease_try_check(const struct dentry *dentry);
> > > > > +static int __dir_lease_try_check(const struct dentry *dentry, bool metric);
> > > > >    
> > > > AFAICT, this function is only called when trimming dentries and in
> > > > d_delete. I don't think we care about measuring cache hits/misses for
> > > > either of those cases.
> > > Yeah, it is.
> > > 
> > > This will ignore the trimming dentries case, and will count from the
> > > d_delete.
> > > 
> > > This approach will only count the cap hit/miss called from VFS layer.
> > > 
> > Why do you need this "metric" parameter here? We _know_ that we won't be
> > counting hits and misses in this codepath, so it doesn't seem to serve
> > any useful purpose.
> > 
> We need to know where the caller comes from:
> 
> In Case1:  caller is vfs
> 
> This will count the hit/miss counters.
> 
> ceph_d_delete() --> __dir_lease_try_check(metric = true) --> 
> __ceph_caps_issued_mask(mask = XXX, metric = true)
> 

Why would you count hits/misses from the d_delete codepath? That isn't
generally driven by user activity, and it's just checking to see whether
we have a lease for the dentry (in which case we'll keep it around). I
don't think we should count the lease check here as it's basically
similar to trimming.

> 
> In Case2: caller is ceph.ko itself
> 
> This will ignore the hit/miss counters.
> 
> ceph_trim_dentries() --> __dentry_lease_check() --> 
> __dir_lease_try_check(metric = false) --> __ceph_caps_issued_mask(mask = 
> XXX, metric = false)

Right, so the caller (__dentry_lease_check()) just wouldn't count it in
this case.

In general, adding a boolean argument to a function like this is often a
sign that you're doing something wrong. You're almost always better off
doing this sort of thing in the caller, or making two different
functions that call the same underlying code.
-- 
Jeff Layton <jlayton@kernel.org>

