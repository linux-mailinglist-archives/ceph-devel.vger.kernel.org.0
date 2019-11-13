Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 236B6FBB8C
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Nov 2019 23:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfKMWYT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Nov 2019 17:24:19 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27990 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726251AbfKMWYT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 17:24:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573683858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/C5epXmAfRQ4FxX9ib4Ovz42lhxnsXlglTMhzt6cOzM=;
        b=d0En5ApnmwW0a3TFZD5oAeKeeuWfOrTqZoKCX+K8zC+tZaHhKJNpLcyOnqKRs+mlGqnJ5D
        0cqd8pOlQI4IdeykC2uDOojCylwhMlvTixvQT0WZSBoaHqj71sjebzmKwfcyAzd9/Fnz35
        1C/XLaNOu0bSxO8pWVSkdOSqkTcSdw8=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-nA56biw_NJ2BYYlRrX3zig-1; Wed, 13 Nov 2019 17:24:16 -0500
Received: by mail-lj1-f198.google.com with SMTP id h16so508826ljk.20
        for <ceph-devel@vger.kernel.org>; Wed, 13 Nov 2019 14:24:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+L2wWKVQCIuf8rqH93MXETO6sJz74KC/WqB+DXbvcI8=;
        b=M9iqcsgvKUh0DSESsUbAwPDDaz8vY1OMAokKuK8Q4mGFIXoZcILBrQvHCZD8fzgEv0
         SCEG92f781nVWk272mna67XBshxQJaO+KOGePMfec0arFVjrJX9JodEDG1Nb5quFO90H
         JyaQsm4N6buw+m0BDPfkYKIZH7mUNEEhpJmScXsBztvJHvy2FgSneR9GqwIV+9T25fVn
         v7P73o0+YjVhQrpuFWOchWTjNrqeoGF4G9NO1sqR8gai2uRceIrM5k4PV4Xaf7MoL0wr
         g6AWZFk7kZOO31+Z08YF4IQJ1nlDPMCW0ytz6Dy/EnOrYKQfg3UheRHHeZQDyTxDFNrP
         78yA==
X-Gm-Message-State: APjAAAUyO1V09/XiUr6F8BccgJQot/OePFkFVoGU956yIIHdLPEVb/r5
        X2U1xr/kaM30xisrwqYnrXKauSL0Ala0kj/UhXGHqO7H/eD5gtmqwv0I6tWpaOW8Hz9VEK+AlUs
        TRwV8WyEMkhEPymvhBBEe9ACKc1f6KyJ3KIPLvw==
X-Received: by 2002:a2e:970a:: with SMTP id r10mr4349710lji.142.1573683855364;
        Wed, 13 Nov 2019 14:24:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqyOorhx8ahnFezRWnfTNaLmEgZsDkEzayUDvbBVLV1tWEPHkR1K62L1Af0tK4+6vEZ7/MSdoDt40WQXI3mtY+g=
X-Received: by 2002:a2e:970a:: with SMTP id r10mr4349698lji.142.1573683855143;
 Wed, 13 Nov 2019 14:24:15 -0800 (PST)
MIME-Version: 1.0
References: <CAF-wwdHoUAEqJ7_ep+uDtnqsVDfaNdKQ2XM8T_+a=70mFd=80Q@mail.gmail.com>
 <CACBud-DDEsbR16BEwHgsvK_z=paXggjgAqGCUT_yryiNN8Cb9A@mail.gmail.com>
 <CAF-wwdEEf=MCPTOthKeT8-raUFtN6u1SBi3VrNDi2kmFanSrbA@mail.gmail.com> <CACBud-C8La_eZ+Ta0PpLfM14xkOEGtH4H9k1gZozzbticpGMnA@mail.gmail.com>
In-Reply-To: <CACBud-C8La_eZ+Ta0PpLfM14xkOEGtH4H9k1gZozzbticpGMnA@mail.gmail.com>
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Thu, 14 Nov 2019 08:24:03 +1000
Message-ID: <CAF-wwdEd5-E+bS4+wB9dMaG6SKiJg2RCiuBW+vR7XxUq6PS_rA@mail.gmail.com>
Subject: Re: Static Analysis
To:     Yuval Lifshitz <ylifshit@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
X-MC-Unique: nA56biw_NJ2BYYlRrX3zig-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Nov 13, 2019 at 5:04 AM Yuval Lifshitz <ylifshit@redhat.com> wrote:
>
> Hi Brad,

Hi Yuval,

> Thanks for providing the script! I added 2 of the targets to the cmake
> system in this PR [1].
> Still working on scan-build.
> As a side note, on Fedora30, the iwyu version is pretty old, and
> create many false positives, I had to build and install from source.

I don't think adding additional dependencies to ceph for this is a
good idea. If we are to implement this, given this is strictly for
developers, I would suggest we make satisfying the dependencies for
these cmake options a manual process and avoid pulling in more
dependencies. What do you think?

>
> Yuval
>
> [1] https://github.com/ceph/ceph/pull/31579
>
> On Fri, Oct 11, 2019 at 8:45 AM Brad Hubbard <bhubbard@redhat.com> wrote:
> >
> > On Thu, Oct 10, 2019 at 3:41 PM Yuval Lifshitz <ylifshit@redhat.com> wr=
ote:
> > >
> > > This is awesome!
> >
> > First thing to note is these scans each take a long time to run.
> >
> > > How difficult would it be to add these as cmake targets?
> >
> > With Coverity, currently impossible since the only version I can find
> > that works is not publicly available.
> >
> > As for the others I use the following script to run them so it
> > wouldn't be that hard I guess. There's some changes in there at the
> > moment to try and get them to only scan 'ceph code' (not submodule
> > code) but that seems to be confusing scan-build as it currently
> > produces zero results. I have some work to do there and there seems to
> > be a lot of maintenance work around these scans. I'm not sure how much
> > bang for our buck we would get by adding any of them as cmake targets.
> >
> > >
> > > On Thu, Oct 10, 2019 at 8:18 AM Brad Hubbard <bhubbard@redhat.com> wr=
ote:
> > >>
> > >> Latest static analyser results are up on  http://people.redhat.com/b=
hubbard/
> > >>
> > >> Weekly Fedora Copr builds are at
> > >> https://copr.fedorainfracloud.org/coprs/badone/ceph-weeklies/
> > >>
> > >>
> > >> --
> > >> Cheers,
> > >> Brad
> > >> _______________________________________________
> > >> Dev mailing list -- dev@ceph.io
> > >> To unsubscribe send an email to dev-leave@ceph.io
> >
> >
> >
> > --
> > Cheers,
> > Brad
>


--=20
Cheers,
Brad

