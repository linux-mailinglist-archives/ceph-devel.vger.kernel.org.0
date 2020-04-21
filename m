Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B9F1B25D2
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 14:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgDUMVO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 08:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDUMVO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 08:21:14 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09620C061A10;
        Tue, 21 Apr 2020 05:21:14 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id f3so14804783ioj.1;
        Tue, 21 Apr 2020 05:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b/8T5wwR3PMa9N6liO9GWTkbu2dihCt9vjyDRvk3GS0=;
        b=OwiS7DXzmpdlF70BZr/fbVHJU1wK0azISAA6trEqB2ANs9Q3Z3xbbFGM2MKrRJdyeN
         TJgaL/VjwFm68yV9Hv+zWnBPyUKr9zPoyOYY6TtCgDXjzAI96EV0urqKCybqAFWYNfza
         KJ7M0NnC/jCT3MlFuqaCmdj6AbvQ/3g9wXhb2fDZkUhBs84Z69ad9NgJ83l5HYLGVYKw
         /gbmJKUmNwFWXAXoPEIb1IPDlObSQWeb8sR/MoWbDMa5pg9bS+sG4dksf0w4OcYb+vYP
         Qkg8dwZO7Onwi5RVkkGOnfvzGinfPwj8hX2E9dym7bMAngp3F5SlIfCby2Hj2L6CSRS6
         7YmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b/8T5wwR3PMa9N6liO9GWTkbu2dihCt9vjyDRvk3GS0=;
        b=h9TOg/xZOB7man/kEjE9HtkbD80M/hiu4xmkFecz2/OYteHWUUc4Nij8PSnx/gNkZK
         UIYI6fnc3rAgG86F1N5n1cwvOo5VZPgUE9uUELNtR49aSdQh7PTFpvoVPRl8wJ9BcxeA
         URAgYFQSaV6FpOCoRM5QIGcMc35ojPmuS4W8lwyEHkwkV7xsOMhEcIxDUuJZ/iZtcJAU
         PjzToq4tW8VGyduUF+SsdRbBU+neJwmPQZ4cjvq03IxSs5ygGxiSQvPKpj3xLnEY8jDp
         hd5mt/dHRzx/MPfezzOdOQCKq1gXOHL6M2WUdWHyZ4OSX4hsrEmO+OfQz8AD7cHnyJiE
         RB3w==
X-Gm-Message-State: AGi0Pubr04oWQq5GIw2s2LQacrzVGazxXZnNvmkLHTmphjrfPP/gcXSf
        7hrV6Qzf4ypz2QFnDa4mu5E92fSBmN6P+oC6nOk=
X-Google-Smtp-Source: APiQypLBR+NbFXdPwrJNEdcWqatZsLoK2hEM+WIkah3ebWp6bcdCdijoPDHZzCpRea9vlQzsJ615qcL+sdC9EW/9HdE=
X-Received: by 2002:a05:6638:44f:: with SMTP id r15mr20852899jap.84.1587471673454;
 Tue, 21 Apr 2020 05:21:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200417110723.12235-1-gmayyyha@gmail.com> <ad6ca41f601d4feb2c3bd2850aeab95c3187bf2d.camel@kernel.org>
 <CAB9OAC1+E6Qs=hr0naT73MNQ5scKOck4vF2gzsCS=0fQMLvG8A@mail.gmail.com> <86562f7eca48dd13a6cbafa4c6465d3a731fab88.camel@kernel.org>
In-Reply-To: <86562f7eca48dd13a6cbafa4c6465d3a731fab88.camel@kernel.org>
From:   Yanhu Cao <gmayyyha@gmail.com>
Date:   Tue, 21 Apr 2020 20:21:02 +0800
Message-ID: <CAB9OAC3fqvm9oigQour-jYuaSoh9Ny6Botk9Ls+ie-uKap19AQ@mail.gmail.com>
Subject: Re: [v3] ceph: if we are blacklisted, __do_request returns directly
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Apr 21, 2020 at 6:15 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2020-04-21 at 10:13 +0800, Yanhu Cao wrote:
> > On Mon, Apr 20, 2020 at 8:16 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > On Fri, 2020-04-17 at 19:07 +0800, Yanhu Cao wrote:
> > > > If we mount cephfs by the recover_session option,
> > > > __do_request can return directly until the client automatically reconnects.
> > > >
> > > > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > > > ---
> > > >  fs/ceph/mds_client.c | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > >
> > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > index 486f91f9685b..16ac5e5f7f79 100644
> > > > --- a/fs/ceph/mds_client.c
> > > > +++ b/fs/ceph/mds_client.c
> > > > @@ -2708,6 +2708,12 @@ static void __do_request(struct ceph_mds_client *mdsc,
> > > >
> > > >       put_request_session(req);
> > > >
> > > > +     if (mdsc->fsc->blacklisted &&
> > > > +         ceph_test_mount_opt(mdsc->fsc, CLEANRECOVER)) {
> > > > +             err = -EBLACKLISTED;
> > > > +             goto finish;
> > > > +     }
> > > > +
> > >
> > > Why check for CLEANRECOVER? If we're mounted with recover_session=no
> > > wouldn't we want to do the same thing here?
> > >
> > > Either way, it's still blacklisted. The only difference is that it won't
> > > attempt to automatically recover the session that way.
> >
> > I think mds will clear the blacklist. In addition to loading cephfs
> > via recover_session=clean, I didn't find a location where
> > fsc->blacklisted is set to false. If the client has been blacklisted,
> > should it always be blacklisted (fsc->blacklisted=true)? Or is there
> > another way to set fsc->blacklised to false?
> >
>
> Basically, this patch is just changing it so that when the client is
> blacklisted and the mount is done with recover_session=clean, we'll
> shortcut the rest of the __do_request and just return -EBLACKLISTED.
>
> My question is: why do we need to test for recover_session=clean here?

I thought that fsc->blacklisted is related to recovery_session=clean.
If we test it, the client can do the rest of __do_request. It seems
useless now because kcephfs cannot resume the session like ceph-fuse
when mds cleared the blacklist.

>
> If the client _knows_ that it is blacklisted, why would it want to
> continue with __do_request in the recover_session=no case? Would it make
> more sense to always return early in __do_request when the client is
> blacklisted?

Makes sense. if there is no problem. I will patch the next commit and
return -EBLACKLISTED only when fsc->blacklisted=true.

>
>
> > >
> > > >       mds = __choose_mds(mdsc, req, &random);
> > > >       if (mds < 0 ||
> > > >           ceph_mdsmap_get_state(mdsc->mdsmap, mds) < CEPH_MDS_STATE_ACTIVE) {
> > > --
> > > Jeff Layton <jlayton@kernel.org>
> > >
>
> --
> Jeff Layton <jlayton@kernel.org>
>
