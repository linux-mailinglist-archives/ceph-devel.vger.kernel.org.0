Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD9636D51
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 09:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfFFH07 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jun 2019 03:26:59 -0400
Received: from mail-it1-f179.google.com ([209.85.166.179]:55793 "EHLO
        mail-it1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFFH06 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 Jun 2019 03:26:58 -0400
Received: by mail-it1-f179.google.com with SMTP id i21so1639695ita.5
        for <ceph-devel@vger.kernel.org>; Thu, 06 Jun 2019 00:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JPyhmNFyrkq4eY97JM73u1LP9mPVjNxEJAZLZYTbzpw=;
        b=jzlNDD3jwTjvPHWwbwGThIyfjQkBulzD3lXDQcq3dL11vfNMZuF69L/R469LvsPuHy
         GLeyzf8Tii6mr9ET21ufGnLAQ4satUUbewMgncEmTWFSgdGhNzEzluAQ2/ZHKmbNASKp
         1/91qN/ZpUIoFPytcCsnw92zQdokRCSMNwpm6z7x6Q3TiQodk6vTXGen3lwh+3wzNt1n
         xmWTYroTgLGFQZaVi5D6Mhn1nDRTtUbE5KjP50aWkaxfJ5wFM60vURZKcxmzwiID3rDE
         R+vYVtF1zYbNxM1ECn7kOR5SZvfWT8BvSLiI0ZOIPbhZLd0cCpAT57ligTrT0QqT2nRS
         ZoBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JPyhmNFyrkq4eY97JM73u1LP9mPVjNxEJAZLZYTbzpw=;
        b=uVKESRBUMpgY0Tk74ILAoLjtYjAGJBdH2oFvof0/wq3KzXMFSuvbSv4SkiS4lD6yDu
         IFYiiKVbqlt4VAyg9LuTwa2z1emuBq7+LHBNLpUgs/j6DofRctJvvarVkh0QquViCVM4
         nDWy7u5boT0Ar9HEA80RS+K8nA8pnFEa0Ouq8xKP54ejGTwAMxxqLvkbcOivy7lNEjcI
         zyvvsD3lygrqQjNpJrtH5mZEM2q0D/WNAdLzoJC6dugI+Ebe3ztWZh8ZeqiCzFy950KH
         6sDsTm28AmM21lv1vWuj/9PKR8XulrktzkXmxjDSAX0vIOtVFGGe4FIs51WPgljNEY/x
         GiQQ==
X-Gm-Message-State: APjAAAUhc+AVU2V38+ahgckSldgNm7YIoQXz7R15De87xM8OTEuAsfvY
        XCp1zubhTZsme4rFodyOU2zdGjwvQpbfKnXtE0w=
X-Google-Smtp-Source: APXvYqz7xNZNm4fOT1T4AaQ8KwF6JwKPy+qNCkN1PSUUEZonMMFIAJ8VAsXjUe5L2x3uD+eqfQR6f8K/vPJXywLKzGo=
X-Received: by 2002:a02:cd82:: with SMTP id l2mr29744803jap.96.1559806017656;
 Thu, 06 Jun 2019 00:26:57 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1906051556500.987@piezo.novalocal> <ME1PR01MB070645B4EDCB63853433D02A81170@ME1PR01MB0706.ausprd01.prod.outlook.com>
In-Reply-To: <ME1PR01MB070645B4EDCB63853433D02A81170@ME1PR01MB0706.ausprd01.prod.outlook.com>
From:   Xiaoxi Chen <superdebuger@gmail.com>
Date:   Thu, 6 Jun 2019 15:26:46 +0800
Message-ID: <CAEYCsVLdWh_hGQN+LoTrX1=BOVJZ-ras+PTGgRJ0n1Z_3-P3dw@mail.gmail.com>
Subject: Re: [ceph-users] Changing the release cadence
To:     Linh Vu <vul@unimelb.edu.au>
Cc:     Sage Weil <sage@newdream.net>,
        "ceph-users@ceph.com" <ceph-users@ceph.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "dev@ceph.io" <dev@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We go with upstream release and mostly Nautilus now, probably the most
aggressive ones among serious production user (i.e tens of PB+ ),

I will vote for November for several reasons:

 1.   Q4 is holiday season and usually production rollout was blocked
, especially storage related change, which usually give team more time
to prepare/ testing/ LnP the new releases, as well as catch up with
new features.

 2.  Q4/Q1 is usually the planning season,  having the upstream
released and testing to know the readiness of new feature, will
greatly helps when planning the feature/offering of next year.

 3.  Users have whole year to migrate their
provision/monitoring/deployment/remediation system to new version, and
have enough time to fix and stable the surrounding system before next
holiday season.

Release in Feb or March will make the Q4 just in the middle of the
cycle, and lot of changes will land at last minutes(month),   in which
case, few things can be test and forecasted based on the state-of-art
in Q4.

-Xiaoxi

Linh Vu <vul@unimelb.edu.au> =E4=BA=8E2019=E5=B9=B46=E6=9C=886=E6=97=A5=E5=
=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=888:32=E5=86=99=E9=81=93=EF=BC=9A
>
> I think 12 months cycle is much better from the cluster operations perspe=
ctive. I also like March as a release month as well.
> ________________________________
> From: ceph-users <ceph-users-bounces@lists.ceph.com> on behalf of Sage We=
il <sage@newdream.net>
> Sent: Thursday, 6 June 2019 1:57 AM
> To: ceph-users@ceph.com; ceph-devel@vger.kernel.org; dev@ceph.io
> Subject: [ceph-users] Changing the release cadence
>
> Hi everyone,
>
> Since luminous, we have had the follow release cadence and policy:
>  - release every 9 months
>  - maintain backports for the last two releases
>  - enable upgrades to move either 1 or 2 releases heads
>    (e.g., luminous -> mimic or nautilus; mimic -> nautilus or octopus; ..=
.)
>
> This has mostly worked out well, except that the mimic release received
> less attention that we wanted due to the fact that multiple downstream
> Ceph products (from Red Has and SUSE) decided to based their next release
> on nautilus.  Even though upstream every release is an "LTS" release, as =
a
> practical matter mimic got less attention than luminous or nautilus.
>
> We've had several requests/proposals to shift to a 12 month cadence. This
> has several advantages:
>
>  - Stable/conservative clusters only have to be upgraded every 2 years
>    (instead of every 18 months)
>  - Yearly releases are more likely to intersect with downstream
>    distribution release (e.g., Debian).  In the past there have been
>    problems where the Ceph releases included in consecutive releases of a
>    distro weren't easily upgradeable.
>  - Vendors that make downstream Ceph distributions/products tend to
>    release yearly.  Aligning with those vendors means they are more likel=
y
>    to productize *every* Ceph release.  This will help make every Ceph
>    release an "LTS" release (not just in name but also in terms of
>    maintenance attention).
>
> So far the balance of opinion seems to favor a shift to a 12 month
> cycle[1], especially among developers, so it seems pretty likely we'll
> make that shift.  (If you do have strong concerns about such a move, now
> is the time to raise them.)
>
> That brings us to an important decision: what time of year should we
> release?  Once we pick the timing, we'll be releasing at that time *every
> year* for each release (barring another schedule shift, which we want to
> avoid), so let's choose carefully!
>
> A few options:
>
>  - November: If we release Octopus 9 months from the Nautilus release
>    (planned for Feb, released in Mar) then we'd target this November.  We
>    could shift to a 12 months candence after that.
>  - February: That's 12 months from the Nautilus target.
>  - March: That's 12 months from when Nautilus was *actually* released.
>
> November is nice in the sense that we'd wrap things up before the
> holidays.  It's less good in that users may not be inclined to install th=
e
> new release when many developers will be less available in December.
>
> February kind of sucked in that the scramble to get the last few things
> done happened during the holidays.  OTOH, we should be doing what we can
> to avoid such scrambles, so that might not be something we should factor
> in.  March may be a bit more balanced, with a solid 3 months before when
> people are productive, and 3 months after before they disappear on holida=
y
> to address any post-release issues.
>
> People tend to be somewhat less available over the summer months due to
> holidays etc, so an early or late summer release might also be less than
> ideal.
>
> Thoughts?  If we can narrow it down to a few options maybe we could do a
> poll to gauge user preferences.
>
> Thanks!
> sage
>
>
> [1] https://protect-au.mimecast.com/s/N1l6CROAEns1RN1Zu9Jwts?domain=3Dtwi=
tter.com
>
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
>
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
