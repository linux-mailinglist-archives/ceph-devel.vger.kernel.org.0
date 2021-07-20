Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C1D3CFFBB
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Jul 2021 18:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhGTQDp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 20 Jul 2021 12:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhGTQDF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 20 Jul 2021 12:03:05 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99268C061766
        for <ceph-devel@vger.kernel.org>; Tue, 20 Jul 2021 09:43:26 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id v26so24676364iom.11
        for <ceph-devel@vger.kernel.org>; Tue, 20 Jul 2021 09:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ED5qQc25ISarOIZ2uUdJsrNkOL0b8KbbPDH32B3bJ7A=;
        b=JVllmSbJfpMAzoBK4KyFM+p2xQLlLOLIjnDFjJmlxDnwbPEYjDqiRv75t8LE+R8+GF
         fRuH0ENv6E2ngue6eKqtnhbnsPUlHU6LvR6cUmJsLLMtVF2VfitKEByRHmS5tydT9yP0
         DXW97xMjxBYUNvRyAC1bqfQ68x99zaUHfJEM8K32XjRVABHQEsxfTF0/VKdEeFqT4QSS
         Nqo+w94pssNsNeIGYfLtrOSKDNLRINwa2MMFqWCwhUW0KyNTCcUtJ038mGb0BX4BuQEq
         ORjSzirRXDvw0Qo90qhuy4Vq9ZU6tiRvVY2sLk1izw7/uSHbGBGytIchDLf4eQrnHW0I
         KuLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ED5qQc25ISarOIZ2uUdJsrNkOL0b8KbbPDH32B3bJ7A=;
        b=DhDzGPCtNkGRx9kK9Z2RIgMV+dtZ9OGdKo/3UUFIxB6PhV5K9H1vXhWmcLHnJdvqY5
         UPEErK9dOOvuC8p3DfNfIhyF0LtwIlPAoZpp/1hZMiDszK1hn9UssC/wJ1o+c3NAbMHP
         +FtmSvryke5dugtov4+7f2qLAyTtFiYns0vi3TiGD4DsB1l5IzkBl9yDONe3+ADu4pmN
         D6Yi1uRZjO+spT1xiX3hkaAfVBOWHcBa/AJOcSEParBw25iwRxqacY1hpv4zKfkhp7zP
         c4KtwFF6mzB1FGeb+CTkkB1LVZ0t43WFT/Dv0pbLUSluGaXBoKc/tGOd8ThRrTgy8dBE
         s2UA==
X-Gm-Message-State: AOAM533MHbWkyUlcvXO4B/P0/9ZEpFTfyjbCymU4VopU5xY9Y5F+Dc5h
        axKKXcD6uKtVAm7Js67jUNzvbLwDY9rutBvu86HJtigAKsofUw==
X-Google-Smtp-Source: ABdhPJwOx/EjtkfW29h9vlLPQx8yitGjjQ11VYLMmBFM111mKQasATDVNUPFpMvfMstmFfuGOQYPsbmDTXKLJ+2YZ8o=
X-Received: by 2002:a5d:984d:: with SMTP id p13mr19199171ios.182.1626799406057;
 Tue, 20 Jul 2021 09:43:26 -0700 (PDT)
MIME-Version: 1.0
References: <47f0a04ce6664116a11cfdb5a458e252@nl.team.blue>
 <CAOi1vP-moRXtL4gKXQF8+NwbPgE11_LoxfSYqYBbJfYYQ7Sv_g@mail.gmail.com>
 <8eb12c996e404870803e9a7c77e508d6@nl.team.blue> <CAOi1vP-8i-rKEDd8Emq+MtxCjvK-6VG8KaXdzvQLW89174jUZA@mail.gmail.com>
 <666938090a8746a7ad8ae40ebf116e1c@nl.team.blue> <CAOi1vP8NHYEN-=J4A7mB1dSkaHHf8Gtha-xqPLboZUS5u442hA@mail.gmail.com>
 <21c4b9e08c4d48d6b477fc61d1fccba3@nl.team.blue> <CAOi1vP_fJm5UzSnOmQDKsVHmv-4vebNZTDk7vqLs=bvnf3fwjw@mail.gmail.com>
 <a13af12ab314437bbbffcb23b0513722@nl.team.blue> <CAOi1vP8kiGNaNPw=by=TVfJEV1_X-BNYZuVpO_Kxx5xtf40_6w@mail.gmail.com>
 <391efdae70644b71844fe6fa3dceea13@nl.team.blue> <2d37c87eb42d4bc2a99184f6bffce8a2@nl.team.blue>
 <CAOi1vP-dT=1C2SqcMxAR1NWrcHUE1K-F6M1BpBWb7pVCDhS7Og@mail.gmail.com>
 <CAOi1vP-5AuH0xuZrd2AWOqRgnzHnEToE-dMQp23iOpY-a+VyLA@mail.gmail.com>
 <c5830118f2a24ff89b6fcf18e941a120@nl.team.blue> <8b1a8409de3448699fe606c7c704f232@nl.team.blue>
In-Reply-To: <8b1a8409de3448699fe606c7c704f232@nl.team.blue>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 20 Jul 2021 18:42:49 +0200
Message-ID: <CAOi1vP_Bf+TSTtoqSPNof_QW3i0JiYqcrTCdizitvxT+a3nWYg@mail.gmail.com>
Subject: Re: All RBD IO stuck after flapping OSD's
To:     Robin Geuze <robin.geuze@nl.team.blue>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jul 20, 2021 at 2:05 PM Robin Geuze <robin.geuze@nl.team.blue> wrot=
e:
>
> Hey Ilya,
>
> Took a bit longer than expected, but we finally got around to testing the=
 patches. They seem to do the trick. We did have one stuck rbd dev, however=
 after the 60 second hung task timeout expired that one also continued work=
ing. Great work. We ended up testing it on a the Ubuntu 20.04 hwe 5.8 based=
 kernel btw, not 5.4.

Hi Robin,

Thanks for testing!  I'll get these patches into 5.14-rc3 and have them
backported from there.

Thanks,

                Ilya
