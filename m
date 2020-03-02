Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB2D175EB7
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Mar 2020 16:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgCBPvE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Mar 2020 10:51:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:34528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbgCBPvE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 10:51:04 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30D3E21556;
        Mon,  2 Mar 2020 15:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583164263;
        bh=oekm8FVEuC0Ctsj/eADaaYKbz0pjIujvkf20uN8bPtc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Qz7sE6iAYhWY+EVd8txtL/ClYdekp+bYdXhavG3wBgHtZXGeKezvI+lTjGBTRroUX
         Lke4Cb53U/GKfpT8LBL6JHK9O1we3KX3sJgqS7x8PwvKFRjG1XrGnldVbF+AXV/tiS
         R75YAHdaH/5B2o0HM5oi4cglXfsRUMG+Nfv4XJKg=
Message-ID: <0e0f4380d874a6b0a04322f47afbf6746dd36853.camel@kernel.org>
Subject: Re: unsafe list walking in __kick_flushing_caps?
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>
Cc:     Ilya Dryomov <idryomov@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Mon, 02 Mar 2020 10:51:02 -0500
In-Reply-To: <30fddf35-49ff-3009-f6a8-fd4ea6c65e05@redhat.com>
References: <4a4d32dc5c4a44cca4ed31bb66d9cfcb0b1092c7.camel@kernel.org>
         <30fddf35-49ff-3009-f6a8-fd4ea6c65e05@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2020-02-29 at 10:34 +0800, Yan, Zheng wrote:
> On 2/29/20 5:39 AM, Jeff Layton wrote:
> > Hi Zheng,
> > 
> > I've been going over the cap handling code, and noticed some sketchy
> > looking locking in __kick_flushing_caps that was added by this patch:
> > 
> > 
> > commit e4500b5e35c213e0f97be7cb69328c0877203a79
> > Author: Yan, Zheng <zyan@redhat.com>
> > Date:   Wed Jul 6 11:12:56 2016 +0800
> > 
> >      ceph: use list instead of rbtree to track cap flushes
> >      
> >      We don't have requirement of searching cap flush by TID. In most cases,
> >      we just need to know TID of the oldest cap flush. List is ideal for this
> >      usage.
> >      
> >      Signed-off-by: Yan, Zheng <zyan@redhat.com>
> > 
> > While walking ci->i_cap_flush_list, __kick_flushing_caps drops and
> > reacquires the i_ceph_lock on each iteration. It looks like
> > __kick_flushing_caps could (e.g.) race with a reply from the MDS that
> > removes the entry from the list. Is there something that prevents that
> > that I'm not seeing?
> > 
> 
> I think it's protected by s_mutex. I checked the code only
> ceph_kick_flushing_caps() is not protected by s_mutex. it should be 
> easy to fix.
> 

What does the i_ceph_lock actually protect here then? Does this mean
that this code doesn't actually need the i_ceph_lock?

That sounds ok as a possible stopgap fix, but longer term I'd really
like to see us reduce the coverage of the session and mdsc mutexes.
Maybe we can rework this code to queue up the cap flushes in some
fashion while holding the spinlock, and then send them off later once
we've released it?

Looking at ceph_kick_flushing_caps...

AFAICT, the s_cap_flushing list should be protected by mdsc-
>cap_dirty_lock, but it's not held while walking it in
ceph_kick_flushing_caps or ceph_early_kick_flushing_caps. There is some
effort to track certain tids in there, but it's not clear to me that
that is enough to protect from concurrent list manipulation. Does it
somehow?

-- 
Jeff Layton <jlayton@kernel.org>

