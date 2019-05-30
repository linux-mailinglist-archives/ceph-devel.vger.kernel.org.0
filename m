Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A870303B9
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2019 23:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfE3VCV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Thu, 30 May 2019 17:02:21 -0400
Received: from mail-it1-f172.google.com ([209.85.166.172]:36677 "EHLO
        mail-it1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfE3VCV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 May 2019 17:02:21 -0400
Received: by mail-it1-f172.google.com with SMTP id e184so11764099ite.1
        for <ceph-devel@vger.kernel.org>; Thu, 30 May 2019 14:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=El3ozkWJrXMRy4Rmb5iAZURr4e0TH1fE332NzKhIKSg=;
        b=RF3hzr27McEbH9q5VOloCQ3ChnKwl1UqCLdTJCTLZ9quF4CguTN6XSNeEaWF7Z3Tlg
         wCtkgyYHZtbwhUMeLEYP/H9B5rRq6sg0shuc7+trY0wSK6i6FdVw5K+WnPC8N8byabSd
         f2MtOhpGTF9cW+TBf3YcvLg88w5uDKpT50uKLoq2boqge2zRSSXggnfy5xEURrYiKDhv
         HNJp/Ma9F/9yjCO8kUrOHLqb9715MHaUKCPSkezNPMKh/QRkjNfivrs25QVjs4B7CV6y
         TRjuFzr+JyxP/L1GoGWoqopibN9Z884S4XCugTN9jkCyGjKvIA/fGf1BB0hI8/OH1MJa
         Hlqg==
X-Gm-Message-State: APjAAAVdS8E4GStAe9OWKPfvqkzGUVdxmHqlTehvx6g8ZNrUuuH/1wxT
        tgikUlxluiK6AQ1aHFO3Ki8YaqWSpeVyENNdQBiE+Q==
X-Google-Smtp-Source: APXvYqzw5DT9+NDI99XO0YcLA55MOfcqCJ0B9QzX5UlJsHATPWXfb/FFU2BMpVXDJFXArvDyTv2N/OFPPBMxHXpR/vw=
X-Received: by 2002:a24:7345:: with SMTP id y66mr4331298itb.23.1559250140549;
 Thu, 30 May 2019 14:02:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAE63xUOQPizvSWe4YL_2fiSJ5uYxMdOTz1nqL9QizNGxwyyWQQ@mail.gmail.com>
 <CAJ4mKGZ4bDcJ+TeBSRfcynpTXWjdwuXqo=t6fxmaynbJPC10HA@mail.gmail.com> <CAE63xUO0CFY0L0g_DLK7iRVXBNMXp3wBL_SMyo5OJ+efwcKO1g@mail.gmail.com>
In-Reply-To: <CAE63xUO0CFY0L0g_DLK7iRVXBNMXp3wBL_SMyo5OJ+efwcKO1g@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Thu, 30 May 2019 14:01:39 -0700
Message-ID: <CAJ4mKGb2-4YYiJOTDAZCU9=QRXU+_e6X7MHN8tRxjWAsMxrQrA@mail.gmail.com>
Subject: Re: fully encrypted ceph
To:     Ugis <ugis22@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 30, 2019 at 8:53 AM Ugis <ugis22@gmail.com> wrote:
>
> Thanks for hint about Nautilus messenger v2! Was not aware it is near ready.
>
> I'm using Nautilus 14.2.1 - how exactly can I enable "secure mode"?
> http://docs.ceph.com/docs/nautilus/rados/configuration/msgr2/#bind-configuration-options
> describes what it is but does not mention how to enable.

The "Connection Modes" section right underneath there discusses the
options and values you can set.

>
> P.S. If I use dmcrypt for my OSDs I should backup keys. Is it enough
> to backup monitors like described here(stop daemon + backup DB
> folder)?
> https://blog.widodh.nl/2014/03/safely-backing-up-your-ceph-monitors/
>
> Would I be able to start cluster in case all mons are lost with such backup?

Not sure; I haven't played with this. If you lose all the monitors you
can reconstruct the Ceph data but I think with fully-encrypted OSDs
that would put you out of luck unless you had all the keys stored
somewhere else you could provide them from.
-Greg

>
> Ugis
>
> trešd., 2019. g. 29. maijs, plkst. 21:39 — lietotājs Gregory Farnum
> (<gfarnum@redhat.com>) rakstīja:
> >
> > If you're running Nautilus you can enable the new messenger encryption
> > option. That's marked experimental right now but has been stable in
> > testing so that flag will be removed in the next point release or two.
> >
> > Not sure about setting up Ceph-volume with locally-stored keys; partly
> > we just assume your monitors are "farther away" from the OSD drives so
> > even if the keys are transmitted unencrypted that's more secure
> > against practical attacks...
> > -Greg
> >
> > On Wed, May 29, 2019 at 11:28 AM Ugis <ugis22@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > What are current options to set up fully encrypted ceph cluster(data
> > > encrypted in transit & at rest)?
> > >
> > > From what I have gathered:
> > > option: ceph OSDs with dmcrypt and keys stored in monitors - this
> > > seems not secure because keys travel from monitors to OSDs unencrypted
> > > by default.
> > >
> > > workarounds would be:
> > > - best:to use OSDs on luks crypt devices and unlock luks locally but
> > > somehow ceph-volume refuses to create OSD on /dev/mapper/..crypt
> > > device - why that?
> > > - not avaialable: to store OSD dmcrypt keys in TANG server and use
> > > clevis to retrieve keys.
> > > - viable but unconvenient: create VPN between osds and mons
> > >
> > > What could be other suggestions to set up fully encrypted ceph?
> > >
> > > Best regards,
> > > Ugis
