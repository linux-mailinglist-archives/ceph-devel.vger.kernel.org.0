Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9BE9FC05E
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 07:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbfKNGyB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 01:54:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29424 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725838AbfKNGyB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 14 Nov 2019 01:54:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573714439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xsWbKdIChZWr+5bzkND3NrxgB3rhqXcgO/mpILiuT+Q=;
        b=R3MDP9SsycM1BrfI+JY7rXVsSR/65a23Ru42lBH5XM4NxlinJY+Wut6cQu6avSnhG/UPVq
        gyxE58xjetZw0A7jHNRe0zBDL9BJYAUlAI1U9ieyG/S5OaTqDZsxw/0yr2sw3lhYb48HmQ
        g8NAQ76SGuksBHH1urGGxbOupXJtFDs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-ukZA4_mMNL-btjpvJdWtnQ-1; Thu, 14 Nov 2019 01:53:57 -0500
Received: by mail-ed1-f72.google.com with SMTP id v4so3426558edq.22
        for <ceph-devel@vger.kernel.org>; Wed, 13 Nov 2019 22:53:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=669m1A8kDmElHyrk5E+W7i7Sd0Tm5niH9TfU8Unm5h0=;
        b=rBhPCIfsHlF7YjFDd31+psSZJZAP736MEIuYyLpvHOsONLN3BCumjXg3kuPI+smWcF
         oUe+E52Ka5gE0urromFP9bvzZyeBBEoLAPPjJnu/XDv4RVbqhttJStQIDPm3vbbGS94q
         MRLQqQspPQX6iZ59GuqHj9w/M1TTwuTro5J6DhiKSTzQXCA+M/Zt18locKHGnGiBItEd
         tJHiCEbWvaaIwC77EqS96XO1cZSu6X3alDPn1Vfkn4Kzn4GsWofnp9WxEFJGQ3mwpPG4
         WjpkkaFnRl5EjX9jnVmcVM1nmIMQ9xQjEHz3q4v64eL0FgRLZMtuL3DuEMk/pyJKqqOe
         A19Q==
X-Gm-Message-State: APjAAAWUTSua//JzOlHdAqWJNf25xuBzMmuFMJ8VMYlL00BWJg9y17QT
        hR4LgRCHeuexofAmK1wQRTYCIfuhjW2czI4wexR2BmnBteFpETzp/P6GPhWZaoaYdTPkJaOIBUR
        OQFUbv+4foWLWiQsxrVc/oKjHKZmUdMB6GRrQhw==
X-Received: by 2002:a17:906:e0d5:: with SMTP id gl21mr6712173ejb.292.1573714435922;
        Wed, 13 Nov 2019 22:53:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqxK/93m6lFt+yWXz2rwh5Sg+76Hs37PC3vnxIS56cHR7JfcLjYWuH6CJbyovB2nMwBy5cSn5m/8ILyXkGp26v8=
X-Received: by 2002:a17:906:e0d5:: with SMTP id gl21mr6712159ejb.292.1573714435649;
 Wed, 13 Nov 2019 22:53:55 -0800 (PST)
MIME-Version: 1.0
References: <CAF-wwdHoUAEqJ7_ep+uDtnqsVDfaNdKQ2XM8T_+a=70mFd=80Q@mail.gmail.com>
 <CACBud-DDEsbR16BEwHgsvK_z=paXggjgAqGCUT_yryiNN8Cb9A@mail.gmail.com>
 <CAF-wwdEEf=MCPTOthKeT8-raUFtN6u1SBi3VrNDi2kmFanSrbA@mail.gmail.com>
 <CACBud-C8La_eZ+Ta0PpLfM14xkOEGtH4H9k1gZozzbticpGMnA@mail.gmail.com> <CAF-wwdEd5-E+bS4+wB9dMaG6SKiJg2RCiuBW+vR7XxUq6PS_rA@mail.gmail.com>
In-Reply-To: <CAF-wwdEd5-E+bS4+wB9dMaG6SKiJg2RCiuBW+vR7XxUq6PS_rA@mail.gmail.com>
From:   Yuval Lifshitz <ylifshit@redhat.com>
Date:   Thu, 14 Nov 2019 08:53:44 +0200
Message-ID: <CACBud-BbeauQsGfVTWGmyJN2suzj+huDTJ7hS06_ogA+KCO8nw@mail.gmail.com>
Subject: Re: Static Analysis
To:     Brad Hubbard <bhubbard@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
X-MC-Unique: ukZA4_mMNL-btjpvJdWtnQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Yes, I agree. Especially that, at least ion fedora, iwyu should be
built from source.

On Thu, Nov 14, 2019 at 12:24 AM Brad Hubbard <bhubbard@redhat.com> wrote:
>
> On Wed, Nov 13, 2019 at 5:04 AM Yuval Lifshitz <ylifshit@redhat.com> wrot=
e:
> >
> > Hi Brad,
>
> Hi Yuval,
>
> > Thanks for providing the script! I added 2 of the targets to the cmake
> > system in this PR [1].
> > Still working on scan-build.
> > As a side note, on Fedora30, the iwyu version is pretty old, and
> > create many false positives, I had to build and install from source.
>
> I don't think adding additional dependencies to ceph for this is a
> good idea. If we are to implement this, given this is strictly for
> developers, I would suggest we make satisfying the dependencies for
> these cmake options a manual process and avoid pulling in more
> dependencies. What do you think?
>
> >
> > Yuval
> >
> > [1] https://github.com/ceph/ceph/pull/31579
> >
> > On Fri, Oct 11, 2019 at 8:45 AM Brad Hubbard <bhubbard@redhat.com> wrot=
e:
> > >
> > > On Thu, Oct 10, 2019 at 3:41 PM Yuval Lifshitz <ylifshit@redhat.com> =
wrote:
> > > >
> > > > This is awesome!
> > >
> > > First thing to note is these scans each take a long time to run.
> > >
> > > > How difficult would it be to add these as cmake targets?
> > >
> > > With Coverity, currently impossible since the only version I can find
> > > that works is not publicly available.
> > >
> > > As for the others I use the following script to run them so it
> > > wouldn't be that hard I guess. There's some changes in there at the
> > > moment to try and get them to only scan 'ceph code' (not submodule
> > > code) but that seems to be confusing scan-build as it currently
> > > produces zero results. I have some work to do there and there seems t=
o
> > > be a lot of maintenance work around these scans. I'm not sure how muc=
h
> > > bang for our buck we would get by adding any of them as cmake targets=
.
> > >
> > > >
> > > > On Thu, Oct 10, 2019 at 8:18 AM Brad Hubbard <bhubbard@redhat.com> =
wrote:
> > > >>
> > > >> Latest static analyser results are up on  http://people.redhat.com=
/bhubbard/
> > > >>
> > > >> Weekly Fedora Copr builds are at
> > > >> https://copr.fedorainfracloud.org/coprs/badone/ceph-weeklies/
> > > >>
> > > >>
> > > >> --
> > > >> Cheers,
> > > >> Brad
> > > >> _______________________________________________
> > > >> Dev mailing list -- dev@ceph.io
> > > >> To unsubscribe send an email to dev-leave@ceph.io
> > >
> > >
> > >
> > > --
> > > Cheers,
> > > Brad
> >
>
>
> --
> Cheers,
> Brad
>

