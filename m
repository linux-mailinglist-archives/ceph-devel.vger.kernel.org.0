Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC222AF1B7
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 14:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgKKNJV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Nov 2020 08:09:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgKKNJU (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 08:09:20 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 675AE206CA;
        Wed, 11 Nov 2020 13:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605100159;
        bh=VJcev82zKCRdGrpvwj9QC3l37Na3mA3RLijOAEtUGyw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=1OqIhuPmnfMvfpKSwD5+Mk2FeXc9XjfTBFy06Q8DKxQQQEiK7G0Kyoe3lNu5H6L+o
         qePeChk8VzzdL8FHbsXPEa44pQNJNPT4+HcQxqO50f4FrArVxfQ8PqtTKgUh9VzF/t
         KLuRxt7QsndGHOAZzlkhor2mZRfKrBR/qvTui96E=
Message-ID: <05512d3c3bf95eb551ea8ae4982b180f8c4deb0d.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: guard against __ceph_remove_cap races
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Date:   Wed, 11 Nov 2020 08:09:17 -0500
In-Reply-To: <871rh0f8w3.fsf@suse.de>
References: <20191212173159.35013-1-jlayton@kernel.org>
         <CAAM7YAmquOg5ESMAMa5y0gGAR-UAivYF8m+nqrJNmK=SzG6+wA@mail.gmail.com>
         <64d5a16d920098122144e0df8e03df0cadfb2784.camel@kernel.org>
         <871rh0f8w3.fsf@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-11-11 at 11:08 +0000, Luis Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
> 
> > On Sat, 2019-12-14 at 10:46 +0800, Yan, Zheng wrote:
> > > On Fri, Dec 13, 2019 at 1:32 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > > I believe it's possible that we could end up with racing calls to
> > > > __ceph_remove_cap for the same cap. If that happens, the cap->ci
> > > > pointer will be zereoed out and we can hit a NULL pointer dereference.
> > > > 
> > > > Once we acquire the s_cap_lock, check for the ci pointer being NULL,
> > > > and just return without doing anything if it is.
> > > > 
> > > > URL: https://tracker.ceph.com/issues/43272
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/ceph/caps.c | 21 ++++++++++++++++-----
> > > >  1 file changed, 16 insertions(+), 5 deletions(-)
> > > > 
> > > > This is the only scenario that made sense to me in light of Ilya's
> > > > analysis on the tracker above. I could be off here though -- the locking
> > > > around this code is horrifically complex, and I could be missing what
> > > > should guard against this scenario.
> > > > 
> > > 
> > > I think the simpler fix is,  in trim_caps_cb, check if cap-ci is
> > > non-null before calling __ceph_remove_cap().  this should work because
> > > __ceph_remove_cap() is always called inside i_ceph_lock
> > > 
> > 
> > Is that sufficient though? The stack trace in the bug shows it being
> > called by ceph_trim_caps, but I think we could hit the same problem with
> > other __ceph_remove_cap callers, if they happen to race in at the right
> > time.
> 
> Sorry for resurrecting this old thread, but we just got a report with this
> issue on a kernel that includes commit d6e47819721a ("ceph: hold
> i_ceph_lock when removing caps for freeing inode").
> 
> Looking at the code, I believe Zheng's suggestion should work as I don't
> see any __ceph_remove_cap callers that don't hold the i_ceph_lock.  So,
> would something like the diff bellow be acceptable?
> 
> Cheers,

I'm still not convinced that's the correct fix.

Why would trim_caps_cb be subject to this race when other
__ceph_remove_cap callers are not? Maybe the right fix is to test for a
NULL cap->ci in __ceph_remove_cap and just return early if it is?

-- 
Jeff Layton <jlayton@kernel.org>

