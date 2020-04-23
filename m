Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CB51B59F2
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Apr 2020 13:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgDWLEv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Apr 2020 07:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbgDWLEv (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 Apr 2020 07:04:51 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 399AE20787;
        Thu, 23 Apr 2020 11:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587639890;
        bh=VFuqTtF0WU7F5qqWsxqZw4JTy8mZQeA340SFeltQ9uc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=0G0CSDTl9HPtPyOr7GhlqPqpar02CBKx02VSk5GT5WCak0MzVbc5Qiu0IK3lM8p2o
         6f3RDCiTn0vLnv/Lo0BgfnIgyE8RSFP2v771zOVizdy3QCglqjGrI3AVdhbxDz1MeC
         klLhP/Y0pGjyVwwBevOWgpO21BwvD497jv8wdIbY=
Message-ID: <aea3e7e828adb60478a67692d749d2054fe56cf6.camel@kernel.org>
Subject: Re: [v3] ceph: if we are blacklisted, __do_request returns directly
From:   Jeff Layton <jlayton@kernel.org>
To:     Yanhu Cao <gmayyyha@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Thu, 23 Apr 2020 07:04:17 -0400
In-Reply-To: <CAB9OAC3fqvm9oigQour-jYuaSoh9Ny6Botk9Ls+ie-uKap19AQ@mail.gmail.com>
References: <20200417110723.12235-1-gmayyyha@gmail.com>
         <ad6ca41f601d4feb2c3bd2850aeab95c3187bf2d.camel@kernel.org>
         <CAB9OAC1+E6Qs=hr0naT73MNQ5scKOck4vF2gzsCS=0fQMLvG8A@mail.gmail.com>
         <86562f7eca48dd13a6cbafa4c6465d3a731fab88.camel@kernel.org>
         <CAB9OAC3fqvm9oigQour-jYuaSoh9Ny6Botk9Ls+ie-uKap19AQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-04-21 at 20:21 +0800, Yanhu Cao wrote:
> On Tue, Apr 21, 2020 at 6:15 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Tue, 2020-04-21 at 10:13 +0800, Yanhu Cao wrote:
> > > On Mon, Apr 20, 2020 at 8:16 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > On Fri, 2020-04-17 at 19:07 +0800, Yanhu Cao wrote:
> > > > > If we mount cephfs by the recover_session option,
> > > > > __do_request can return directly until the client automatically reconnects.
> > > > > 
> > > > > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > > > > ---
> > > > >  fs/ceph/mds_client.c | 6 ++++++
> > > > >  1 file changed, 6 insertions(+)
> > > > > 
> > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > > index 486f91f9685b..16ac5e5f7f79 100644
> > > > > --- a/fs/ceph/mds_client.c
> > > > > +++ b/fs/ceph/mds_client.c
> > > > > @@ -2708,6 +2708,12 @@ static void __do_request(struct ceph_mds_client *mdsc,
> > > > > 
> > > > >       put_request_session(req);
> > > > > 
> > > > > +     if (mdsc->fsc->blacklisted &&
> > > > > +         ceph_test_mount_opt(mdsc->fsc, CLEANRECOVER)) {
> > > > > +             err = -EBLACKLISTED;
> > > > > +             goto finish;
> > > > > +     }
> > > > > +
> > > > 
> > > > Why check for CLEANRECOVER? If we're mounted with recover_session=no
> > > > wouldn't we want to do the same thing here?
> > > > 
> > > > Either way, it's still blacklisted. The only difference is that it won't
> > > > attempt to automatically recover the session that way.
> > > 
> > > I think mds will clear the blacklist. In addition to loading cephfs
> > > via recover_session=clean, I didn't find a location where
> > > fsc->blacklisted is set to false. If the client has been blacklisted,
> > > should it always be blacklisted (fsc->blacklisted=true)? Or is there
> > > another way to set fsc->blacklised to false?
> > > 
> > 
> > Basically, this patch is just changing it so that when the client is
> > blacklisted and the mount is done with recover_session=clean, we'll
> > shortcut the rest of the __do_request and just return -EBLACKLISTED.
> > 
> > My question is: why do we need to test for recover_session=clean here?
> 
> I thought that fsc->blacklisted is related to recovery_session=clean.
> If we test it, the client can do the rest of __do_request. It seems
> useless now because kcephfs cannot resume the session like ceph-fuse
> when mds cleared the blacklist.
> 

fsc->blacklisted just indicates that the client has detected that it has
been blacklisted. With recover_session=clean it can reconnect and
continue on (with some limitations). See:

    https://ceph.io/community/automatic-cephfs-recovery-after-blacklisting/

> > If the client _knows_ that it is blacklisted, why would it want to
> > continue with __do_request in the recover_session=no case? Would it make
> > more sense to always return early in __do_request when the client is
> > blacklisted?
> 
> Makes sense. if there is no problem. I will patch the next commit and
> return -EBLACKLISTED only when fsc->blacklisted=true.
> 

Sure. To be clear, I don't see this as a bug, but rather just an
optimization. If the client is blacklisted then we don't really need to
do all of the work or attempt to send the request until that's been
cleared. That's the case regardless of the recover_session= option.

> > 
> > > > >       mds = __choose_mds(mdsc, req, &random);
> > > > >       if (mds < 0 ||
> > > > >           ceph_mdsmap_get_state(mdsc->mdsmap, mds) < CEPH_MDS_STATE_ACTIVE) {
> > > > --
> > > > Jeff Layton <jlayton@kernel.org>
> > > > 
> > 
> > --
> > Jeff Layton <jlayton@kernel.org>
> > 

-- 
Jeff Layton <jlayton@kernel.org>

