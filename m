Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A694CF994E
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Nov 2019 20:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfKLTEa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 12 Nov 2019 14:04:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28922 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726952AbfKLTEa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 12 Nov 2019 14:04:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573585468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZqAdwwBMZhWesJFdk6pohyBYncAw2f0uT/Eqbd6yeHk=;
        b=ZqbgHI7pkTJt25lUvfjTjYBXGQ+x2/IpGnGdqXuh66rP6pk2Xxzx+VwfUJxgLTnECR/T6T
        7W+bdgoVLjHY4HrsN0rR+MxSGZQtZRUvi64lTv+2S/Z3IFq92B3NnBEtKNZp2Ez+OHKLqM
        EPikNcV2rvmsoKyYB4EjnuRJ00fBY0c=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-BSZnx_RbNVC88syqCFo0_Q-1; Tue, 12 Nov 2019 14:04:24 -0500
Received: by mail-ed1-f71.google.com with SMTP id c11so13208167edv.23
        for <ceph-devel@vger.kernel.org>; Tue, 12 Nov 2019 11:04:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WFL728WL3uEBotwgy2MFt4XZiwe2kkXUL5f0hYpWao0=;
        b=YmsG1JsXSXGu5DQwYnYCCgqQyTIVl4kiWpwgXsjuep3Xmwy8yzOGeyp/LyxBFEXApS
         0cfep/1s9mvfpOy7qj9Fou5H4P2f5rnSu42sHSB74HdUAMIBACKI5PTUXSR2cNG0GOY3
         vn3jp/L1fPI5qLUKsg1EqPdlqiYmVTOEee3T8AMtMsXevuNXII9Ea4kUqRHVThitFwdH
         hyDxoK7Ctlkky7+4HQ3oLSIF30faAzRwEeDV7MJXHoo0XK1s6ofJ4rPAC8M5StufbDQn
         tRe4mwUgFF4PSEYIh9ybXolvKern2hjqHUnaDQYybjJMXg2shoe0dHNxifjxdOwtPaxc
         gmag==
X-Gm-Message-State: APjAAAVDytSs+8XVCQYYqjlNqzE+kFPQdlU9eZPHXg9gpMhlfUyfBKou
        17sisWzHQ0mvTeW+q8jyK9BwAR5GiEPtxT6zB6i00asaj2kgOmFilyXIWQsaN7wfgH2h/jLc/6T
        hnjTxRi1WGDyMqHPwsqWtk7Q8DIUfDLKWAKTibw==
X-Received: by 2002:a17:906:d0d2:: with SMTP id bq18mr12799159ejb.217.1573585463385;
        Tue, 12 Nov 2019 11:04:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqxEaam/GGigXnQw7DA5s8+L9AWtb25d2V2N0n0c1sNvMxu/PohiCuFz+NgiXeTyyYOPacU1etVtwat4xMBItJ0=
X-Received: by 2002:a17:906:d0d2:: with SMTP id bq18mr12799129ejb.217.1573585463107;
 Tue, 12 Nov 2019 11:04:23 -0800 (PST)
MIME-Version: 1.0
References: <CAF-wwdHoUAEqJ7_ep+uDtnqsVDfaNdKQ2XM8T_+a=70mFd=80Q@mail.gmail.com>
 <CACBud-DDEsbR16BEwHgsvK_z=paXggjgAqGCUT_yryiNN8Cb9A@mail.gmail.com> <CAF-wwdEEf=MCPTOthKeT8-raUFtN6u1SBi3VrNDi2kmFanSrbA@mail.gmail.com>
In-Reply-To: <CAF-wwdEEf=MCPTOthKeT8-raUFtN6u1SBi3VrNDi2kmFanSrbA@mail.gmail.com>
From:   Yuval Lifshitz <ylifshit@redhat.com>
Date:   Tue, 12 Nov 2019 21:04:12 +0200
Message-ID: <CACBud-C8La_eZ+Ta0PpLfM14xkOEGtH4H9k1gZozzbticpGMnA@mail.gmail.com>
Subject: Re: Static Analysis
To:     Brad Hubbard <bhubbard@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
X-MC-Unique: BSZnx_RbNVC88syqCFo0_Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Brad,
Thanks for providing the script! I added 2 of the targets to the cmake
system in this PR [1].
Still working on scan-build.
As a side note, on Fedora30, the iwyu version is pretty old, and
create many false positives, I had to build and install from source.

Yuval

[1] https://github.com/ceph/ceph/pull/31579

On Fri, Oct 11, 2019 at 8:45 AM Brad Hubbard <bhubbard@redhat.com> wrote:
>
> On Thu, Oct 10, 2019 at 3:41 PM Yuval Lifshitz <ylifshit@redhat.com> wrot=
e:
> >
> > This is awesome!
>
> First thing to note is these scans each take a long time to run.
>
> > How difficult would it be to add these as cmake targets?
>
> With Coverity, currently impossible since the only version I can find
> that works is not publicly available.
>
> As for the others I use the following script to run them so it
> wouldn't be that hard I guess. There's some changes in there at the
> moment to try and get them to only scan 'ceph code' (not submodule
> code) but that seems to be confusing scan-build as it currently
> produces zero results. I have some work to do there and there seems to
> be a lot of maintenance work around these scans. I'm not sure how much
> bang for our buck we would get by adding any of them as cmake targets.
>
> >
> > On Thu, Oct 10, 2019 at 8:18 AM Brad Hubbard <bhubbard@redhat.com> wrot=
e:
> >>
> >> Latest static analyser results are up on  http://people.redhat.com/bhu=
bbard/
> >>
> >> Weekly Fedora Copr builds are at
> >> https://copr.fedorainfracloud.org/coprs/badone/ceph-weeklies/
> >>
> >>
> >> --
> >> Cheers,
> >> Brad
> >> _______________________________________________
> >> Dev mailing list -- dev@ceph.io
> >> To unsubscribe send an email to dev-leave@ceph.io
>
>
>
> --
> Cheers,
> Brad

