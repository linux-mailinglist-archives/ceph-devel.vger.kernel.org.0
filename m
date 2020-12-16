Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3EC32DC532
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Dec 2020 18:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgLPRTM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Dec 2020 12:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbgLPRTM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Dec 2020 12:19:12 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B299C061794
        for <ceph-devel@vger.kernel.org>; Wed, 16 Dec 2020 09:18:32 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id v3so23271912ilo.5
        for <ceph-devel@vger.kernel.org>; Wed, 16 Dec 2020 09:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6tEttOeqprQ5p4CYkMHCFb1h++xjlj2EJF26bKxVQCI=;
        b=jEAmUJeUvAXKVBTTxNYPPUrgwzqOdQaXLWVqiy4fuC0cZneU4vrvRXpfjSQoFjlv6u
         djZmhZJL6DQJUxjoYBZVf67VZ+UftWky2jNxTMiiOYxD/4qB45CJsYkNVb6fbzgXzH/n
         +2ewkqOAaI/LUjT/CA96b8l4tnTCe/kbAzc1uJHLnfM4gH/U6yo2Gg/5AYJ1DNTaRP34
         3lA2TUpCoWzIIRQDNTFKsujJ83KOMPCW0RSsdSl7QOfSO73GgH79KlNk9HmJrWi/lFPA
         rmyXp4np2Flss8WsWgM1b51pva5ix4GoVpWS1E8ngJ8es0taK9WM+mhiUdoLMvyXtEuq
         tPTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6tEttOeqprQ5p4CYkMHCFb1h++xjlj2EJF26bKxVQCI=;
        b=snI2J6zXFCuQz+Fi32Mrp6wDmD+6LtBWSuJOX3yc0cRDRz3ewRcCb3LC6JL7f+J9ZY
         OLMSWeTNHC6UGHFR4BmKKKvxmIlSZaQwfdeYObbKbfnflZ0+FyH1Yu4YHTh/JdJa2otr
         GFGV25AV8irtkkiMVqTWJ62a7E2LJYFCNG8vI38s98/lh1Tr+8US2qUjS0ySCs+2bZdG
         Gj+Qn98y3GTZOXWOp+Y19FprXLti6vOSkB5rh5NLMr2Iqv/jzGfTNS827SBH+QTwEwpA
         UouKBhwAqHNc947Tw+vNkWZvgwJ0mAAYYr57feLxzUYHBcU5ZAiOGhljsHQGHxEkEML9
         yPCg==
X-Gm-Message-State: AOAM531DLXPPyWFbG+wwup+dtWvaCVP0yoFR9zfSz4Hi9qQ6ZdPykET4
        GoSXI0CXDvojIdOzh/Ih9W0/MVnwrx5+lYCL0RI=
X-Google-Smtp-Source: ABdhPJwB6ZfR0Hh7WPUYb2dlGk9j+dLcyzaotSP0g2osCyao7JuitEiNIfywzd38/fWUL/CZf+NXnL/v6Q3+/vUXgjY=
X-Received: by 2002:a92:8419:: with SMTP id l25mr46687110ild.100.1608139111188;
 Wed, 16 Dec 2020 09:18:31 -0800 (PST)
MIME-Version: 1.0
References: <CAOi1vP_gHLrNBe-pU9G+GmE+JF8g2SY7UqgGqzeW5sXXf1jAcQ@mail.gmail.com>
 <6a870de44a66a6163c8f9a1d7fa5da308b9f8b30.camel@kernel.org>
