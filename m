Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C2B3CF950
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Jul 2021 14:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbhGTLYh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 20 Jul 2021 07:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237034AbhGTLYb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 20 Jul 2021 07:24:31 -0400
Received: from outbound3.mail.transip.nl (outbound3.mail.transip.nl [IPv6:2a01:7c8:7c9:ca11:136:144:136:12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960C1C061574
        for <ceph-devel@vger.kernel.org>; Tue, 20 Jul 2021 05:05:06 -0700 (PDT)
Received: from submission4.mail.transip.nl (unknown [10.103.8.155])
        by outbound3.mail.transip.nl (Postfix) with ESMTP id 4GTcpm56mvzsvyV;
        Tue, 20 Jul 2021 14:05:04 +0200 (CEST)
Received: from exchange.transipgroup.nl (unknown [81.4.116.210])
        by submission4.mail.transip.nl (Postfix) with ESMTPSA id 4GTcpl4YWRznTms;
        Tue, 20 Jul 2021 14:04:59 +0200 (CEST)
Received: from VM16171.groupdir.nl (10.131.120.71) by VM16171.groupdir.nl
 (10.131.120.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15; Tue, 20 Jul
 2021 14:04:58 +0200
Received: from VM16171.groupdir.nl ([81.4.116.210]) by VM16171.groupdir.nl
 ([81.4.116.210]) with mapi id 15.02.0792.015; Tue, 20 Jul 2021 14:04:58 +0200
From:   Robin Geuze <robin.geuze@nl.team.blue>
To:     Ilya Dryomov <idryomov@gmail.com>
CC:     Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: All RBD IO stuck after flapping OSD's
Thread-Topic: All RBD IO stuck after flapping OSD's
Thread-Index: AQHXMQs7yqmta0olA0ygBmx0d4s7EKq0G68AgAFka/SABi6BAIBbPDuXgAE5TYCAACJLAv//77AAgAArXHP//+1sAIAAIdhQgBKxTeH///dmAAFvNtGAACH5JqYClzo29Q==
Date:   Tue, 20 Jul 2021 12:04:58 +0000
Message-ID: <8b1a8409de3448699fe606c7c704f232@nl.team.blue>
References: <47f0a04ce6664116a11cfdb5a458e252@nl.team.blue>
 <CAOi1vP-moRXtL4gKXQF8+NwbPgE11_LoxfSYqYBbJfYYQ7Sv_g@mail.gmail.com>
 <8eb12c996e404870803e9a7c77e508d6@nl.team.blue>
 <CAOi1vP-8i-rKEDd8Emq+MtxCjvK-6VG8KaXdzvQLW89174jUZA@mail.gmail.com>
 <666938090a8746a7ad8ae40ebf116e1c@nl.team.blue>
 <CAOi1vP8NHYEN-=J4A7mB1dSkaHHf8Gtha-xqPLboZUS5u442hA@mail.gmail.com>
 <21c4b9e08c4d48d6b477fc61d1fccba3@nl.team.blue>
 <CAOi1vP_fJm5UzSnOmQDKsVHmv-4vebNZTDk7vqLs=bvnf3fwjw@mail.gmail.com>
 <a13af12ab314437bbbffcb23b0513722@nl.team.blue>
 <CAOi1vP8kiGNaNPw=by=TVfJEV1_X-BNYZuVpO_Kxx5xtf40_6w@mail.gmail.com>
 <391efdae70644b71844fe6fa3dceea13@nl.team.blue>
 <2d37c87eb42d4bc2a99184f6bffce8a2@nl.team.blue>
 <CAOi1vP-dT=1C2SqcMxAR1NWrcHUE1K-F6M1BpBWb7pVCDhS7Og@mail.gmail.com>,<CAOi1vP-5AuH0xuZrd2AWOqRgnzHnEToE-dMQp23iOpY-a+VyLA@mail.gmail.com>,<c5830118f2a24ff89b6fcf18e941a120@nl.team.blue>
In-Reply-To: <c5830118f2a24ff89b6fcf18e941a120@nl.team.blue>
Accept-Language: en-GB, nl-NL, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [81.4.116.242]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Scanned-By: ClueGetter at submission4.mail.transip.nl
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=transip-a; d=nl.team.blue; t=1626782704; h=from:subject:to:cc:
 references:in-reply-to:date:mime-version:content-type;
 bh=yiGNbG5XBb+eE3PXqbgfNwLyHvNuihG0oe8lQYJ8sPg=;
 b=Jt93LR4fdMosL4G+aVCU0/XAjPnjKECgEdJGRecn+MFJJ859QQp1JbdxS+C70zZwWpXazO
 igvDEgZYNTvYMrxXgRftui5CETCxvAN+Y9A3gbnTRjtCfJwNAPDzhLptKxXMv7B+NePyy5
 JTBHE5KKhd/dZsGnhrMnyXPFSpBHcGKu/sl90DiupbTjKp5km+A4oNVXOAwCfhw90wASXo
 Z2JbdIWQhpSePDtSipzQONGRoCtV4bwWMIi2z8SKjTBn1vbVJ0uc28MElZhjjQ+GSamNYb
 teYypQ+7q89PatC9u0+uOgxWRw8qHzOKmvRuoP8wWQnQc8LE8/FY7zek8PXcEA==
X-Report-Abuse-To: abuse@transip.nl
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hey Ilya,

Took a bit longer than expected, but we finally got around to testing the p=
atches. They seem to do the trick. We did have one stuck rbd dev, however a=
fter the 60 second hung task timeout expired that one also continued workin=
g. Great work. We ended up testing it on a the Ubuntu 20.04 hwe 5.8 based k=
ernel btw, not 5.4.

Regards,

Robin Geuze

From: Robin Geuze
Sent: 07 July 2021 09:35
To: Ilya Dryomov
Cc: Ceph Development
Subject: Re: All RBD IO stuck after flapping OSD's
=A0  =20
Hey Ilya,

Thanks so much for the patches, we are planning to test them either this af=
ternoon or tomorrow at the latest, I will let you know the results.

Regards,

Robin Geuze

From: Ilya Dryomov <idryomov@gmail.com>
Sent: 06 July 2021 19:21
To: Robin Geuze
Cc: Ceph Development
Subject: Re: All RBD IO stuck after flapping OSD's
=A0=A0=A0=20
On Tue, Jun 29, 2021 at 12:07 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Tue, Jun 29, 2021 at 10:39 AM Robin Geuze <robin.geuze@nl.team.blue> w=
rote:
> >
> > Hey Ilya,
> >
> > Do you have any idea on the cause of this bug yet? I tried to dig aroun=
d a bit myself in the source, but the logic around this locking is very com=
plex, so I couldn't figure out where the problem is.
>
> I do.=A0 The proper fix would indeed be large and not backportable but
> I have a workaround in mind that should be simple enough to backport
> all the way to 5.4.=A0 The trick is making sure that the workaround is
> fine from the exclusive lock protocol POV.
>
> I'll try to flesh it out by the end of this week and report back
> early next week.

Hi Robin,

I CCed you on the patches.=A0 They should apply to 5.4 cleanly.=A0 You
mentioned you have a build farm set up, please take them for a spin.

Thanks,

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Ilya
=A0=A0=A0     =
