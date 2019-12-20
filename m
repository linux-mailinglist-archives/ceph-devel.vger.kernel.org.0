Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B79E11279CD
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Dec 2019 12:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfLTLJm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Dec 2019 06:09:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbfLTLJm (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 06:09:42 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D88724679;
        Fri, 20 Dec 2019 11:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576840182;
        bh=vvHPY3pQgzjd/CyNWEVNJUhV00/rVAPyO9rOg540sQ8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=1FI88q51E5ZdbeqBwuz3ZrNg5fvxp/c1zWRMirjACCCYZweNfrKYWv8TwzmcCixwD
         S/buaHovUEJ+qcm/R4+NX/t6a6q+57v9ras0Qc67gWLMfjGSNdswpk8jvWnjVuMa33
         oY8lyNEtywDokjfI9XQFy7WZi6ehVOjBpRd17dv8=
Message-ID: <fb235fdb3f49ceea1397e09cea992d9cdd833373.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: rename get_session and switch to use
 ceph_get_mds_session
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     Sage Weil <sage@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Fri, 20 Dec 2019 06:09:39 -0500
In-Reply-To: <CAOi1vP-idYF2K-ENT2o6sJko-0b+EzbLF70ipqp3m65uT+pXYw@mail.gmail.com>
References: <20191220004409.12793-1-xiubli@redhat.com>
         <CAOi1vP85em7ase08xywaOTfaxrsMq7Y9yeYcxcgKz8QH=oxOGQ@mail.gmail.com>
         <ca915587-290a-fb10-2fd6-8a5d5bbb4fc0@redhat.com>
         <CAOi1vP-idYF2K-ENT2o6sJko-0b+EzbLF70ipqp3m65uT+pXYw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2019-12-20 at 11:46 +0100, Ilya Dryomov wrote:
> On Fri, Dec 20, 2019 at 10:21 AM Xiubo Li <xiubli@redhat.com> wrote:
> > On 2019/12/20 17:11, Ilya Dryomov wrote:
> > > On Fri, Dec 20, 2019 at 1:44 AM <xiubli@redhat.com> wrote:
> > > > From: Xiubo Li <xiubli@redhat.com>
> > > > 
> > > > Just in case the session's refcount reach 0 and is releasing, and
> > > > if we get the session without checking it, we may encounter kernel
> > > > crash.
> > > > 
> > > > Rename get_session to ceph_get_mds_session and make it global.
> > > > 
> > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > ---
> > > > 
> > > > Changed in V3:
> > > > - Clean all the local commit and pull it and rebased again, it is based
> > > >    the following commit:
> > > > 
> > > >    commit 3a1deab1d5c1bb693c268cc9b717c69554c3ca5e
> > > >    Author: Xiubo Li <xiubli@redhat.com>
> > > >    Date:   Wed Dec 4 06:57:39 2019 -0500
> > > > 
> > > >        ceph: add possible_max_rank and make the code more readable
> > > Hi Xiubo,
> > > 
> > > The base is correct, but the patch still appears to have been
> > > corrupted, either by your email client or somewhere in transit.
> > 
> > Ah, I have no idea of this now, I was doing the following command to
> > post it:
> > 
> > # git send-email --smtp-server=... --to=...
> 
> Hrm, I've looked through my archives and the last non-mangled patch
> I see from you is "[PATCH RFC] libceph: remove the useless monc check"
> dated Oct 15.  If you are using the same send-email command as before
> and haven't changed anything on your end, it's probably one of the
> intermediate servers...
> 
> > And my git version is:
> > 
> > # git --version
> > git version 2.21.0
> > 
> > I attached it or should I post it again ?
> 
> You attached the old version ;)  It's not mangled, but it doesn't
> apply.
> 
> Jeff, are you getting Xiubo's patches intact?
> 

Yep. This patch applied just fine using git-am. Patch looks reasonable
to me -- I like guarding against a 0->1 transition on a refcount.  I'll
go ahead and push it to testing.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