In-Reply-To: <6a870de44a66a6163c8f9a1d7fa5da308b9f8b30.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 16 Dec 2020 18:18:18 +0100
Message-ID: <CAOi1vP_L-+Z_XOLP81hCGg52R_oj_NTdiegZf=-6-EnZyyJv3w@mail.gmail.com>
Subject: Re: wip-msgr2
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Dec 16, 2020 at 4:31 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Mon, 2020-12-14 at 14:43 +0100, Ilya Dryomov wrote:
> > Hello,
> >
> > I've pushed wip-msgr2 and opened a dummy PR in ceph-client:
> >
> >   https://github.com/ceph/ceph-client/pull/22
> >
> > This set has been through a over a dozen krbd test suite runs with no
> > issues other than those with the test suite itself.  The diffstat is
> > rather big, so I didn't want to spam the list.  If someone wants it
> > posted, let me know.  Any comments are welcome!
> >
> >  drivers/block/rbd.c                |    8 +-
> >  fs/ceph/mds_client.c               |  106 +-
> >  fs/ceph/mdsmap.c                   |   21 +-
> >  include/linux/ceph/auth.h          |   68 +-
> >  include/linux/ceph/ceph_features.h |   11 +-
> >  include/linux/ceph/ceph_fs.h       |   11 +
> >  include/linux/ceph/decode.h        |    8 +
> >  include/linux/ceph/libceph.h       |   10 +-
> >  include/linux/ceph/mdsmap.h        |    2 +-
> >  include/linux/ceph/messenger.h     |  285 ++-
> >  include/linux/ceph/msgr.h          |   57 +-
> >  include/linux/ceph/osdmap.h        |    4 +-
> >  net/ceph/Kconfig                   |    3 +
> >  net/ceph/Makefile                  |    3 +-
> >  net/ceph/auth.c                    |  408 ++++-
> >  net/ceph/auth_none.c               |    5 +-
> >  net/ceph/auth_x.c                  |  298 +++-
> >  net/ceph/auth_x_protocol.h         |    3 +-
> >  net/ceph/ceph_common.c             |   63 +
> >  net/ceph/ceph_strings.c            |   28 +
> >  net/ceph/crypto.h                  |    3 +
> >  net/ceph/decode.c                  |  101 ++
> >  net/ceph/messenger.c               | 2252 +++++------------------
> >  net/ceph/messenger_v1.c            | 1506 ++++++++++++++++
> >  net/ceph/messenger_v2.c            | 3443 ++++++++++++++++++++++++++++=
++++
> >  net/ceph/mon_client.c              |  320 +++-
> >  net/ceph/osd_client.c              |  111 +-
> >  net/ceph/osdmap.c                  |   45 +-
> >  28 files changed, 7027 insertions(+), 2156 deletions(-)
> >  create mode 100644 net/ceph/messenger_v1.c
> >  create mode 100644 net/ceph/messenger_v2.c
> >
> > Thanks,
> >
> >                 Ilya
>
> FWIW, I see these warnings when building with this series with W=3D1:
>
> ./include/linux/ceph/msgr.h:37:24: warning: =E2=80=98CEPH_MSGR2_FEATUREMA=
SK_REVISION_1=E2=80=99 defined but not used [-Wunused-const-variable=3D]
>    37 |  static const uint64_t CEPH_MSGR2_FEATUREMASK_##name =3D         =
   \
>       |                        ^~~~~~~~~~~~~~~~~~~~~~~
> ./include/linux/ceph/msgr.h:43:1: note: in expansion of macro =E2=80=98DE=
FINE_MSGR2_FEATURE=E2=80=99
>    43 | DEFINE_MSGR2_FEATURE( 0, 1, REVISION_1)   // msgr2.1
>       | ^~~~~~~~~~~~~~~~~~~~
> ./include/linux/ceph/msgr.h:36:24: warning: =E2=80=98CEPH_MSGR2_FEATURE_R=
EVISION_1=E2=80=99 defined but not used [-Wunused-const-variable=3D]
>    36 |  static const uint64_t CEPH_MSGR2_FEATURE_##name =3D (1ULL << bit=
); \
>       |                        ^~~~~~~~~~~~~~~~~~~
> ./include/linux/ceph/msgr.h:43:1: note: in expansion of macro =E2=80=98DE=
FINE_MSGR2_FEATURE=E2=80=99
>    43 | DEFINE_MSGR2_FEATURE( 0, 1, REVISION_1)   // msgr2.1
>       | ^~~~~~~~~~~~~~~~~~~~
>
> It's probably easy to fix, but I haven't looked in detail yet.

Yeah, consider it fixed.  (I probably need to start building with
W=3D1, considering that people seem to have started caring about it
these days...)

Thanks,

                Ilya
