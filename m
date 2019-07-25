Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B3F74CB7
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 13:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391733AbfGYLRO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 07:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388479AbfGYLRO (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:17:14 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3A912238C;
        Thu, 25 Jul 2019 11:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564053433;
        bh=UjgdV+iZtZXoP1Wh/hwkrmprGRBM+Ym8MwREU0ea+Bw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Iq6v1mGajPpmCWXaC4qiIkH9S6Je1Fh2O5oLn05XPcDUt0gR1iTl0U/AAFpbmP11t
         uvIz6o7nvp3toYc0fOqJ/raKNQ/U6ocwbhyyvPfb8AV26EIzGhpZk+1t1cWLFzv3XD
         AzAoT90iobfO3v5aA+t4Y6I/ZLNOEmfpTG/XpT0g=
Message-ID: <fd396da29b62b83559d7489757a3871b7453e7fa.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: don't list vxattrs in listxattr()
From:   Jeff Layton <jlayton@kernel.org>
To:     David Disseldorp <ddiss@suse.com>,
        Luis Henriques <lhenriques@suse.com>
Cc:     ceph-devel@vger.kernel.org
Date:   Thu, 25 Jul 2019 07:17:11 -0400
In-Reply-To: <20190725115458.21e304c6@suse.com>
References: <20190724172026.23999-1-jlayton@kernel.org>
         <20190724172026.23999-1-jlayton@kernel.org> <87ftmu4fq3.fsf@suse.com>
         <20190725115458.21e304c6@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-07-25 at 11:54 +0200, David Disseldorp wrote:
> Hi,
> 
> On Thu, 25 Jul 2019 10:37:40 +0100, Luis Henriques wrote:
> 
> > Jeff Layton <jlayton@kernel.org> writes:
> > 
> > (CC'ing David)
> > 
> > > Most filesystems that provide virtual xattrs (e.g. CIFS) don't display
> > > them via listxattr(). Ceph does, and that causes some of the tests in
> > > xfstests to fail.
> > > 
> > > Have cephfs stop listing vxattrs in listxattr. Userspace can always
> > > query them directly when the name is known.  
> > 
> > I don't see a problem with this, unless we already have applications
> > relying on this behaviour.  The first thing that came to my mind was
> > samba, but I guess David can probably confirm whether this is true or
> > not.
> > 
> > If we're unable to stop listing there xattrs, the other option for
> > fixing the xfstests that _may_ be acceptable by the maintainers is to
> > use an output filter (lots of examples in common/filter).

Yeah, I rolled a half-assed xfstests patch that did this, and HCH gave
it a NAK. He's probably right though, and fixing it in ceph.ko is a
better approach I think.

> 
> Samba currently only makes use of the ceph.snap.btime vxattr. It doesn't
> depend on it appearing in the listxattr(), so removal would be fine. Not
> sure about other applications though.
> 
> Cheers, David

Ok, thanks guys. I'll go ahead and push this into the ceph/testing
branch and see if teuthology complains.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

