Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F797F8190
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Nov 2019 21:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfKKUvY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 Nov 2019 15:51:24 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35619 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKUvY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 11 Nov 2019 15:51:24 -0500
Received: by mail-io1-f66.google.com with SMTP id x21so16146150iol.2;
        Mon, 11 Nov 2019 12:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B5hctI9CUIkowY+km5A5wQbF2v/7Tj6av1qpKeqwyrs=;
        b=GDfr7FzLA89ibKp/TteL4uMThinW3HdCRBPytMDcFym1rWJzwhvVn8wemgnWP0SW2V
         BQd7RLoT/DCWnUAELlCwfQMtbVU+HXUmVlFw4zyD3gb8vPal4x7qcnCoWwbSAoXYFUm0
         hY3DH8rYLUEcAcnfimeT9zFWS2YIDR7pTCakpIB7bfKfi2dYlm5fd7Vw/PceIbl/hodE
         bQd+Pva8d1Ygi2aMsM/lhnkY+atkDAQz/xcIxUJWaRH+eFFPT9eE5Hh51AFcIAniRZBz
         8A9UvuoEzEf9kVNyORsgqRRSAlV/WMVdMNMHUcLvsoYV3J2BpgSBaPsTes60ayoqjbGM
         EOJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B5hctI9CUIkowY+km5A5wQbF2v/7Tj6av1qpKeqwyrs=;
        b=Z6XStFVlt2KQrl5wq9Ev7LCUlsbWQLTE0RKeswnCratUyZEqqmJ7Ki/xGTd2Yf3BUH
         d8AI7V0N4CZSrbVxSlId5RU2t736pMYMKjlwgH8DoYJoInbkE2TBejhUOtzlq7s03LhR
         IBVN3o29GlJh/a6pZx/jLhw9Gc/eTfVTHWpDxwo8P+ntblb4X27fDAd8TauzYwgd/5C4
         MBZsNSpiymAYiOFKF2Ny1ubeDlh315XkeQrBiNKGzJBuMZbF8Gpg9gKUGCmFanMOIOK2
         WKBEQfqgLI61lQM6r0PCifGngwBRvCcVhwP9eof4Pl+Hu/0MQ4IjVJulrZmYq5UDErba
         Dm0A==
X-Gm-Message-State: APjAAAXXiMKoYKPA3KIckxBLH2IYjDDqcH00PUSyHr/1cj2EegukV4dZ
        NlGykppKMbNzkHCo5ExFyRYnNU/YsQ0i1VjTVBc=
X-Google-Smtp-Source: APXvYqx7TbCA0VMFIwZ7QPh43X0cxelSdVqxZJWzCtGp7jk1wFzD1Ax/6SGUznNEvTwl+kbMjT5A93iaS4dyH/ho21A=
X-Received: by 2002:a02:ac07:: with SMTP id a7mr2559123jao.39.1573505481508;
 Mon, 11 Nov 2019 12:51:21 -0800 (PST)
MIME-Version: 1.0
References: <20191108141555.31176-1-lhenriques@suse.com> <CAOi1vP-sVQKvpiPLoZ=9s7Hy=c2eQRocxSs1nPrXAUCbbZUZ-g@mail.gmail.com>
 <20191108164758.GA1760@hermes.olymp> <alpine.DEB.2.21.1911081656320.10553@piezo.novalocal>
 <20191108171616.GA2569@hermes.olymp> <alpine.DEB.2.21.1911081721120.28682@piezo.novalocal>
 <20191108173101.GA3300@hermes.olymp> <20191111163036.GA20513@hermes.olymp>
In-Reply-To: <20191111163036.GA20513@hermes.olymp>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 11 Nov 2019 21:51:47 +0100
Message-ID: <CAOi1vP-kFnu_mJaTERHbSjBxQRvfXhFWF=9_nCaaFbh7ACiVhg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] ceph: safely use 'copy-from' Op on Octopus OSDs
To:     Luis Henriques <lhenriques@suse.com>
Cc:     Sage Weil <sage@newdream.net>, Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Nov 11, 2019 at 5:30 PM Luis Henriques <lhenriques@suse.com> wrote:
>
> On Fri, Nov 08, 2019 at 05:31:01PM +0000, Luis Henriques wrote:
> <snip>
> > > - You'll need to add it for both OSDMap::Incremental and OSDMap
> > > - You'll need to make the encoding condition by updating the block like
> > > the one below from OSDMap::encode()
> > >
> > >     uint8_t v = 9;
> > >     if (!HAVE_FEATURE(features, SERVER_LUMINOUS)) {
> > >       v = 3;
> > >     } else if (!HAVE_FEATURE(features, SERVER_MIMIC)) {
> > >       v = 6;
> > >     } else if (!HAVE_FEATURE(features, SERVER_NAUTILUS)) {
> > >       v = 7;
> > >     }
> > >
> > > to include a SERVER_OCTOPUS case too.  Same goes for Incremental::encode()
> >
> > Awesome, thanks!  I'll give it a try, and test it with the appropriate
> > kernel client side changes to use this.
>
> Ok, I've got the patch bellow for the OSD code, which IIRC should do
> exactly what we want: duplicate the require_osd_release in the client
> side.
>
> Now, in order to quickly test this I've started adding flags to the
> CEPH_FEATURES_SUPPORTED_DEFAULT definition.  SERVER_MIMIC *seemed* to be
> Ok, but once I've added SERVER_NAUTILUS I've realized that we'll need to
> handle TYPE_MSGR2 address.  Which is a _big_ thing.  Is anyone already
> looking into adding support for msgr v2 to the kernel client?

It should be easy enough to hack around it for testing purposes.

I made some initial steps and hope to be able to dedicate the 5.6 cycle
to it.

Thanks,

                Ilya
