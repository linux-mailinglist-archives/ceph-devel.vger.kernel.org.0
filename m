Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32D6D2FFA8
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2019 17:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbfE3PxK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 May 2019 11:53:10 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:47098 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3PxJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 May 2019 11:53:09 -0400
Received: by mail-lf1-f53.google.com with SMTP id l26so5402753lfh.13
        for <ceph-devel@vger.kernel.org>; Thu, 30 May 2019 08:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KvFPSsMV5sw79txU4j9wGOPbN2L43cTTp57O8xzTWJI=;
        b=fPQRHuoqjfHeFkyvITnT0jJ8lKQG79ZRhFXCQYq8ZlpL03G1AfGhYzxqPW0lcc7NBz
         tqrFnsqFBvgOL8VxmPDPmyGsdCB2pAR3wEE/YJAimZ04PdiExFu4dvCaYKrBE2YC0GxY
         PcsVjrefJD4YcT2ac45jcBJZXIP1KrZRCGY0CELYZBqT/kvRw9IQ9RswWcWmABcvFriE
         3VwbdB5ieht/pAcZAbGqMGykCIUBJYa2Lb+PZgepZT+mfx9lY3N38SmUbwnTZaacvmAc
         Hw3m/tp/91m0qu7idbbCte/cyyb90Bg2oL/n1hF65eYtO93KWoMNmcDqDtL/KLboZyZh
         X+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KvFPSsMV5sw79txU4j9wGOPbN2L43cTTp57O8xzTWJI=;
        b=qneRoHGKBD/BTn+ANbizWrMp+qX1MlmVaAG6BQfEK2HdJT2qAjFJNFIhCDkaw9eH5o
         s+uZvTLfiYsAjLvP2nGhibzLqGFXp/S7ASXXxNazARAcViJLZjrZ0v3Q5wNJGJxE3Q1B
         LQX62ZuIrfQdDIbwYFsjOfckg0u6ud93SMmiC8qNenQBeGUIelgUP/i4PHAXfHFNluQo
         mZS9KQGpxJgpPp7BO+YBLBfTJPYje+0gnDPDk70rhRF3Git3IIhuB2ooGBCoprb16Qr1
         tMGD/vO88HEA8a0usXurYStJMv36Uznj7CCMqszEjdQ8szu0juRaFRByQZ6Iycdat4uP
         EIKA==
X-Gm-Message-State: APjAAAW9Votf0Ocat12mACxf8BSxrMg5SmwS8YoXHX054E1Bf50KwP/7
        6jDNp6tmlZf/JuE8i5KQ2AFc30OJtDQzy2nKdh3iKdoxVMsN+w==
X-Google-Smtp-Source: APXvYqwDcEvKh+wm3uCIl2lEQNlr56c1bNHJQpkvejQlxtkCfHOgEyqFwmxhCSNgau03NY3sdmzINLTUDWJlHSu72sU=
X-Received: by 2002:a19:2948:: with SMTP id p69mr2519000lfp.160.1559231586732;
 Thu, 30 May 2019 08:53:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAE63xUOQPizvSWe4YL_2fiSJ5uYxMdOTz1nqL9QizNGxwyyWQQ@mail.gmail.com>
 <CAJ4mKGZ4bDcJ+TeBSRfcynpTXWjdwuXqo=t6fxmaynbJPC10HA@mail.gmail.com>
In-Reply-To: <CAJ4mKGZ4bDcJ+TeBSRfcynpTXWjdwuXqo=t6fxmaynbJPC10HA@mail.gmail.com>
From:   Ugis <ugis22@gmail.com>
Date:   Thu, 30 May 2019 18:52:55 +0300
Message-ID: <CAE63xUO0CFY0L0g_DLK7iRVXBNMXp3wBL_SMyo5OJ+efwcKO1g@mail.gmail.com>
Subject: Re: fully encrypted ceph
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks for hint about Nautilus messenger v2! Was not aware it is near ready=
.

I'm using Nautilus 14.2.1 - how exactly can I enable "secure mode"?
http://docs.ceph.com/docs/nautilus/rados/configuration/msgr2/#bind-configur=
ation-options
describes what it is but does not mention how to enable.

P.S. If I use dmcrypt for my OSDs I should backup keys. Is it enough
to backup monitors like described here(stop daemon + backup DB
folder)?
https://blog.widodh.nl/2014/03/safely-backing-up-your-ceph-monitors/

Would I be able to start cluster in case all mons are lost with such backup=
?

Ugis

tre=C5=A1d., 2019. g. 29. maijs, plkst. 21:39 =E2=80=94 lietot=C4=81js Greg=
ory Farnum
(<gfarnum@redhat.com>) rakst=C4=ABja:
>
> If you're running Nautilus you can enable the new messenger encryption
> option. That's marked experimental right now but has been stable in
> testing so that flag will be removed in the next point release or two.
>
> Not sure about setting up Ceph-volume with locally-stored keys; partly
> we just assume your monitors are "farther away" from the OSD drives so
> even if the keys are transmitted unencrypted that's more secure
> against practical attacks...
> -Greg
>
> On Wed, May 29, 2019 at 11:28 AM Ugis <ugis22@gmail.com> wrote:
> >
> > Hi,
> >
> > What are current options to set up fully encrypted ceph cluster(data
> > encrypted in transit & at rest)?
> >
> > From what I have gathered:
> > option: ceph OSDs with dmcrypt and keys stored in monitors - this
> > seems not secure because keys travel from monitors to OSDs unencrypted
> > by default.
> >
> > workarounds would be:
> > - best:to use OSDs on luks crypt devices and unlock luks locally but
> > somehow ceph-volume refuses to create OSD on /dev/mapper/..crypt
> > device - why that?
> > - not avaialable: to store OSD dmcrypt keys in TANG server and use
> > clevis to retrieve keys.
> > - viable but unconvenient: create VPN between osds and mons
> >
> > What could be other suggestions to set up fully encrypted ceph?
> >
> > Best regards,
> > Ugis
